function CustomWinBar()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  local icon = devicons.get_icon("", "vim") .. " " 
  
  if has_devicons then
    local file_icon = devicons.get_icon(filename, extension, { default = false })
    if file_icon then
      icon = file_icon .. " "
    end
  end

  vim.api.nvim_set_hl(0, 'StatusNormal', { fg = '#292c3c', bg = '#8caaee', bold = true })
  vim.api.nvim_set_hl(0, 'StatusInsert', { fg = '#292c3c', bg = '#a6d189', bold = true })
  vim.api.nvim_set_hl(0, 'StatusVisual', { fg = '#292c3c', bg = '#ca9ee6', bold = true })
  vim.api.nvim_set_hl(0, 'StatusTerminal', { fg = '#292c3c', bg = '#e5c890', bold = true })
  vim.api.nvim_set_hl(0, 'StatusDefault', { fg = '#c6d0f5', bg = '#303446' })

  local mode_map = {
    ['v']  = { hl = '%#StatusVisual#' },
    ['V']  = { hl = '%#StatusVisual#' },
    ['n']  = { hl = '%#StatusNormal#' },
    ['c']  = { hl = '%#StatusNormal#' },
    ['i']  = { hl = '%#StatusInsert#' },
    ['\22'] = { hl = '%#StatusVisual#' },
    ['t']  = { hl = '%#StatusTerminal#' }
  }

  local code = vim.fn.mode()
  local current = mode_map[code] or { hl = '%#StatusNormal#' }

  local bufnr = current.hl .. " " .. vim.api.nvim_get_current_buf() .. " "
  vim.api.nvim_set_hl(0, "WinBar", { fg = "#eebebe", bg = "#292c3c" })

  return string.format("%s%%#WinBar# %s%%f %%m ", bufnr, icon)
end

vim.o.winbar = "%{%v:lua.CustomWinBar()%}"
