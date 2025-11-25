-- DAP (調試器) 配置擴展
-- LazyVim extras (dap.core 和 lang.go) 已經包含基本配置
-- 此文件用於自定義額外的設定

return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
  },
  {
    "leoluz/nvim-dap-go",
    opts = {
      dap_configurations = {
        {
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },
      delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        port = "${port}",
        args = {},
        build_flags = "",
      },
    },
  },
}
