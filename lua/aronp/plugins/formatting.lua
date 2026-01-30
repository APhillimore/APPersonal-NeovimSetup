return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
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
		cmd = {
			"FormatGit",
			"FormatGitChanged",
		},
		config = function(_, opts)
			local conform = require("conform")
			conform.setup(opts)

			local group = vim.api.nvim_create_augroup("ConformFormatOnSave", { clear = true })

			-- Format on save
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

			-- Manual: format current buffer
			vim.api.nvim_create_user_command("Format", function()
				conform.format({ async = false, timeout_ms = 2000 })
			end, {})

			local function get_git_root(start_dir)
				local root = vim.fn.systemlist({ "git", "-C", start_dir, "rev-parse", "--show-toplevel" })[1]
				if not root or root == "" then
					return nil
				end
				return root
			end

			local function format_files(opts2)
				local git_root = opts2.git_root
				local rel_paths = opts2.rel_paths
				local dry_run = opts2.dry_run
				local label = opts2.label or "FormatGit"

				if not rel_paths or #rel_paths == 0 then
					vim.notify(label .. ": no files found", vim.log.levels.INFO)
					return
				end

				local max_size = 1024 * 1024
				local visited, changed, written = 0, 0, 0

				for _, rel in ipairs(rel_paths) do
					if rel and rel ~= "" then
						local file = git_root .. "/" .. rel
						local stat = vim.uv.fs_stat(file)

						if stat and stat.type == "file" and stat.size <= max_size then
							local bufnr = vim.fn.bufadd(file)
							vim.fn.bufload(bufnr)

							-- Ensure filetype detection runs for programmatically loaded buffers
							vim.api.nvim_buf_call(bufnr, function()
								vim.cmd("filetype detect")
							end)

							visited = visited + 1

							conform.format({
								bufnr = bufnr,
								async = false,
								timeout_ms = 2000,
								lsp_fallback = false,
								quiet = true,
							})

							vim.api.nvim_buf_call(bufnr, function()
								if vim.bo.modified then
									changed = changed + 1
									if dry_run then
										vim.notify(("Would format: %s"):format(file), vim.log.levels.INFO)
									else
										vim.cmd("write")
										written = written + 1
									end
								end
							end)

							vim.api.nvim_buf_delete(bufnr, { force = true })
						end
					end
				end

				vim.notify(
					("%s%s: visited %d, changed %d, wrote %d"):format(
						label,
						dry_run and " (dry-run)" or "",
						visited,
						changed,
						written
					),
					vim.log.levels.INFO
				)
			end

			-- Format repo files (tracked + untracked, excluding ignored)
			vim.api.nvim_create_user_command("FormatGit", function(cmdopts)
				local dry_run = cmdopts.bang
				local start_dir = cmdopts.args ~= "" and vim.fn.fnamemodify(cmdopts.args, ":p") or vim.fn.getcwd()

				local git_root = get_git_root(start_dir)
				if not git_root then
					vim.notify("FormatGit: not a git repo: " .. start_dir, vim.log.levels.ERROR)
					return
				end

				-- tracked + untracked, but respect .gitignore and standard excludes
				local files = vim.fn.systemlist({ "git", "-C", git_root, "ls-files", "-co", "--exclude-standard" })

				format_files({
					git_root = git_root,
					rel_paths = files,
					dry_run = dry_run,
					label = "FormatGit",
				})
			end, {
				nargs = "?",
				complete = "dir",
				bang = true,
			})

			-- Format only changed files vs a base (default: HEAD). Includes staged + unstaged.
			vim.api.nvim_create_user_command("FormatGitChanged", function(cmdopts)
				local dry_run = cmdopts.bang
				local start_dir = vim.fn.getcwd()
				local base = "HEAD"

				-- If user passes an argument, treat it as the base ref (e.g. main, origin/main, HEAD~1)
				if cmdopts.args and cmdopts.args ~= "" then
					base = cmdopts.args
				end

				local git_root = get_git_root(start_dir)
				if not git_root then
					vim.notify("FormatGitChanged: not a git repo: " .. start_dir, vim.log.levels.ERROR)
					return
				end

				local unstaged = vim.fn.systemlist({ "git", "-C", git_root, "diff", "--name-only", base })
				local staged = vim.fn.systemlist({ "git", "-C", git_root, "diff", "--name-only", "--cached", base })

				-- Merge + de-dupe
				local seen = {}
				local merged = {}

				local function add(list)
					for _, rel in ipairs(list or {}) do
						if rel ~= "" and not seen[rel] then
							seen[rel] = true
							table.insert(merged, rel)
						end
					end
				end

				add(unstaged)
				add(staged)

				format_files({
					git_root = git_root,
					rel_paths = merged,
					dry_run = dry_run,
					label = ("FormatGitChanged (vs %s)"):format(base),
				})
			end, {
				nargs = "?",
				bang = true,
			})
		end,
	},
}
