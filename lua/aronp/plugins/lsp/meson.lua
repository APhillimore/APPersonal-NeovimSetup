return {
	-- LSP servers
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"ts_ls",
				"eslint",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"emmet_ls",
				"graphql",
				"lua_ls",
				"pyright",
				"rust_analyzer",
				"clangd",
			},
		},
	},

	-- External formatter / tool binaries (used by conform.nvim)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = {
				"prettier",
				"ruff",
				"clang-format",
				"stylua",
				"cmakelang",
			},
		},
	},

	-- Mason UI
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
}
