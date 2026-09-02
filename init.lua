require("vim._core.ui2").enable({})

require("options")
require("keymaps")
require("pack")
require("statusline")
require("winbar")
require("git_diff")
require("lsp")

vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')
vim.lsp.enable('lua_ls')

require("catppuccin").setup({
    flavour = "frappe",
    custom_highlights = function(colors)
        return {
            netrwTreeBar = { fg = colors.surface2 },
        }
    end,
})
vim.cmd.colorscheme("catppuccin-nvim")

require("autocmds")
