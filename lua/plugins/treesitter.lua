return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
	    ensure_installed = { "lua", "c", "cpp", "json", "nix", "python", "sql", "bash" },
	    highlight = { enable = true },
	    indent = { enable = true },
	},
	
}
