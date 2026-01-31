return {
	cmd = {
		"clangd",
		"--compile-commands-dir=build",
	},

	root_dir = function(fname)
		return vim.fs.root(fname, {
			"compile_commands.json",
			"CMakeLists.txt",
			".git",
		})
	end,

	filetypes = { "c", "cpp" },
}
