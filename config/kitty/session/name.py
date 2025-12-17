import sys

from kittens.tui.loop import debug
from kittens.tui.handler import result_handler
from kitty.boss import Boss


def main(args: list[str]) -> str:
    pass


@result_handler(no_ui=True)
def handle_result(
    args: list[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    session_name = boss.active_session
    if session_name is None or session_name == "":
        boss.get_line()
        return
    sys.stdout.write(f"active_session: {boss.active_session}")
    print(f"active_session: {boss.active_session}")

