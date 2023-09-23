return function(config)
    local settings = require("integrator.settings")
    config.on_init = function(client)
        client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
            ["rust-analyzer"] = settings.get_setting("rust-analyzer"),
        })
        print("rust-analyser init client.settings = " .. settings.get_setting("rust-analyzer"))
    end
    config.on_new_config = function(new_config, new_root_dir)
        print("rust-analyser on_new_config: " .. new_config .. "  " .. new_root_dir)
    end
    -- { settings = { ["rust-analyzer"] = {cargo=} }}
    config.settings = {
        ["rust-analyzer"] = settings.get_setting("rust-analyzer"),
    }
end
