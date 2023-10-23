local opts = {
  ensure_installed = {
    'lua_ls',
    'rust_analyzer',
    'pylsp',
    'bashls',
    'clangd',
    'cssls',
    'html',
    'jsonls',
    'pyright',
    'tsserver',
    'vimls',
    'efm',
    'emmet_ls',
  },

  automatic_installation = true,
}

return {
  "williamboman/mason-lspconfig.nvim",
  opts = opts,
  event = "BufReadPre",
  dependencies = "williamboman/mason.nvim",
}
