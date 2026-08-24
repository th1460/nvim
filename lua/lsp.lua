vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "\u{f057}",
            [vim.diagnostic.severity.WARN]  = "\u{f071}",
            [vim.diagnostic.severity.INFO]  = "\u{f400}",
            [vim.diagnostic.severity.HINT]  = "\u{f400}",
        },
    },
})

vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#e78284" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn",  { fg = "#ef9f76" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo",  { fg = "#e5c890" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint",  { fg = "#e5c890" })
