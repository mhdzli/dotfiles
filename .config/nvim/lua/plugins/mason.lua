return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate", -- :MasonUpdate updates registry contents
  event = "BufReadPre",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
