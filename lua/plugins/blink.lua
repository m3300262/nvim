return {
    {
        'Saghen/blink.cmp',
        lazy = false, -- 讓它啟動時直接接管補全
        version = 'v0.*', -- 使用 stable 版本
        
        opts = {
            -- 使用 'default' 鍵位設定：
            -- <C-space> 觸發補全, <CR> 確認, <Tab> 下一個, <S-Tab> 上一個
            -- <C-e> 取消, <C-f> 展開/往下滾動
            keymap = { preset = 'default' },

            -- 預設啟動的補全來源
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            
            -- 補全選單的外觀優化（可加可不加，建議先用預設）
            completion = {
                menu = { border = 'rounded' },
                documentation = { window = { border = 'rounded' } },
            },
        },
    }
}
