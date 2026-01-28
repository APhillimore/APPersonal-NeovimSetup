vim.g.mapleader = " "
local keymap = vim.keymap


keymap.set("i", "jk", "<ESC>", { desc = "exit insert mode with jk"}) -- insert mode, keymap, description
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "clear search highlights"})

keymap.set("n", "<leader>+", "<C-a>", { desc = "increment number"})
keymap.set("n", "<leader>-", "<C-x>", { desc = "decrement number"})

-- windows
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "split window vertically"})
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally"})
keymap.set("n", "<leader>se", "<C-w>=", { desc = "make window split equal"})
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "close active split"})

-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "open new tab"})
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "close current tab"})
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "go to next tab"})
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "got to previous tab"})
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "open current buffer in new tab"})

-- keymap.set("", "", "", {})

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected lines up"})
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected lines down"})

-- lsp
keymap.set('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', {desc = "open lsp diagnostic error message"})
keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = true, desc = "lsp: goto definition" })   
