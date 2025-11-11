local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local group = vim.api.nvim_create_augroup("CodeCompanionProgress", { clear = true })
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestStreaming", "CodeCompanionRequestFinished" },
    group = group,
    callback = function(request)
        local msg = request.match:gsub("CodeCompanionRequest", "")
        vim.notify(msg .. "...", vim.log.levels.INFO, {
            id = request.data.id,
            title = "Code Companion",
            opts = function(notif)
                notif.icon = ""
                if msg == "Finished" then
                    notif.icon = " "
                else
                    notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                end
            end,

            keep = function() return msg ~= "Finished" end,
        })
    end,
})
local chat_prompt = [[
你是一个名为 “CodeCompanion” 的 AI 编程助手，在 Neovim 文本编辑器中工作。

你可以回答一般编程问题并执行以下任务：
* 回答一般编程问题。
* 解释 Neovim 缓冲区中代码的工作原理。
* 审查 Neovim 缓冲区中选中的代码。
* 为选中的代码生成单元测试。
* 为选中的代码提出修复建议。
* 为新的工作区生成脚手架代码。
* 查找与用户查询相关的代码。
* 为测试失败提出修复建议。
* 回答关于 Neovim 的问题。

严格并逐字遵循用户的要求。
使用用户提供的上下文和附件。
保持回答简短且客观，尤其当用户提供的上下文超出你核心任务时。
所有非代码文本响应必须使用 ${language} 语言撰写。
在回答中使用 Markdown 格式。
不要使用 H1 或 H2 的 Markdown 标题。
在建议代码更改或新内容时，使用 Markdown 代码块。
要开始代码块，使用 4 个反引号（````），在反引号之后添加编程语言名称作为语言 ID。
要关闭代码块，使用 4 个反引号新起一行。
如果代码修改现有文件或应放在特定位置，添加一行注释 'filepath:' 和文件路径。
如果你希望用户决定代码放置位置，则不要添加文件路径注释。
在代码块中，使用一行注释 '...existing code...' 来表示文件中已经存在的代码。
代码块示例：
````languageId
// filepath: /path/to/file
// ...existing code...
{ changed code }
// ...existing code...
{ changed code }
// ...existing code...
````
确保行注释使用与编程语言相对应的正确语法（例如 Python 使用 "#"，Lua 使用 "--"）。
对于代码块，使用四个反引号开始和结束。
避免将整个响应包裹在三个反引号内。
除非明确要求，不要包含 diff（差异）格式。
不要在代码块中包含行号。

当接到任务时：
1. 逐步思考，除非用户另有要求或任务非常简单，否则用伪代码描述你的计划。
2. 在输出代码块时，仅包含相关代码，避免重复或无关代码。
3. 在回答末尾提供一个简短建议，提示用户下一步可以做什么，以便直接支持继续对话。

附加上下文：
当前日期为 ${date}。
用户的 Neovim 版本为 ${version}。
用户正在 ${os} 机器上工作。如果适用，请提供与系统相关的命令。请使用系统特定命令时同时提供相应说明。

]]

---@type LazySpec[]
return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "ravitemer/codecompanion-history.nvim",
        },
        cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
        opts = {
            language = "Chinese",
            display = {
                chat = {
                    show_settings = true,
                },
            },
            strategies = {
                chat = {
                    adapter = "copilot",
                    opts = {
                        system_prompt = chat_prompt,
                    },
                },
                inline = {
                    adapter = "copilot",
                    keymaps = {
                        accept_change = {
                            modes = { n = "gaa" },
                        },
                        reject_change = {
                            modes = { n = "gar" },
                        },
                    },
                },
            },
            extensions = {
                history = {
                    enabled = true,
                    opts = {},
                },
            },
        },
        keys = {
            { "<leader>a", group = true, desc = "ai", mode = { "v", "n" } },
            { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "inline assistant", mode = { "v", "n" } },
            { "<leader>ac", "<cmd>CodeCompanionChat<cr>", desc = "chat assistant", mode = { "v", "n" } },
            { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "action palette", mode = { "v", "n" } },
        },
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            disable_limit_reached_message = true,
            filetypes = {
                markdown = true,
                -- cpp = false,
                javascript = true,
                typescript = true,
                typescriptreact = true,

                ["*"] = function()
                    local forbidden_patterns = { "^.*%.local", "^%.env.*", ".*interview.*" }
                    local basename = vim.fs.basename(vim.fn.bufname())
                    local forbidden = vim.iter(forbidden_patterns):any(function(pattern) return not not basename:match(pattern) end)
                    -- vim.print(forbidden)
                    return not forbidden
                end,
            },
        },
        config = function(_, opts) require("copilot").setup(opts) end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "AndreM222/copilot-lualine",
        opts = {
            sections = {
                lualine_x = { "copilot" },
            },
        },
    },
    {
        "saghen/blink.cmp",
        dependencies = { "fang2hou/blink-copilot" },
        opts = {
            sources = {
                default = { "copilot" },
                per_filetype = {
                    codecompanion = { "buffer", "codecompanion" },
                },
                providers = {
                    copilot = {
                        name = "Copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                        opts = {
                            kind_name = "Copilot",
                            kind_icon = "",
                        },
                    },
                },
            },

            completion = {
                trigger = {
                    prefetch_on_insert = false,
                },
            },
            keymap = {},
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = function(_, ft)
            table.insert(ft, "codecompanion")
            return ft
        end,
    },
}
