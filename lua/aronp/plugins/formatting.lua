return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- Enable debug logging so the log tells you WHY it didn't format
			-- log_level = vim.log.levels.DEBUG,

			formatters_by_ft = {
				lua = { "stylua" },

				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },

				python = { "ruff_format" },

				c = { "clang_format" },
				cpp = { "clang_format" },
				objc = { "clang_format" },
				objcpp = { "clang_format" },

				rust = { "rustfmt" },
				cmake = { "cmake_format" },
			},
		},
		config = function(_, opts)
			local conform = require("conform")
			conform.setup(opts)

			local group = vim.api.nvim_create_augroup("ConformFormatOnSave", { clear = true })

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = group,
				callback = function(args)
					-- Skip non-file buffers
					if vim.bo[args.buf].buftype ~= "" then
						return
					end
					if not vim.bo[args.buf].modifiable then
						return
					end

					conform.format({
						bufnr = args.buf,
						async = false,
						timeout_ms = 2000,
						lsp_fallback = false,
						quiet = false,
					})
				end,
			})

			-- Manual
			vim.api.nvim_create_user_command("Format", function()
				conform.format({ async = false, timeout_ms = 2000 })
			end, {})
		end,
	},
}
