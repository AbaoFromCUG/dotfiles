from kitty.boss import Boss
from kittens.tui.handler import result_handler
from kittens.tui.handler import kitten_ui
from kittens.tui.loop import debug
import os


@kitten_ui(allow_remote_control=True)
def main(args: list[str]) -> str:
    title = input("Enter the name of session: ")
    debug(f"Renaming tab to: {title}")
    return title


# @result_handler(no_ui=False)
def handle_result(
    args: list[str], session_name: str, target_window_id: int, boss: Boss
) -> None:
    if session_name is None or session_name == "":
        return
    for tab in boss.all_tabs:
        tab.created_in_session_name = session_name
        for win in tab.windows:
            win.created_in_session_name = session_name
