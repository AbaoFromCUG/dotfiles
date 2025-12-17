from kitty.boss import get_boss, Boss
from kitty.fast_data_types import Screen, add_timer
from kitty.rgb import to_color
from datetime import datetime
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)
 
GREEN = as_rgb(int(to_color("#98c379")))
BLUE = as_rgb(int(to_color("#61afef")))
CYAN = as_rgb(int(to_color("#56b6c2")))
WHITE = as_rgb(int(to_color("#d9d9d9")))
BLACK = as_rgb(int(to_color("#000000")))
YELLOW = as_rgb(int(to_color("#e5c07b")))
ORANGE = as_rgb(int(to_color("#d19a66")))
LIGHT_GREY = as_rgb(int(to_color("#383444")))
GREY = as_rgb(int(to_color("#303030")))
PURPLE = as_rgb(int(to_color("#c678dd")))
RED = as_rgb(int(to_color("#e06c75")))

background=as_rgb(int(to_color("#222436")))
foreground=as_rgb(int(to_color("#c8d3f5")))
selection_background=as_rgb(int(to_color("#2d3f76")))
selection_foreground=as_rgb(int(to_color("#c8d3f5")))
url_color=as_rgb(int(to_color("#4fd6be")))
cursor=as_rgb(int(to_color("#c8d3f5")))
cursor_text_color=as_rgb(int(to_color("#222436")))

# Tabs
active_tab_background=as_rgb(int(to_color("#82aaff")))
active_tab_foreground=as_rgb(int(to_color("#1e2030")))
inactive_tab_background=as_rgb(int(to_color("#2f334d")))
inactive_tab_foreground=as_rgb(int(to_color("#545c7e")))
#tab_bar_background=as_rgb(int(to_color("#1b1d2b")))

# Windows
active_border_color=as_rgb(int(to_color("#82aaff")))
inactive_border_color=as_rgb(int(to_color("#2f334d")))

# normal
color0=as_rgb(int(to_color("#1b1d2b")))
color1=as_rgb(int(to_color("#ff757f")))
color2=as_rgb(int(to_color("#c3e88d")))
color3=as_rgb(int(to_color("#ffc777")))
color4=as_rgb(int(to_color("#82aaff")))
color5=as_rgb(int(to_color("#c099ff")))
color6=as_rgb(int(to_color("#86e1fc")))
color7=as_rgb(int(to_color("#828bb8")))

# bright
color8=as_rgb(int(to_color("#444a73")))
color9=as_rgb(int(to_color("#ff8d94")))
color10=as_rgb(int(to_color("#c7fb6d")))
color11=as_rgb(int(to_color("#ffd8ab")))
color12=as_rgb(int(to_color("#9ab8ff")))
color13=as_rgb(int(to_color("#caabff")))
color14=as_rgb(int(to_color("#b2ebff")))
color15=as_rgb(int(to_color("#c8d3f5")))

# extended colors
color16=as_rgb(int(to_color("#ff966c")))
color17=as_rgb(int(to_color("#c53b53")))

BATTERY_FG = {
    10: RED,
    20: ORANGE,
    30: YELLOW,
    40: GREEN,
    100: GREEN,
}
 
ICON = " 󰌪 |"
TERMINAL_ICON = " "
HOSTNAME_ICON = "󱇯"
NET_ICON = "  "
LEFT_HALF_CIRCLE = ""
RIGHT_HALF_CIRCLE = ""
RIGHT_SLANT = ""
SOFT_RSLANT = ""
REV_RSLANT = ""
LEFT_SLANT = ""
SYS_SEP = "||"
CHARGING_ICON = " 󰚥"
BATTERY_ICON = " 󰁹"


REFRESH_TIME = 1 



def _draw_icon(screen: Screen, index: int) -> int:
    if index != 1:
        return 0

    fg, bg = screen.cursor.fg, screen.cursor.bg
    screen.cursor.fg = BLACK
    screen.cursor.bg = WHITE
    screen.draw(ICON)
    screen.cursor.fg = fg
    screen.cursor.bg = bg
    screen.cursor.x = len(ICON)
    return screen.cursor.x


def _draw_tailscale(screen: Screen) -> int:
    fg, bg = screen.cursor.fg, screen.cursor.bg

    screen.cursor.fg = GREY
    screen.cursor.bg = WHITE
    screen.draw(REV_RSLANT)

    screen.cursor.fg = PURPLE
    screen.cursor.bg = GREY
    screen.draw(NET_ICON)

    screen.cursor.fg = WHITE
    screen.draw("100.112.62.60 ")

    screen.cursor.fg = GREY
    screen.cursor.bg = BLACK
    screen.draw(RIGHT_HALF_CIRCLE)

    screen.cursor.fg = fg
    screen.cursor.bg = bg
    screen.cursor.x = len(REV_RSLANT) + len(NET_ICON) + 14 + len(RIGHT_HALF_CIRCLE)
    return screen.cursor.x



