require("vim._core.ui2").enable({})

require("options")
require("keymaps")

vim.lsp.enable('ruff')

-- Basedpyright config
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

-- Packages
vim.pack.add({
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/catppuccin/nvim' },
  { src = 'https://github.com/quarto-dev/quarto-nvim' },
  { src = 'https://github.com/jmbuhr/otter.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' }
})

-- Custom statusline 
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

-- Custom window bar
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

-- Telescope config
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope find keymaps' })

-- Send selection to terminal
vim.keymap.set('v', '<leader>st', function()
  local mode = vim.api.nvim_get_mode().mode
  local selection = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = mode })
  local terminal_chan_id = nil

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      terminal_chan_id = vim.bo[buf].channel
      break
    end
  end

  if terminal_chan_id and terminal_chan_id > 0 then
    vim.fn.chansend(terminal_chan_id, table.concat(selection, "\n") .. "\n")
  else
    vim.notify("No active terminal found", vim.log.levels.WARN)
  end
end, { desc = "Send current selection to terminal" })

-- Catppuccin config   
require("catppuccin").setup({
    flavour = "frappe"
}
)
vim.cmd.colorscheme("catppuccin-nvim")

-- Yank highlight
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Highlight active window and cursor
local group = vim.api.nvim_create_augroup('WinHighlight', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = group,
  command = 'setlocal cursorline',
})

vim.api.nvim_create_autocmd('WinLeave', {
  group = group,
  command = 'setlocal nocursorline',
})

vim.api.nvim_set_hl(0, "NormalNC", { bg = "#414559" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "#414559" })
local group = vim.api.nvim_create_augroup("WindowHighlight", { clear = true })

vim.api.nvim_create_autocmd("WinEnter", {
  group = group,
  callback = function()
    vim.wo.winhighlight = ""
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = group,
  callback = function()
    vim.wo.winhighlight = "Normal:NormalNC,WinBar:WinBarNC"
  end,
})

vim.api.nvim_set_hl(0, "MsgArea", { bg = "#303446" })

-- Quarto config
local quarto = require('quarto')
quarto.setup()
vim.keymap.set('n', '<leader>qp', quarto.quartoPreview, { silent = true, noremap = true })

-- Git difftool integration
local function git_diff()
  vim.cmd('split | term git difftool %')
  vim.cmd('startinsert')
  vim.wo.statusline = ' '
  vim.wo.winbar = ' '
end

vim.api.nvim_create_user_command('GitDiff', git_diff, {})
vim.keymap.set('n', '<leader>gd', ':GitDiff<CR>', { desc = 'Git Diff' })

-- Notify when a file is automatically reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk.", vim.log.levels.INFO)
  end,
})

-- Automatically trigger the check
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})
