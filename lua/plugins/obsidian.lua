return {
    {
        "obsidian-nvim/obsidian.nvim",
        version = "*",
        lazy = true,
        event = {
            "BufReadPre *.md",
            "BufNewFile *.md",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            workspaces = {
                {
                    name = "brain",
                    path = "~/obsidian",
                },
            },

            daily_notes = {
                folder = "dailies",
                date_format = "%Y-%m-%d",
            },

            -- 【修正 1】直接移除 nvim_cmp = false，官方說現在不用寫了

            -- 【修正 2】明確告知不要使用舊版命令，關閉 legacy_commands 警告
            legacy_commands = false,

            -- 【修正 3】修正 checkboxes 的全新語法與欄位名稱
            checkboxes = {
                [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                ["x"] = { char = "", hl_group = "ObsidianDone" },
            },

            ui = {
                enable = true,
                -- 【修正 4】這裡本來不影響，但我們把它保持乾淨
            },
        },
        config = function(_, opts)
            require("obsidian").setup(opts)

            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { desc = "Obsidian: " .. desc })
            end

            -- 【修正 5】因應 legacy_commands = false，指令全部改為新版空格語法
            map("n", "<leader>on", "<cmd>Obsidian new<cr>", "New Note")
            map("n", "<leader>os", "<cmd>Obsidian search<cr>", "Search Notes (Grep)")
            map("n", "<leader>oo", "<cmd>Obsidian open<cr>", "Open in Obsidian App")
            map("n", "<leader>ot", "<cmd>Obsidian template<cr>", "Insert Template")
            map("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", "Show Backlinks")
            
            map("n", "gd", function()
                if require("obsidian").util.cursor_on_markdown_link() then
                    return "<cmd>Obsidian follow_link<cr>" -- 這裡也改為新版底線語法
                else
                    return "gd"
                end
            end, "Follow Link or LSP Define", { expr = true })
        end,
    },
}
