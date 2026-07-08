#!/usr/bin/env python3
"""Generate sing-box outbounds from mihomo proxy providers."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any


TEST_URL = "https://www.gstatic.com/generate_204"
EXCLUDE_PATTERN = re.compile(r"套餐|流量|群组|频道|官网|推荐使用|测试|电报|订阅|地址|佣金", re.IGNORECASE)
REGION_PATTERNS = {
    "香港": re.compile(r"港|hk|hongkong|hong kong", re.IGNORECASE),
    "台湾": re.compile(r"台|tw|taiwan", re.IGNORECASE),
    "日本": re.compile(r"日|jp|japan", re.IGNORECASE),
    "新加坡": re.compile(r"新|sg|singapore", re.IGNORECASE),
    "美国": re.compile(r"美|us|unitedstates|united states", re.IGNORECASE),
}
BASE_POLICY = [
    "默认",
    "香港",
    "香港自动选择",
    "台湾",
    "台湾自动选择",
    "日本",
    "日本自动选择",
    "新加坡",
    "新加坡自动选择",
    "美国",
    "美国自动选择",
    "其它地区",
    "全部节点",
    "自动选择",
    "直连",
]


def run_json(command: list[str], input_text: str | None = None) -> Any:
    process = subprocess.run(
        command,
        input=input_text,
        text=True,
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    return json.loads(process.stdout)


def load_yaml(path: Path) -> Any:
    return run_json(["yq", "-o=json", ".", str(path)])


def load_subscription(url: str, headers: dict[str, Any], cache_path: Path, no_fetch: bool) -> Any:
    if no_fetch:
        if not cache_path.exists():
            return {"proxies": []}
        return load_yaml(cache_path)

    command = ["curl", "-fsSL", url]
    for name, value in headers.items():
        if isinstance(value, list):
            value = value[0]
        command.extend(["-H", f"{name}: {value}"])

    response = subprocess.run(command, text=True, check=True, stdout=subprocess.PIPE)
    cache_path.write_text(response.stdout, encoding="utf-8")

    with tempfile.NamedTemporaryFile("w", suffix=".yaml", delete=False, encoding="utf-8") as temp:
        temp.write(response.stdout)
        temp_path = Path(temp.name)
    try:
        return load_yaml(temp_path)
    finally:
        temp_path.unlink(missing_ok=True)


def value(proxy: dict[str, Any], *names: str, default: Any = None) -> Any:
    for name in names:
        if name in proxy and proxy[name] is not None:
            return proxy[name]
    return default


def tls_options(proxy: dict[str, Any]) -> dict[str, Any] | None:
    enabled = bool(value(proxy, "tls", default=False))
    if not enabled:
        return None

    options: dict[str, Any] = {"enabled": True}
    server_name = value(proxy, "servername", "sni")
    if server_name:
        options["server_name"] = server_name
    if value(proxy, "skip-cert-verify", "allowInsecure", default=False):
        options["insecure"] = True
    alpn = value(proxy, "alpn")
    if alpn:
        options["alpn"] = alpn
    return options


def transport_options(proxy: dict[str, Any]) -> dict[str, Any] | None:
    network = value(proxy, "network")
    if not network:
        return None

    if network == "ws":
        headers = value(proxy, "ws-headers", "headers", default={}) or {}
        transport: dict[str, Any] = {
            "type": "ws",
            "path": value(proxy, "ws-path", "path", default="/"),
        }
        if headers:
            transport["headers"] = headers
        return transport

    if network == "grpc":
        service_name = value(proxy, "grpc-service-name", "serviceName", default="")
        transport = {"type": "grpc"}
        if service_name:
            transport["service_name"] = service_name
        return transport

    if network in {"httpupgrade", "http"}:
        return {
            "type": "httpupgrade",
            "path": value(proxy, "path", default="/"),
        }

    raise ValueError(f"unsupported transport network: {network}")


def convert_proxy(proxy: dict[str, Any]) -> dict[str, Any]:
    proxy_type = value(proxy, "type")
    tag = value(proxy, "name")
    server = value(proxy, "server")
    port = value(proxy, "port")
    if not proxy_type or not tag or not server or not port:
        raise ValueError("missing one of required fields: type/name/server/port")

    outbound_type = "shadowsocks" if proxy_type == "ss" else proxy_type
    outbound: dict[str, Any] = {
        "type": outbound_type,
        "tag": tag,
        "server": server,
        "server_port": int(port),
    }

    if proxy_type == "ss":
        outbound["method"] = value(proxy, "cipher", "method")
        outbound["password"] = value(proxy, "password")
        plugin = value(proxy, "plugin")
        if plugin:
            raise ValueError(f"unsupported shadowsocks plugin: {plugin}")
    elif proxy_type == "vmess":
        outbound["uuid"] = value(proxy, "uuid")
        outbound["security"] = value(proxy, "cipher", default="auto")
        outbound["alter_id"] = int(value(proxy, "alterId", "alter-id", default=0))
        if tls := tls_options(proxy):
            outbound["tls"] = tls
        if transport := transport_options(proxy):
            outbound["transport"] = transport
    elif proxy_type == "trojan":
        outbound["password"] = value(proxy, "password")
        outbound["tls"] = tls_options(proxy) or {"enabled": True}
        if transport := transport_options(proxy):
            outbound["transport"] = transport
    elif proxy_type == "vless":
        outbound["uuid"] = value(proxy, "uuid")
        flow = value(proxy, "flow")
        if flow:
            outbound["flow"] = flow
        if tls := tls_options(proxy):
            outbound["tls"] = tls
        if transport := transport_options(proxy):
            outbound["transport"] = transport
    elif proxy_type == "hysteria2":
        outbound["password"] = value(proxy, "password")
        if tls := tls_options(proxy):
            outbound["tls"] = tls
        obfs = value(proxy, "obfs")
        if obfs:
            outbound["obfs"] = {"type": obfs, "password": value(proxy, "obfs-password", default="")}
    else:
        raise ValueError(f"unsupported proxy type: {proxy_type}")

    return {key: item for key, item in outbound.items() if item not in (None, "")}


def group(name: str, outbounds: list[str], group_type: str = "selector", default: str | None = None) -> dict[str, Any]:
    outbound: dict[str, Any] = {
        "type": group_type,
        "tag": name,
        "outbounds": outbounds or ["直连"],
    }
    if group_type == "urltest":
        outbound["url"] = TEST_URL
        outbound["interval"] = "5m"
        outbound["tolerance"] = 10
    if default:
        outbound["default"] = default
    return outbound


def make_groups(node_tags: list[str]) -> list[dict[str, Any]]:
    region_tags = {
        name: [tag for tag in node_tags if pattern.search(tag)]
        for name, pattern in REGION_PATTERNS.items()
    }
    other_regions = [
        tag
        for tag in node_tags
        if not any(pattern.search(tag) for pattern in REGION_PATTERNS.values())
    ]
    foreign_tags = [tag for tag in node_tags if not REGION_PATTERNS["香港"].search(tag)]

    groups = [
        group(
            "默认",
            [
                "自动选择",
                "直连",
                "香港",
                "香港自动选择",
                "台湾",
                "台湾自动选择",
                "日本",
                "日本自动选择",
                "新加坡",
                "新加坡自动选择",
                "美国",
                "美国自动选择",
                "其它地区",
                "全部节点",
            ],
            default="自动选择",
        ),
        group("自动选择", node_tags, "urltest"),
        group("全部节点", node_tags),
        group("香港", region_tags["香港"]),
        group("台湾", region_tags["台湾"]),
        group("日本", region_tags["日本"]),
        group("新加坡", region_tags["新加坡"]),
        group("美国", region_tags["美国"]),
        group("其它地区", other_regions),
        group("外国自动选择", foreign_tags, "urltest"),
        group("香港自动选择", region_tags["香港"], "urltest"),
        group("台湾自动选择", region_tags["台湾"], "urltest"),
        group("日本自动选择", region_tags["日本"], "urltest"),
        group("美国自动选择", region_tags["美国"], "urltest"),
        group("新加坡自动选择", region_tags["新加坡"], "urltest"),
    ]

    service_groups = [
        "Google",
        "Apple",
        "Telegram",
        "Twitter",
        "ehentai",
        "哔哩哔哩",
        "哔哩东南亚",
        "巴哈姆特",
        "YouTube",
        "NETFLIX",
        "Spotify",
        "其他",
    ]
    groups.extend(group(name, BASE_POLICY, default="默认") for name in service_groups)
    groups.append(
        group(
            "ChatGPT",
            [
                "默认",
                "新加坡",
                "新加坡自动选择",
                "美国",
                "美国自动选择",
                "香港",
                "外国自动选择",
                "香港自动选择",
                "台湾",
                "台湾自动选择",
                "日本",
                "日本自动选择",
                "其它地区",
                "全部节点",
                "自动选择",
                "直连",
            ],
            default="默认",
        )
    )
    groups.append(group("国内", ["直连", *BASE_POLICY[0:-1]], default="直连"))
    return groups


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mihomo-config", type=Path, default=Path("../mihomo/config.local.yaml"))
    parser.add_argument("--output", type=Path, default=Path("config.generated.json"))
    parser.add_argument("--cache-dir", type=Path, default=Path(".cache"))
    parser.add_argument("--no-fetch", action="store_true")
    args = parser.parse_args()

    mihomo_config = load_yaml(args.mihomo_config)
    providers = mihomo_config.get("proxy-providers", {})
    args.cache_dir.mkdir(parents=True, exist_ok=True)

    nodes: list[dict[str, Any]] = []
    skipped: list[str] = []
    for provider_name, provider in providers.items():
        subscription = load_subscription(
            provider["url"],
            provider.get("header", {}),
            args.cache_dir / f"{provider_name}.yaml",
            args.no_fetch,
        )
        proxies = subscription.get("proxies", [])
        for proxy in proxies:
            name = value(proxy, "name", default="")
            if EXCLUDE_PATTERN.search(name):
                continue
            try:
                nodes.append(convert_proxy(proxy))
            except ValueError as error:
                skipped.append(f"{provider_name}/{name}: {error}")

    seen: set[str] = set()
    deduped_nodes: list[dict[str, Any]] = []
    for node in nodes:
        if node["tag"] in seen:
            continue
        seen.add(node["tag"])
        deduped_nodes.append(node)

    node_tags = [node["tag"] for node in deduped_nodes]
    config = {
        "outbounds": [*deduped_nodes, *make_groups(node_tags)],
    }
    args.output.write_text(json.dumps(config, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    if skipped:
        print("Skipped unsupported proxies:", file=sys.stderr)
        for item in skipped:
            print(f"  - {item}", file=sys.stderr)
    print(f"Generated {len(deduped_nodes)} nodes into {args.output}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
