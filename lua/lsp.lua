vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "\u{ea87}",
            [vim.diagnostic.severity.WARN]  = "\u{ea6c}",
            [vim.diagnostic.severity.INFO]  = "\u{f400}",
            [vim.diagnostic.severity.HINT]  = "\u{ea74}",
        },
    },
})

vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#e78284" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#ef9f76" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#e5c890" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#81c8be" })

local autocomplete_icons = {
    Text          = "\u{e64e}",
    Method        = "\u{ea8c}",
    Function      = "\u{f0295}",
    Constructor   = "\u{f013}",
    Field         = "\u{eb5f}",
    Variable      = "\u{f0ae7}",
    Class         = "\u{eb5b}",
    Interface     = "\u{eb61}",
    Module        = "\u{f1b3}",
    Property      = "\u{eb65}",
    Unit          = "\u{e721}",
    Value         = "\u{f03a0}",
    Enum          = "\u{f15d}",
    Keyword       = "\u{eb62}",
    Snippet       = "\u{eac4}",
    Color         = "\u{eb5c}",
    File          = "\u{ea7b}",
    Reference     = "\u{eb36}",
    Folder        = "\u{ea83}",
    EnumMember    = "\u{f15d}",
    Constant      = "\u{eb5d}",
    Struct        = "\u{f525}",
    Event         = "\u{ea86}",
    Operator      = "\u{eb64}",
    TypeParameter = "\u{ea92}",
}

for kind_name, icon in pairs(autocomplete_icons) do
    local kind_number = vim.lsp.protocol.CompletionItemKind[kind_name]
    if kind_number then
        vim.lsp.protocol.CompletionItemKind[kind_number] = icon
    end
end

-- Main Autocomplete Menu Colors
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#303446", fg = "#c6d0f5" })    -- Menu Background & Text
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#8caaee", fg = "#303446" }) -- Selected Item Highlight
vim.api.nvim_set_hl(0, "PmenuKind", { fg = "#f4b8e4" })                -- The Column containing your new icons
vim.api.nvim_set_hl(0, "PmenuExtra", { fg = "#a6d189" })               -- Extra details column (e.g. source/type)
