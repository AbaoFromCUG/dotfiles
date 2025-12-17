from kitty.boss import Boss
from kittens.tui.handler import result_handler
from kittens.tui.handler import kitten_ui
from kittens.tui.loop import debug
import os
import sys


@kitten_ui(allow_remote_control=True)
def main(args: list[str]) -> str:
    cp = main.remote_control(["kitten", "session/name.py"], capture_output=True)
    print(cp)
    debug(cp)
    print(cp)
    if cp.returncode != 0:
        sys.stderr.write(f"Error getting session name: {cp.stderr.decode()}\n")
        raise SystemExit(cp.returncode)
    sys.stderr.write(f"getting session name: {cp.stdout.decode()}\n")

    return cp.stdout.decode().strip()


@result_handler(no_ui=True)
def handle_result(
    args: list[str], session_name: str, target_window_id: int, boss: Boss
) -> None:
    print(session_name)
    debug(session_name)
    if session_name is None or session_name == "":
        return
    for tab in boss.all_tabs:
        tab.created_in_session_name = session_name
        for win in tab.windows:
            win.created_in_session_name = session_name
