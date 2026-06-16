require("monitors")

require("plugins")

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "ghostty"

local function ipc(cmd)
    return hl.dsp.exec_cmd("noctalia msg " .. cmd)
end

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    -- 延迟加载 noctalia 的 Lua 配置
    require("noctalia")

    hl.exec_cmd("libinput-gestures-setup start")
    hl.exec_cmd("cfw")
    hl.exec_cmd("pot")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ 1")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("mpd")
    hl.exec_cmd("mpd-mpris")
    hl.exec_cmd("playerctld")
    -- hl.exec_cmd("hyprdynamicmonitors run --enable-lid-events")
end)


---------------------------
---- ENVIRONMENT VARS ----
---------------------------

-- Toolkit backend
hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_QUICK_CONTROLS_STYLE", "org.hyprland.style")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Input method
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "fcitx")
hl.env("INPUT_METHOD", "fcitx")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Applications
hl.env("GRIMBLAST_EDITOR", "ksnip")
hl.env("TERMINAL", "kitty")

hl.config({
  debug = {
    disable_logs = false,
    -- gl_debugging = true, -- 只在查 OpenGL 问题时开
  },
})

-----------------------
----- PERMISSIONS -----
-----------------------
hl.config({
    ecosystem = {

        -- enforce_permissions = true
    }
})

hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
hl.permission("/usr/bin/hyprpicker", "screencopy", "allow")
hl.permission("/usr/bin/grim", "screencopy", "allow")
hl.permission("/usr/bin/hyprlock", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 5,
        border_size = 2,
        resize_on_border = true,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            new_optimizations = true,
        },
        shadow = {
            enabled = false,
            range = 4,
            render_power = 4,
            color = "0x1a1a1aee",
        },
    },

    animations = {
        enabled = true,
        bezier = {
            { "myBezier", "0.05, 0.9, 0.1, 1.05" },
        },
        animation = {
            { "windows",     "1, 7, myBezier" },
            { "windowsOut",  "1, 7, default, popin 80%" },
            { "border",      "1, 10, default" },
            { "borderangle", "1, 8, default" },
            { "fade",        "1, 7, default" },
            { "workspaces",  "1, 6, default" },
        },
    },

    layerrule = {
        {
            name = "noctalia",
            match = { namespace = "noctalia-background-.*$" },
            ignore_alpha = 0.5,
            blur = true,
            blur_popups = true,
        },
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
})


--------------
---- INPUT ----
--------------

hl.config({
    input = {
        sensitivity = 0,
        kb_layout = "us",
        follow_mouse = 2,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.5,
        },
    },

    gestures = {
        workspace_swipe_touch = true,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Window management
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))


-- Launcher, locker, terminal
hl.bind(mainMod .. "+Space", ipc("panel-toggle launcher"))
hl.bind(mainMod .. "+S", ipc("panel-toggle control-center"))
hl.bind(mainMod .. "+ comma", ipc("settings-toggle"))
hl.bind(mainMod .. "+ P", ipc("session lock"))

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))


-- Media keys
hl.bind("XF86AudioRaiseVolume", ipc(" volume-up"))
hl.bind("XF86AudioLowerVolume", ipc(" volume-down"))
hl.bind("XF86AudioMute", ipc(" volume-mute"))
hl.bind("XF86MonBrightnessUp", ipc(" brightness-up"))
hl.bind("XF86MonBrightnessDown", ipc(" brightness-down"))


-- Media controls
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))

-- Screenshot / color picker
hl.bind("PRINT", ipc("screenshot-region"))
hl.bind("SHIFT + PRINT", ipc("screenshot-fullscreen all"))
hl.bind("CTRL + PRINT", ipc("screenshot-fullscreen pick"))

-- Brightness controls
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call brightness increase"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("qs -c noctalia-shell ipc call brightness decrease"),
    { repeating = true })

-- Reload
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "down" }))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move window with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.move({ direction = "down" }))

-- Move window with mainMod + SHIFT + hjkl
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Group management
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())

-- CaptureGPT
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("zsh --login --interactive ~/Documents/work/CheatGPT/capture"))

-- Move/resize windows with mainMod + mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
-- hl.bindm(mainMod .. " + mouse:273", hl.dsp.resize.window())
--
-- -- Resize submap
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.submap("resize"))

-- Resize submap
hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

    hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })


    hl.bind("catchall", hl.dsp.submap("reset"))
    hl.bind("ESCAPE", hl.dsp.submap("reset"))
end)



--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------


-- Window rules
hl.window_rule({
    match = {
        class = "org.fcitx.fcitx5-config-qt",
    },
    float = true,
    size = { "(monitor_w*0.5)", "(monitor_h*0.5)" }
})

hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
    },
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})


-- hl.windowrule("match:class ^(clash_win)$, float on")
-- hl.window_rule({
--
-- })
-- hl.windowrule("match:class ^(ario)$, float on")
-- hl.windowrule("match:class ^(QQ)$, float on")
-- hl.windowrule("match:title ^(Picture in picture)$, float on")
-- hl.windowrule("match:title ^(Picture-in-Picture)$, float on")
-- hl.windowrule("match:class ^(io.crow_translate.CrowTranslate)$, float on")
-- hl.windowrule("match:class (pot), match:title (Translate|Translator|OCR|PopClip|Screenshot Translate), float on")
-- hl.windowrule("match:class ^(org.telegram.desktop)$, match:title ^(Media viewer)$, float on")
-- hl.windowrule("match:title ^(Demo-Mode)$, float on")
-- hl.windowrule("match:class ^(Zotero)$, match:title ^(Zotero Settings)$, float on")
-- hl.windowrule("match:class ^(xdg-desktop-portal-gtk)$, float on")
-- hl.windowrule("match:class ^(Meeting)$, match:title ^(Feishu Meetings)$, float on")
-- hl.windowrule("match:title ^(LarkSSPromptWindow)$, no_blur on")
-- hl.windowrule("match:title ^(LarkSSPromptWindow)$, no_focus on")
-- hl.windowrule("match:title ^(wemeetapp)$, no_blur on")
-- hl.windowrule("match:title ^(wemeetapp)$, no_focus on")
--
-- hl.windowrule("match:class ^(xwaylandvideobridge)$, no_focus on, opacity 0.0 override 0.0 override")


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------


hl.config({
    plugin = {
        -- virtual_desktops = {
        --     names = "1:config, 2:coding, 3:work, 4:paper, 5:misc, 6:explorer, 7:zero, 8:media, 9:chat, 10:fish",
        --     cycleworkspaces = 0,
        --     notifyinit = 1,
        --     verbose_logging = 1,
        -- },
    }

})
