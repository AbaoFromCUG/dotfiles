------------------
---- MONITORS ----
------------------


function update_monitor()
    local laptop_monitor = hl.get_monitor("desc:Lenovo Group Limited 0x8AAF")

    if laptop_monitor then
        local dell_moitor = hl.get_monitor("desc:Dell Inc. DELL S2721DS 5GWMQ43")
        if dell_moitor then
            hl.monitor({
                output    = dell_moitor.name,
                mode      = "2560x1440@59.95",
                position  = "0x0",
                scale     = 1,
                transform = 1,
            })
        end

        local apple_studio = hl.get_monitor("desc:Apple Computer Inc StudioDisplay 0xB46EA92B")
        if apple_studio then
            hl.monitor({
                output   = apple_studio.name,
                mode     = "5120x2880@60",
                position = dell_moitor and "1440x560" or "0x0",
                scale    = 2,
            })
        end
        local pos = "0x0"
        if dell_moitor and apple_studio then
            pos = "4000x800"
        elseif dell_moitor then
            pos = "1440x800"
        elseif apple_studio then
            pos = "2560x240"
        end
        hl.monitor({
            output   = laptop_monitor.name,
            mode     = "3072x1920@60",
            position = pos,
            scale    = "auto",
        })

        -- trigger when the switch is turning on
        hl.bind("switch:on:Lid Switch", function()
            hl.notification.create({
                text = "Lid closed",
                duration = 3000,

            })
            -- hl.dispatch(hl.dispatch)
            hl.monitor({
                output = laptop_monitor.name,
                disabled = true,
            })
        end)


        hl.bind("switch:off:Lid Switch", function()
            hl.notification.create({
                text = "Lid opened",
                duration = 3000,
            })
            hl.monitor({
                output = laptop_monitor.name,
                disabled = false,
            })
        end)
    else
        hl.monitor({
            output   = "",
            mode     = "preferred",
            position = "auto",
            scale    = "auto",
        })
    end
end

hl.on("config.reloaded", update_monitor)
hl.on("hyprland.start", update_monitor)
hl.on("monitor.added", update_monitor)
hl.on("monitor.removed", update_monitor)

update_monitor()
