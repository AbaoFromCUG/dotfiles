local session_env = table.concat({
    "WAYLAND_DISPLAY",
    "DISPLAY",
    "XAUTHORITY",
    "XDG_CURRENT_DESKTOP",
    "HYPRLAND_INSTANCE_SIGNATURE",
    "XDG_SESSION_TYPE",
    "XDG_SESSION_DESKTOP",
    "QT_IM_MODULE",
    "XMODIFIERS",
    "SDL_IM_MODULE",
    "GLFW_IM_MODULE",
    "INPUT_METHOD",
}, " ")

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment " .. session_env)
    hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

hl.exec_cmd("systemctl --user import-environment " .. session_env)
hl.exec_cmd("systemctl --user start hyprland-session.target")
