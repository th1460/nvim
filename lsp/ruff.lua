---@type vim.lsp.Config  
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  capabilities = {
    documentFormattingProvider = true,
  },
  init_options = {
    settings = {
      -- Ruff language server settings go here
      logLevel = 'info',
      format = {
        preview = false,
      }
    }
  }
}
