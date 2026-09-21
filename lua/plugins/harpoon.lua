return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2", -- 強烈建議用新版的 harpoon2，你的 setup() 語法才是對的
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            -- 【核心關鍵】只有進到這裡，harpoon 才是真正下載完成、可以被 require 的狀態
            local harpoon = require("harpoon")
            harpoon:setup()

            -- 1. 標記檔案
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon Add File" })

            -- 2. 打開選單 (改用 <leader>h 避開與 blink.cmp 的 <C-e> 衝突)
            vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Menu" })

            -- 3. 快速切換檔案 (改用 Alt + j/k，不卡 <C-p>/<C-n>)
            vim.keymap.set("n", "<C-j>", function() harpoon:list():next() end, { desc = "Harpoon Next" })
            vim.keymap.set("n", "<C-k>", function() harpoon:list():prev() end, { desc = "Harpoon Prev" })
	    vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end, {desc = "Harpoon File 1" })
	    vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end, {desc = "Harpoon File 2" })
	    vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end, {desc = "Harpoon File 3" })
	    vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end, {desc = "Harpoon File 4" })

            -- 4. 你的 Telescope 整合版
            vim.keymap.set("n", "<leader>fl", function()
                local conf = require("telescope.config").values
                local themes = require("telescope.themes")
                local file_paths = {}
                for _, item in ipairs(harpoon:list().items) do
                    table.insert(file_paths, item.value)
                end
                require("telescope.pickers").new(themes.get_ivy({ prompt_title = "Working List" }), {
                    finder = require("telescope.finders").new_table({ results = file_paths }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end, { desc = "Telescope Harpoon List" })
        end
    }
}

