vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~/.local/bin") .. ":/usr/bin"

vim.cmd("let g:netrw_liststyle =3")

local opt = vim.opt
opt.guicursor = ""

opt.relativenumber = true
opt.number = true

-- navigation
opt.scrolloff = 8 -- show 8 lines below current line at all times
opt.signcolumn = "yes"
opt.isfname:append("@-@")

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true -- convert tab to spaces
opt.autoindent = true -- copy indent from current line when starting a new one
opt.smartindent = true

-- search "/" settings
opt.ignorecase = true

opt.smartcase = true -- if search term has mixed case it'll use case-sensitive
opt.hlsearch = false
opt.incsearch = true

opt.wrap = true

opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard

-- undos (Lets make undos last longer than the session.)
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- split windows
opt.splitright = true -- split horiztonal window to the bottom
opt.splitbelow = true -- split horiztonal window to the bottom
