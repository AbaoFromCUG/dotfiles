#!/bin/bash

# 定义机器信息：机器名 业务IP BMC_IP
machines=(
"cpu0 10.16.94.203 10.16.94.137"
"cpu1 10.16.68.166 ''"
"cpu2 172.18.36.73 10.16.94.138"
"node1 172.18.36.71 172.18.36.165"
"node2 172.18.36.72 172.18.36.166"
"node3 172.18.36.164 172.18.36.167"
"node4 10.16.95.155 10.16.98.38"
)

check_ping() {
    local name=$1
    local type=$2
    local ip=$3

    # 去掉CIDR后缀（例如 /17）
    ip=$(echo "$ip" | cut -d/ -f1)

    if [[ -z "$ip" || "$ip" == "''" ]]; then
        printf "%-8s %-6s %-18s SKIP\n" "$name" "$type" "EMPTY"
        return
    fi

    if ping -c 2 -W 1 "$ip" >/dev/null 2>&1; then
        printf "%-8s %-6s %-18s PASS\n" "$name" "$type" "$ip"
    else
        printf "%-8s %-6s %-18s FAIL\n" "$name" "$type" "$ip"
    fi
}

echo "开始检测网络连通性..."
echo "-----------------------------------------------"
printf "%-8s %-6s %-18s RESULT\n" "HOST" "TYPE" "IP"
echo "-----------------------------------------------"

for machine in "${machines[@]}"; do
    eval "set -- $machine"
    host=$1
    ip=$2
    bmc=$3

    check_ping "$host" "IP" "$ip"
    check_ping "$host" "BMC" "$bmc"
done

echo "-----------------------------------------------"
echo "检测完成"
