-- Neotest Go 配置
-- 確保 neotest-go adapter 正確註冊

return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = function(_, opts)
      -- 確保 adapters 表存在
      opts.adapters = opts.adapters or {}
      
      -- 註冊 neotest-go adapter
      table.insert(
        opts.adapters,
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s" },
        })
      )
      
      -- 確保 summary 配置存在並啟用映射
      opts.summary = opts.summary or {}
      opts.summary.enabled = true
      opts.summary.mappings = {
        expand = { "o", "<2-LeftMouse>" },
        expand_all = "O",
        output = "i",
        short = "p",
        attach = "a",
        jumpto = { "<CR>", "<2-LeftMouse>" },  -- 明確設置跳轉映射
        stop = "s",
        run = "r",
        debug = "d",
        mark = "m",
        target = "t",
      }
      
      return opts
    end,
  },
}
