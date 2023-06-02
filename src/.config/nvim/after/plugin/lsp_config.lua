local nvim_lsp = require('lspconfig')

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local map = vim.keymap.set
local opts = { noremap=true, silent=true }
map('n', '<leader>e', vim.diagnostic.open_float, opts)
map('n', '[d', vim.diagnostic.goto_prev, opts)
map('n', ']d', vim.diagnostic.goto_next, opts)
map('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  map('n', 'gD', vim.lsp.buf.declaration, bufopts)
  map('n', 'gd', vim.lsp.buf.definition, bufopts)
  map('n', 'K', vim.lsp.buf.hover, bufopts)
  map('n', 'gi', vim.lsp.buf.implementation, bufopts)
  map('n', '<leader>h', vim.lsp.buf.signature_help, bufopts)
  map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  map('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  map('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  map('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  map('n', 'gr', vim.lsp.buf.references, bufopts)
  map('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'pylsp', 'bashls', 'clangd', 'cssls', 'html', 'jsonls', 'pyright', 'tsserver', 'vimls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

nvim_lsp['rust_analyzer'].setup {
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
}

nvim_lsp['lua_ls'].setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
-- friendly-snippets
-- local snippets_paths = function()
  --     local plugins = { "friendly-snippets" }
  --     local paths = {}
  --     local path
  --     local root_path = vim.env.HOME .. "/.vim/plugged/"
  --     for _, plug in ipairs(plugins) do
  --         path = root_path .. plug
  --         if vim.fn.isdirectory(path) ~= 0 then
  --             table.insert(paths, path)
  --         end
  --     end
  --     return paths
  -- end

  require("luasnip.loaders.from_vscode").lazy_load({
    --	paths = snippets_paths(),
    include = nil, -- Load all languages
    exclude = {},
  })
  local luasnip = require 'luasnip'

  -- Tabnine setup
  -- local tabnine = require('cmp_tabnine.config')
  -- tabnine:setup({
    --     max_lines = 1000;
    --     max_num_results = 20;
    --     sort = true;
    --     run_on_every_keystroke = true;
    --     snippet_placeholder = '..';
    --     ignored_file_types = { -- default is not to ignore
    --         -- uncomment to ignore in lua:
    --         -- lua = true
    --     };
    --     show_prediction_strength = false;
    -- })

    local lspkind = require('lspkind')
    local source_mapping = {
      buffer = "[Buf]",
      nvim_lsp = "[LSP]",
      -- cmp_tabnine = "[TN]",
      path = "[Path]",
      luasnip = "[Snp]",
      -- vsnip = "[VSp]",
      nvim_lua = "[Lua]",
      latex_symbols = "[Ltx]",
    }

    -- nvim-cmp setup
    local cmp = require 'cmp'
    cmp.setup({
      snippet = {
        expand = function(args)
          -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          require('luasnip').lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete({
          reason = cmp.ContextReason.Auto,
        }),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
          else
            fallback()
          end
        end,
        ['<S-Tab>'] = function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
          else
            fallback()
          end
        end,
      },
      experimental = {
        ghost_text = true,
        native_menu = false,
      },
      formatting = {
        fields = {
          cmp.ItemField.Kind,
          cmp.ItemField.Abbr,
          cmp.ItemField.Menu,
        },
        format = lspkind.cmp_format({
          mode = "text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
          maxwidth = 40, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

          -- The function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          before = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind]

            local menu = source_mapping[entry.source.name]
            -- if entry.source.name == "cmp_tabnine" then
            --     if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
            --         menu = entry.completion_item.data.detail .. " " .. menu
            --     end
            --     vim_item.kind = ""
            -- end

            vim_item.menu = menu

            return vim_item
          end,
        }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        -- { name = 'vsnip' },
        { name = 'buffer' },
        { name = 'path' },
        -- { name = 'cmp_tabnine' },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
