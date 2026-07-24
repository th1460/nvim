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
        typeCheckingMode = "standard", },
    },
  },
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
            typeCheckingMode = "basic", diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
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
  { src = 'https://github.com/nvim-lua/plenary.nvim' }
})

vim.o.laststatus = 3

function CustomStatusLine()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")
  local icon = ""
  
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local file_icon = devicons.get_icon(filename, extension, { default = true })
    if file_icon then
      icon = file_icon .. " "
    end
  end

  local is_git = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
  is_git = vim.trim(is_git)
  local git_branch = ""
  local git_icon = ""
  if is_git == "true" then
    git_icon = devicons.get_icon("", "diff")
    git_branch = git_icon .. " " .. vim.fn.system("git branch --show-current")
  end

  return string.format(" %s%%f %%m %s %%= %%l:%%c ", icon, git_branch)
end

vim.o.statusline = "%{%v:lua.CustomStatusLine()%}"

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })

