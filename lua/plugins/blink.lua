return {
    {
        'Saghen/blink.cmp',
        lazy = false, -- 讓它啟動時直接接管補全
        version = 'v0.*', -- 使用 stable 版本

	event = { "InsertEnter", "BufReadPost", "BufNewFile" },
        
        opts = {
            keymap = { 
            -- 補全選單的外觀優化（可加可不加，建議先用預設）
		completion = {
		    trigger = {
			auto_show = true,
		    },
		    menu = { border = 'rounded' },
		    documentation = { window = { border = 'rounded' } },
		},

		
		preset = 'none',
		
                -- 【流派一：自動彈出】平常打字（英文、底線等）時，選單自己默默跳出來，完全不用按鍵召喚
                -- 【流派二：手動強行召喚】當你按掉選單，或者打字中間隔了空格，想「強行」把選單叫回來時：
                -- 絕對不要用 Space 開頭！我們用 `<C-space>` 之外最順手的 `<C-j>`。
                ['<C-e>'] = { 'hide' },
                
                -- 【精華所在】選單「已經出現」時的劫持邏輯：
                -- 只要選單在畫面上，這時按 Tab 就不會跳格，而是往下選；按 Enter 不會換行，而是確認！
                ['<CR>'] = { 'accept', 'fallback' },
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },

                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            },


            -- 預設啟動的補全來源
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            
        },
    }
}
