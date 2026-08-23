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

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
})

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

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk.", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})
