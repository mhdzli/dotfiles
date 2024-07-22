return {
  "hrsh7th/nvim-cmp",
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")
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

    require("luasnip/loaders/from_vscode").lazy_load()

    vim.opt.completeopt = "menu,menuone,noselect"

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = { -- rounded border
          border = 'rounded',
        },
        documentation = { -- rounded border
          border = 'rounded',
        },
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
          else
            fallback()
          end
        end, {
            "i",
            "s",
          }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
          else
            fallback()
          end
        end, {
            "i",
            "s",
          }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- lsp
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),
      -- configure lspkind for vs-code like icons
      formatting = {
        expandable_indicator = true,
        fields = { 'abbr', 'kind', 'menu' },
        format = lspkind.cmp_format({
          mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
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
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      },
        {
          { name = 'cmdline' }
        })
    })

    -- Autopairs configs
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )

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
  end,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-vsnip",
    -- "hrsh7th/vim-vsnip",
    "onsails/lspkind.nvim",
    {

      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
  },
}
