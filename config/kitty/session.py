from kitty.boss import Boss
from kittens.tui.handler import result_handler
from kittens.tui.loop import debug
import os


def main(args: list[str]) -> str:
    session_name = os.environ.get("KITTY_SESSION")
    debug("Current session name:", session_name)
    debug(args)


@result_handler(no_ui=True)
def handle_result(
    args: list[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    tab = boss.active_tab
    print("Active session: ", list(boss.all_loaded_session_names))
    if tab is not None:
        if tab.current_layout.name == "stack":
            tab.last_used_layout()
        else:
            tab.goto_layout("stack")
