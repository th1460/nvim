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