def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    right_status_length = 1
    for c in _create_cells():
        right_status_length += 3 + len(c["icon"]) + len(c["text"])

    if screen.cursor.x >= screen.columns - right_status_length:
        return screen.cursor.x

    if screen.cursor.x <= len(ICON):
        screen.cursor.x = len(ICON)

    screen.cursor.bg = WHITE
    screen.draw(" ")
    draw_title(draw_data, screen, tab, index)
    screen.draw(" ")
   
    if is_last:
        _draw_tailscale(screen)

    end = screen.cursor.x
    return end



def _get_hostname_cell() -> dict:
    with open("/etc/hostname", "r") as file:
        hostname = file.read().strip()

    return {"icon": HOSTNAME_ICON, "icon_fg_color": ORANGE, "text": hostname}


def _get_active_process_name_cell() -> dict:
    cell = {"icon": TERMINAL_ICON, "icon_fg_color": GREEN, "text": ""}
    boss: Boss = get_boss()

    if not boss:
        cell["text"] = "Err 1"
        return cell

    active_window = boss.active_window
    if not active_window:
        cell["text"] = "Err 2"
        return cell

    if not active_window.child:
        cell["text"] = "Err 3"
        return cell

    foreground_processes = active_window.child.foreground_processes
    if not foreground_processes or not foreground_processes[0]["cmdline"]:
        cell["text"] = "Err 4"
        return cell

    long_process_name = foreground_processes[0]["cmdline"][0]
    cell["text"] = long_process_name.rsplit("/", 1)[-1]

    return cell


def _get_datetime_cell() -> dict:
    now = datetime.now().strftime(" %d.%m. |  %H:%M ")
    # print(BLUE)

    # return {"icon": "󰥔 ", "icon_fg_color": BLUE, "text": now}

    return {"icon": HOSTNAME_ICON, "icon_fg_color": ORANGE, "text": "H"}


def _get_battery_cell() -> dict:
    cell = {"icon": "", "icon_fg_color": "", "text": ""}

    try:
        with open("/sys/class/power_supply/BAT0/status", "r") as f:
            status = f.read()
        with open("/sys/class/power_supply/BAT0/capacity", "r") as f:
            percent = int(f.read())

        if status == "Charging\n":
            cell["icon"] = CHARGING_ICON
            cell["icon_fg_color"] = CYAN
        else:
            cell["icon"] = BATTERY_ICON
            cell["icon_fg_color"] = BATTERY_FG[
                min(BATTERY_FG.keys(), key=lambda x: abs(percent - x))
            ]
        cell["text"] = str(percent) + "%"

    except FileNotFoundError:
        cell["text"] = "Err"

    return cell


def _create_cells() -> list[dict]:
    return [
        _get_hostname_cell(),
        _get_active_process_name_cell(),
        _get_battery_cell(),
        _get_datetime_cell(),
    ]


def _draw_right_status(screen: Screen, is_last: bool, draw_data: DrawData) -> int:
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)

    cells = _create_cells()
    right_status_length = 2
    for c in cells:
        right_status_length += 3 + len(c["icon"]) + len(c["text"])

    screen.cursor.x = screen.columns - right_status_length

    default_bg = as_rgb(int(draw_data.default_bg))

    screen.cursor.bg = default_bg
    for i in range(len(cells)):
        icon_fg_color = cells[i]["icon_fg_color"]
        screen.cursor.fg = GREY
        if i == len(cells) - 1:
            screen.cursor.fg = WHITE
            screen.cursor.bg = GREY
            screen.draw(LEFT_SLANT)
            screen.cursor.bg = WHITE
            screen.cursor.fg = BLACK
            screen.draw(f" {cells[i]['text']} ")

        else:
            if i == 0:
                screen.draw(LEFT_HALF_CIRCLE)
            else:
                screen.cursor.fg = BLUE
                screen.draw(SYS_SEP)

            screen.cursor.bg = GREY
            screen.cursor.fg = icon_fg_color
            screen.draw(cells[i]["icon"])

            screen.cursor.bg = GREY
            screen.cursor.fg = WHITE
            screen.draw(f" {cells[i]['text']} ")

    return screen.cursor.x


def _redraw_tab_bar(_) -> None:
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


timer_id = None


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)

    _draw_icon(screen, index)
    _draw_left_status(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    _draw_right_status(screen, is_last, draw_data)

    return screen.cursor.x
