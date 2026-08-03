require("vim._core.ui2").enable({})

require("options")
require("keymaps")

vim.lsp.enable('ruff')

vim.lsp.config.basedpyright = {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "off" 
      },
    },
  }
}

vim.lsp.enable('basedpyright')

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(args)
    vim.lsp.start({
      name = "basedpyright",
      cmd = { "basedpyright-langserver", "--stdio" },
      root_dir = vim.fs.root(args.buf, { "pyproject.toml", "setup.py", ".git" }),
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "off", 
          },
        },
      },
    })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    vim.keymap.set("i", "<Tab>", function()
      if vim.fn.pumvisible() == 1 then
        return "<C-n>"
      else
        return "<C-x><C-o>"
      end
    end, { expr = true, buffer = bufnr })

    vim.keymap.set("i", "<S-Tab>", function()
      if vim.fn.pumvisible() == 1 then
        return "<C-p>"
      end
      return "<S-Tab>"
    end, { expr = true, buffer = bufnr })
  end,
})

vim.pack.add({
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/catppuccin/nvim'}
})

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

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope find keymaps' })

vim.keymap.set('n', '<leader>st', function()
  local current_line = vim.api.nvim_get_current_line()
  local terminal_chan_id = nil

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      terminal_chan_id = vim.bo[buf].channel
      break
    end
  end

  if terminal_chan_id and terminal_chan_id > 0 then
    vim.fn.chansend(terminal_chan_id, current_line .. "\n")
  else
    vim.notify("No active terminal found", vim.log.levels.WARN)
  end
end, { desc = "Send current line to terminal" })

require("catppuccin").setup({
    flavour = "frappe"
}
)
vim.cmd.colorscheme("catppuccin-nvim")

local group = vim.api.nvim_create_augroup('WinHighlight', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = group,
  command = 'setlocal cursorline',
})

vim.api.nvim_create_autocmd('WinLeave', {
  group = group,
  command = 'setlocal nocursorline',
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})
