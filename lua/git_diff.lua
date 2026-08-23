local function git_diff()
    vim.cmd('split | term git difftool %')
    vim.cmd('startinsert')
    vim.wo.statusline = ' '
    vim.wo.winbar = ' '
end

vim.api.nvim_create_user_command('GitDiff', git_diff, {})
vim.keymap.set('n', '<leader>gd', ':GitDiff<CR>', { desc = 'Git Diff' })
