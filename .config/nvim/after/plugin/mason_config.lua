require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
require("mason-lspconfig").setup {
  ensure_installed = { 'lua_ls', 'rust_analyzer', 'pylsp', 'bashls', 'clangd', 'cssls', 'html', 'jsonls', 'pyright', 'tsserver', 'vimls' },
}
