require("vim._core.ui2").enable({})

require("options")
require("keymaps")
require("pack")
require("statusline")
require("winbar")
require("git_diff")

vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')

require("catppuccin").setup({
    flavour = "frappe"
})
vim.cmd.colorscheme("catppuccin-nvim")

require("autocmds")
