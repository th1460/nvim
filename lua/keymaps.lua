vim.g.mapleader = " "

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart configuration" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>wh", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<leader>nh", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>n", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<leader>w", ":vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set("n", "J", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "K", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "'", "c'<ESC>pa'", { desc = "Insert single quote" })
vim.keymap.set("v", '"', 'c"<ESC>pa"', { desc = "Insert double quote"})
vim.keymap.set("v", "(", "c(<ESC>pa)", { desc = "Insert parentheses" })
vim.keymap.set("v", '[', 'c[<ESC>pa]', { desc = "Insert brackets" })
vim.keymap.set("v", '{', 'c{<ESC>pa}', { desc = "Insert braces" })

vim.keymap.set('n', '<leader>do', vim.lsp.buf.hover, { desc = 'LSP Hover Documentation' })
vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>dt", vim.diagnostic.setqflist, { desc = "Show table diagnostics" })

vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format Code" })

vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { desc = "Open terminal vertically" })
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", { desc = "Open terminal horizontally" })
vim.keymap.set('t', '<C-x>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

vim.keymap.set("n", "<leader>ov", ":vsplit term://opencode<CR>", { desc = "Start OpenCode" })
vim.keymap.set("n", "<leader>oh", ":split term://opencode<CR>", { desc = "Start OpenCode vertically" })
vim.keymap.set("n", "<leader>bv", ":vsplit term://bob<CR>", { desc = "Start Bob" })
vim.keymap.set("n", "<leader>bh", ":split term://bob<CR>", { desc = "Start Bob horizontally" })

vim.keymap.set("n", "<leader>u", function() vim.cmd.packadd("nvim.undotree") require("undotree").open() end, { desc = "Toggle Builtin Undotree" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

