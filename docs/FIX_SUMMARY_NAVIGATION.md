# 修復測試摘要跳轉問題

## 🔧 已修復內容

更新了 `lua/plugins/testing.lua`，明確配置 summary 窗口的按鍵映射。

## 🚀 應用修復

### 1. 重啟 Neovim
```bash
# 關閉所有 Neovim 實例
# 重新啟動
nvim
```

### 2. 同步插件
在 Neovim 中執行：
```vim
:Lazy sync
```

### 3. 重新加載配置（可選）
```vim
:source $MYVIMRC
```

## 🧪 測試修復

### 1. 打開測試摘要
```vim
:Neotest summary
```
或按 `<leader>ts`

### 2. 運行診斷腳本
在測試摘要窗口中：
```vim
:source /tmp/test_summary_navigation.lua
```

檢查輸出中：
- ✅ `<CR> 映射存在` - 表示修復成功
- ❌ `<CR> 映射不存在` - 需要進一步排查

### 3. 測試跳轉功能
1. 在摘要窗口中使用 `j`/`k` 移動到某個測試
2. 按 `<CR>` (Enter)
3. 應該自動跳轉到測試文件

## 📋 Summary 窗口完整映射

修復後的映射列表：

| 按鍵 | 功能 |
|------|------|
| `<CR>` | 跳轉到測試 ⭐ |
| `<2-LeftMouse>` | 雙擊跳轉 |
| `o` | 展開/折疊 |
| `O` | 展開所有 |
| `r` | 運行測試 |
| `d` | 調試測試 |
| `i` | 顯示輸出 |
| `s` | 停止測試 |
| `m` | 標記 |
| `t` | 設為目標 |
| `a` | 附加 |
| `p` | 簡短輸出 |

## ❌ 如果還是不行

### 方法 1: 檢查 LazyVim extras 衝突

LazyVim 的 extras 可能覆蓋了配置。嘗試：

```vim
:lua vim.print(require("neotest").config.summary.mappings)
```

應該看到 `jumpto = { "<CR>", ... }`

### 方法 2: 手動設置按鍵映射

創建 `lua/config/autocmds.lua` 或添加到現有文件：

```lua
-- 確保 neotest summary 窗口有正確的按鍵映射
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-summary",
  callback = function()
    vim.keymap.set("n", "<CR>", function()
      require("neotest").summary.target()
    end, { buffer = true, desc = "Jump to test" })
  end,
})
```

### 方法 3: 使用替代按鍵

如果 `<CR>` 始終不工作，可以嘗試：

1. 雙擊鼠標左鍵 `<2-LeftMouse>`
2. 使用命令：
   ```vim
   :lua require("neotest").summary.target()
   ```

### 方法 4: 完全重新安裝 neotest

```vim
:Lazy clean neotest
:Lazy sync
```

重啟 Neovim

## 🔍 進階診斷

### 檢查 neotest 配置
```vim
:lua vim.print(require("neotest").config)
```

查找 `summary.mappings.jumpto`

### 檢查所有 summary 窗口映射
```vim
" 在 summary 窗口中
:nmap
```

應該看到包含 `<CR>` 的映射

### 查看 neotest 日誌
```vim
:lua vim.cmd("e " .. vim.fn.stdpath("log") .. "/neotest.log")
```

## 💡 臨時解決方案

如果修復後仍然無法使用 `<CR>`，可以使用這些替代方法：

### 方法 A: 使用快捷鍵直接跳轉
在測試文件中：
```
<leader>tr  - 運行並跳轉到最近的測試
```

### 方法 B: 使用 Telescope
如果安裝了 telescope：
```vim
:Telescope neotest
```

### 方法 C: 手動打開文件
在 summary 窗口看到測試路徑後，手動執行：
```vim
:e path/to/test_file.go
/TestFunctionName
```

## 📞 報告問題

如果以上方法都不行，請提供以下資訊：

1. Neovim 版本：`:version`
2. Neotest 版本：`:Lazy`（查看 neotest）
3. 診斷腳本輸出：`:source /tmp/test_summary_navigation.lua`
4. 映射檢查：在 summary 窗口執行 `:nmap`
5. 配置檢查：`:lua vim.print(require("neotest").config.summary.mappings)`

---

**更新日期**: 2025-11-25  
**修復版本**: v1.1
