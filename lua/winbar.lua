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

  return string.format(" %s%%f %%m ", icon)
end

vim.o.winbar = "%{%v:lua.CustomWinBar()%}"
