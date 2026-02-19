return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  priority = 1000,
  build = ":TSUpdate",
  -- Use opts instead of config function
  opts = {
    indent = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    ensure_installed = {
      "bash", "c", "css", "dockerfile", "gitignore", "html", "javascript",
      "json", "jsonc", "latex", "lua", "make", "markdown", "markdown_inline",
      "norg", "python", "query", "regex", "ruby", "rust", "scss", "toml",
      "typescript", "vim", "yaml",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-s>",
        node_incremental = "<C-s>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
  }
}
