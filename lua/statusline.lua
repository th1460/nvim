vim.o.laststatus = 3

function CustomStatusLine()
  local _, devicons = pcall(require, "nvim-web-devicons")
  
  local is_git = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
  is_git = vim.trim(is_git)
  local git_branch = ""
  local git_icon = ""
  if is_git == "true" then
    git_icon = devicons.get_icon("", "git")
    git_branch = git_icon .. " " .. vim.fn.system("git branch --show-current")
    git_branch = " " .. string.gsub(git_branch, "%c", "") .. " "
  end

  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  vim.api.nvim_set_hl(0, "Git", { bg = "#232634" })

  return table.concat({ "%#Git#", git_branch, "%*", string.format(" E:%d W:%d %%= %%l:%%c %s", errors, warnings, "%p%%") })
end

vim.o.statusline = "%{%v:lua.CustomStatusLine()%}"
