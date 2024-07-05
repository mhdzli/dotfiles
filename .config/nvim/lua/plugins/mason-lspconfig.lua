local opts = {
  ensure_installed = {
    'bashls',
    'clangd',
    'cssls',
    'efm',
    'emmet_ls',
    'html',
    'jsonls',
    'lua_ls',
    'pylsp',
    'pyright',
    'rust_analyzer',
    'tsserver',
    'vimls',
    'ruby_lsp',
  },

  automatic_installation = true,
}

return {
  "williamboman/mason-lspconfig.nvim",
  opts = opts,
  event = "BufReadPre",
  dependencies = "williamboman/mason.nvim",
}
