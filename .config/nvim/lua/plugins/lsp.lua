-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local cmap = require("util.keymapper").cmap
local map = require("util.keymapper").map
local opts = { noremap = true, silent = true }

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  cmap('<leader>gD', 'Lspsaga goto_definition', 'n', bufopts)           -- go to definition
  cmap('<leader>gd', 'Lspsaga peek_definition', 'n', bufopts)           -- peak definition
  cmap('<leader>D', 'Lspsaga show_line_diagnostics', 'n', bufopts)      -- show  diagnostics for line
  cmap('<leader>d', 'Lspsaga show_cursor_diagnostics', 'n', bufopts)    -- show diagnostics for cursor
  cmap('<leader>w', 'Lspsaga show_workspace_diagnostics', 'n', bufopts) -- show diagnostics for workspace
  cmap('<leader>ca', 'Lspsaga code_action', 'n', bufopts)               -- see available code actions
  cmap('<leader>fd', 'Lspsaga finder', 'n', bufopts)                    -- go to definition
  cmap('<leader>pd', 'Lspsaga diagnostic_jump_prev', 'n', bufopts)      -- jump to prev diagnostic in buffer
  cmap('<leader>nd', 'Lspsaga diagnostic_jump_next', 'n', bufopts)      -- jump to next diagnostic in buffer
  cmap('<leader>rn', 'Lspsaga rename', 'n', bufopts)                    -- smart rename
  cmap('K', 'Lspsaga hover_doc', 'n', bufopts)                          -- show documentation for what is under cursor
  map('<leader>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'n', bufopts)
  map('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'n', bufopts)
  map('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'n', bufopts)
  map('<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', 'n', bufopts)
  map('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', 'n', bufopts)
  map('gr', '<cmd>lua vim.lsp.buf.references()<CR>', 'n', bufopts)

  if client.name == "pyright" then
    cmap("<Leader>oi", "PyrightOrganizeImports", "n", bufopts)
  end
end

local diagnostic_signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = "" }

local config = function()
  require("neoconf").setup({})
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local lspconfig = require("lspconfig")
  for type, icon in pairs(diagnostic_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  -- Add additional capabilities supported by nvim-cmp
  local capabilities = cmp_nvim_lsp.default_capabilities()

  -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
  local servers = { 'pylsp', 'bashls', 'clangd', 'jsonls', 'vimls', 'ruby_lsp' }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end

  -- python
  lspconfig.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      pyright = {
        disableOrganizeImports = false,
        analysis = {
          useLibraryCodeForTypes = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          autoImportCompletions = true,
        },
      },
    },
  })

  -- typescript
  lspconfig.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
      "typescript",
    },
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
  })

  -- html, typescriptreact, javascriptreact, css, sass, scss, less, svelte, vue
  lspconfig.emmet_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = {
      "html",
      "typescriptreact",
      "javascriptreact",
      "javascript",
      "css",
      "sass",
      "scss",
      "less",
      "svelte",
      "vue",
    },
  })

  -- docker
  lspconfig.dockerls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- rust
  lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {
        cmd = { "rustup", "run", "nightly", "rust-analyzer" },
      }
    }
  })

  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      Lua = { -- custom settings for lua
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  })

  local alex = require("efmls-configs.linters.alex")
  local black = require("efmls-configs.formatters.black")
  local clang_tidy = require('efmls-configs.linters.clang_tidy')
  local eslint_d = require("efmls-configs.linters.eslint_d")
  local fixjson = require("efmls-configs.formatters.fixjson")
  local flake8 = require("efmls-configs.linters.flake8")
  -- local hadolint = require("efmls-configs.linters.hadolint")
  local luacheck = require("efmls-configs.linters.luacheck")
  local prettierd = require("efmls-configs.formatters.prettier_d")
  local shellcheck = require("efmls-configs.linters.shellcheck")
  local shfmt = require("efmls-configs.formatters.shfmt")
  local stylua = require("efmls-configs.formatters.stylua")
  -- configure efm server
  local languages = {
    c = { clang_tidy },
    cpp = { clang_tidy },
    -- docker = { hadolint, prettierd },
    javascript = { eslint_d, prettierd },
    javascriptreact = { eslint_d, prettierd },
    json = { eslint_d, fixjson },
    jsonc = { eslint_d, fixjson },
    latex = { alex, prettierd },
    lua = { luacheck, stylua },
    markdown = { alex, prettierd },
    python = { flake8, black },
    sh = { shellcheck, shfmt },
    svelte = { eslint_d, prettierd },
    typescript = { eslint_d, prettierd },
    typescriptreact = { eslint_d, prettierd },
    vue = { eslint_d, prettierd },
  }

  local efmls_config = {
    filetypes = {
      "lua",
      "python",
      "json",
      "jsonc",
      "sh",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "svelte",
      "vue",
      "markdown",
      "docker",
      "solidity",
    },
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
      hover = true,
      documentSymbol = true,
      codeAction = true,
      completion = true,
    },
    settings = {
      rootMarkers = { '.git/' },
      languages = languages,
    },
  }
  lspconfig.efm.setup(vim.tbl_extend('force', efmls_config, {
    -- Pass your custom lsp config below like on_attach and capabilities
    --
    on_attach = on_attach,
    capabilities = capabilities,
  }))
end

return {
  "neovim/nvim-lspconfig",
  config = config,
  lazy = false,
  dependencies = {
    "hrsh7th/nvim-cmp",
    "williamboman/mason.nvim",
    "windwp/nvim-autopairs",
    "creativenull/efmls-configs-nvim",
    {
      "folke/neoconf.nvim",
      cmd = "Neoconf",
      dependencies = { "folke/neodev.nvim", opts = {} },
    },
  },
  keys = {
    map('<leader>e', vim.diagnostic.open_float, 'n', opts),
    map('[d', vim.diagnostic.goto_prev, 'n', opts),
    map(']d', vim.diagnostic.goto_next, 'n', opts),
    map('<leader>q', vim.diagnostic.setloclist, 'n', opts),
  }
}
