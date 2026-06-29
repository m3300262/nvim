return {
    "neovim/nvim-lspconfig", 
    dependencies = {
        -- 1. 把舊的 cmp-nvim-lsp 踢掉，換成新世代的 blink.cmp
        "Saghen/blink.cmp",
        -- 可選：如果你的環境沒有 pre-built 的 binary，可以加上 build = 'cargo build --release'
        -- 但通常從 lazy.nvim 下載 stable 版本都會自帶編譯好的 binary。
    },
    config = function()
        -- 1. 全局 LSP 預設設定
        vim.lsp.config('*', {
            root_markers = { '.git' },
        })

        -- 2. 診斷外觀優化
        vim.diagnostic.config({
            virtual_text  = true,
            severity_sort = true,
            float         = {
                style  = 'minimal',
                border = 'rounded',
                source = 'if_many',
            },
            signs         = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '✘',
                    [vim.diagnostic.severity.WARN]  = '▲',
                    [vim.diagnostic.severity.HINT]  = '⚑',
                    [vim.diagnostic.severity.INFO]  = '»',
                },
            },
        })

        -- 3. 優化 LSP 浮動視窗
        local orig = vim.lsp.util.open_floating_preview
        ---@diagnostic disable-next-line: duplicate-set-field
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts            = opts or {}
            opts.border     = opts.border or 'rounded'
            opts.max_width  = opts.max_width or 80
            opts.max_height = opts.max_height or 24
            opts.wrap       = opts.wrap ~= false
            return orig(contents, syntax, opts, ...)
        end

        -- 4. 綁定快捷鍵
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('my.lsp', {}),
            callback = function(args)
                local buf = args.buf
                local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = buf }) end

                map('n', 'K', vim.lsp.buf.hover)
                map('n', 'gd', vim.lsp.buf.definition)
                map('n', 'gr', vim.lsp.buf.references)
                map('n', 'gl', vim.diagnostic.open_float)
                map('n', '<F2>', vim.lsp.buf.rename)
                map('n', '<F4>', vim.lsp.buf.code_action)
                map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end)
            end,
        })

        -- 5. 【修改重點】改用 blink.cmp 來獲取 LSP 補全能力
        -- 它會幫你注入片段（snippets）支援和更強的補全擴充
        local caps = require("blink.cmp").get_lsp_capabilities()

        -- Lua
        vim.lsp.config['luals'] = {
            cmd = { 'lua-language-server' },
            filetypes = { 'lua' },
            root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
            capabilities = caps,
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = { checkThirdParty = false },
                },
            },
        }

        -- Nix
        vim.lsp.config['nil_ls'] = {
            cmd = { 'nil' },
            filetypes = { 'nix' },
            root_markers = { 'flake.nix', 'default.nix', '.git' },
            capabilities = caps,
        }

        -- Python
        vim.lsp.config['pyright'] = {
            cmd = { 'pyright-langserver', '--stdio' },
            filetypes = { 'python' },
            root_markers = { 'pyproject.toml', 'setup.py', '.git' },
            capabilities = caps,
        }

        -- SQL
        vim.lsp.config['sqlls'] = {
            cmd = { 'sql-language-server', '--stdio' },
            filetypes = { 'sql' },
            capabilities = caps,
        }

        -- Bash
        vim.lsp.config['bashls'] = {
            cmd = { 'bash-language-server', 'start' },
            filetypes = { 'sh', 'bash' },
            root_markers = { '.git' },
            capabilities = caps,
        }

        -- C / C++
        vim.lsp.config['clangd'] = {
            cmd = { 'clangd' },
            filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
            root_markers = { 'compile_commands.json', '.git' },
            capabilities = caps,
        }

        -- JSON
        vim.lsp.config['jsonls'] = {
            cmd = { 'vscode-json-languageserver', '--stdio' },
            filetypes = { 'json', 'jsonc' },
            capabilities = caps,
        }

        -- CSS
        vim.lsp.config['cssls'] = {
            cmd = { 'vscode-css-language-server', '--stdio' },
            filetypes = { 'css', 'scss', 'less' },
            capabilities = caps,
        }

        -- 6. 自動啟動
        ---@diagnostic disable-next-line: invisible
        for name, _ in pairs(vim.lsp.config._configs) do
            if name ~= '*' then
                vim.lsp.enable(name)
            end
        end
    end,
}
