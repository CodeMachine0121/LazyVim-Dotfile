-- Neotest Golang 配置
-- 使用 neotest-golang (更可靠,專門解決目錄測試問題)

return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      {
        "fredrikaverpil/neotest-golang",
        version = "*", -- 追蹤最新版本
      },
    },
    opts = {
      adapters = {
        ["neotest-golang"] = {
          -- Go test 參數
          go_test_args = {
            "-v",           -- 詳細輸出
            "-race",        -- 檢測競態條件
            "-count=1",     -- 禁用測試緩存
            "-timeout=60s", -- 超時設置
          },
          -- 啟用 DAP 調試 (需要 nvim-dap-go)
          dap_go_enabled = true,
        },
      },
    },
  },
}
