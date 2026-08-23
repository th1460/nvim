vim.o.laststatus = 3

function CustomStatusLine()

    vim.api.nvim_set_hl(0, 'StatusNormal', { fg = '#292c3c', bg = '#8caaee', bold = true })
    vim.api.nvim_set_hl(0, 'StatusInsert', { fg = '#292c3c', bg = '#a6d189', bold = true })
    vim.api.nvim_set_hl(0, 'StatusVisual', { fg = '#292c3c', bg = '#ca9ee6', bold = true })
    vim.api.nvim_set_hl(0, 'StatusTerminal', { fg = '#292c3c', bg = '#e5c890', bold = true })
    vim.api.nvim_set_hl(0, 'StatusDefault', { fg = '#c6d0f5', bg = '#303446' })

    local mode_map = {
        ['n']   = { name = ' NORMAL ', hl = '%#StatusNormal#' },
        ['v']   = { name = ' VISUAL ', hl = '%#StatusVisual#' },
        ['V']   = { name = ' V-LINE ', hl = '%#StatusVisual#' },
        ['\22'] = { name = ' V-BLOCK ', hl = '%#StatusVisual#' },
        ['i']   = { name = ' INSERT ', hl = '%#StatusInsert#' },
        ['c']   = { name = ' COMMAND ', hl = '%#StatusNormal#' },
        ['t']   = { name = ' TERMINAL ', hl = '%#StatusTerminal#' }
    }

    local code = vim.fn.mode()
    local current = mode_map[code] or { name = ' NORMAL ', hl = '%#StatusNormal#' }

    local is_git = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
    is_git = vim.trim(is_git)
    local git_branch = ""
    local git_icon = ""
    if is_git == "true" then
        git_icon = "\u{e725}"
        git_branch = git_icon .. " " .. vim.fn.system("git branch --show-current")
        git_branch = " " .. string.gsub(git_branch, "%c", "") .. " "
    end

    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

    vim.api.nvim_set_hl(0, "Git", { bg = "#232634" })
    vim.api.nvim_set_hl(0, "E", { fg = "#e78284" })
    vim.api.nvim_set_hl(0, "W", { fg = "#ef9f76" })
    vim.api.nvim_set_hl(0, "H", { fg = "#e5c890" })

    return table.concat({ current.hl .. current.name .. '%#StatusDefault#', "%#Git#", git_branch, "%*", string.format(
    " %%#E#\u{f057} %d %%#W#\u{f071} %d %%#H#\u{f0335} %d %%= %%#StatusDefault#\u{f0c9} %%l:%%c %s", errors, warnings, hints, "%p%% ") })
end

vim.o.statusline = "%{%v:lua.CustomStatusLine()%}"
