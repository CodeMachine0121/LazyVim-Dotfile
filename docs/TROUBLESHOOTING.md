# 疑難排解指南

## 🔧 常見問題

### 1. `<leader>tt` 或 `<leader>tr` 顯示 "no test"

**原因**: neotest 無法找到或解析測試函數。

**診斷步驟**:

1. **執行診斷腳本**:
   ```vim
   :source /tmp/neotest_debug.lua
   ```
   (此腳本由配置自動生成)

2. **檢查文件名**:
   - 必須以 `_test.go` 結尾
   - 例如: `main_test.go`, `handler_test.go`

3. **檢查測試函數格式**:
   ```go
   // ✅ 正確
   func TestAdd(t *testing.T) {
       // ...
   }
   
   // ❌ 錯誤 - 缺少 *testing.T
   func TestAdd() {
       // ...
   }
   
   // ❌ 錯誤 - 不是以 Test 開頭
   func testAdd(t *testing.T) {
       // ...
   }
   ```

4. **檢查光標位置**:
   - `<leader>tr` (run nearest) 需要光標在測試函數內
   - 如果不確定，使用 `<leader>tt` 運行整個文件

5. **檢查 neotest-golang adapter 是否註冊**:
   ```vim
   :lua vim.print(require("neotest").state.adapter_ids())
   ```
   應該看到 "neotest-golang"

6. **查看測試樹**:
   ```vim
   :Neotest summary
   ```
   檢查文件和測試函數是否出現在樹中

7. **檢查 go.mod**:
   - 確保項目根目錄有 `go.mod` 文件
   - 如果沒有，創建: `go mod init <module-name>`

**完整測試範例**:
```go
// main_test.go
package main

import "testing"

func TestAdd(t *testing.T) {
    result := Add(1, 2)
    if result != 3 {
        t.Errorf("Expected 3, got %d", result)
    }
}

func TestSubtract(t *testing.T) {
    result := Subtract(5, 3)
    if result != 2 {
        t.Errorf("Expected 2, got %d", result)
    }
}
```

**使用快捷鍵**:
- `<leader>tr` - 運行光標下的測試 (cursor must be inside test function)
- `<leader>tt` - 運行當前文件所有測試
- `<leader>tT` - 運行整個項目所有測試
- `<leader>ts` - 切換測試摘要窗口
- `<leader>to` - 顯示測試輸出

**如果還是不工作**:

1. 重新同步插件:
   ```vim
   :Lazy sync
   ```

2. 重啟 Neovim

3. 檢查 LSP 是否連接:
   ```vim
   :LspInfo
   ```
   應該看到 gopls

4. 手動運行測試驗證文件本身沒問題:
   ```bash
   go test -v
   ```

### 1.5. 在目錄層級運行測試失敗 (`no Go files in ...`)

**原因**: 當你在測試摘要窗口的目錄節點(如 `internal/`)上按 `r` 時,目錄本身可能沒有 Go 文件,只有子目錄有測試文件。

**症狀**:
```
no Go files in /path/to/internal
```

**解決方案**:

1. **運行具體的子目錄而不是空目錄**:
   - 在摘要窗口按 `o` 展開目錄
   - 移動到有實際 Go 文件的子目錄上
   - 然後按 `r` 運行該子目錄的測試

2. **或在終端運行包含子目錄的測試**:
   ```bash
   # 在項目根目錄
   go test ./internal/... -v
   ```

3. **或使用快捷鍵運行整個項目**:
   ```vim
   <leader>tT  # 運行所有測試
   ```

**完整示例**:
```
neotest-golang
╰╮ internal              ← ❌ 不要在這裡按 r
 ├╮ authentication       ← ✅ 在這裡按 r
 │├╮ controllers
 ││╰─ admin_controller_test.go
 │╰╮ services
 │ ├─ admin_account_service_test.go
 │ ╰─ user_account_service_test.go
 ╰╮ fitness              ← ✅ 在這裡按 r
  ├╮ models
  ...
```

### 2. Astro LSP 沒有安裝

**原因**: 執行文件名稱是 `astro-ls` 而不是 `astro-languageserver`。

**解決方案**:
```bash
# 檢查是否已安裝
which astro-ls

# 如果沒有，手動安裝
npm install -g @astrojs/language-server

# 驗證安裝
astro-ls --version
```

### 3. LSP 沒有啟動

**診斷步驟**:

1. **檢查 LSP 狀態**:
   ```vim
   :LspInfo
   ```

2. **檢查 Mason 安裝**:
   ```vim
   :Mason
   ```

3. **手動啟動 LSP**:
   ```vim
   :LspStart
   ```

4. **查看 LSP 日誌**:
   ```vim
   :LspLog
   ```

5. **檢查文件類型**:
   ```vim
   :set filetype?
   ```

**常見原因**:
- LSP 伺服器未安裝（運行 `./install.sh`）
- 不在專案根目錄（Go 需要 `go.mod`，TypeScript 需要 `package.json`）
- 文件類型不正確

### 4. 格式化不工作

**診斷步驟**:

1. **檢查 conform.nvim**:
   ```vim
   :ConformInfo
   ```

2. **手動格式化**:
   ```vim
   :lua vim.lsp.buf.format()
   ```

3. **檢查格式化工具是否安裝**:
   ```bash
   # Go
   which gofmt goimports
   
   # TypeScript/JavaScript
   which prettier
   ```

4. **查看 conform 配置**:
   ```vim
   :lua vim.print(require("conform").list_formatters(0))
   ```

### 5. 調試器不工作

**Go 調試診斷**:

1. **檢查 delve 是否安裝**:
   ```bash
   which dlv
   dlv version
   ```

2. **檢查 nvim-dap 配置**:
   ```vim
   :lua vim.print(require("dap").configurations.go)
   ```

3. **查看 DAP 日誌**:
   ```vim
   :lua require("dap").set_log_level("TRACE")
   :lua vim.cmd("e " .. vim.fn.stdpath("cache") .. "/dap.log")
   ```

4. **測試簡單程序**:
   ```go
   // main.go
   package main
   
   import "fmt"
   
   func main() {
       x := 42
       fmt.Println(x)  // 在這行設置斷點
   }
   ```
   - 打開文件
   - 按 `<leader>db` 設置斷點
   - 按 `<leader>dc` 開始調試

### 6. 插件未加載

**解決方案**:

1. **同步插件**:
   ```vim
   :Lazy sync
   ```

2. **清除緩存並重裝**:
   ```vim
   :Lazy clear
   :Lazy sync
   ```

3. **檢查插件狀態**:
   ```vim
   :Lazy
   ```

4. **重啟 Neovim**

### 7. Treesitter 語法高亮異常

**解決方案**:

1. **更新 Treesitter**:
   ```vim
   :TSUpdate
   ```

2. **安裝特定語言**:
   ```vim
   :TSInstall go typescript tsx vue astro
   ```

3. **查看已安裝的解析器**:
   ```vim
   :TSInstallInfo
   ```

4. **重新編譯**:
   ```vim
   :TSUpdate all
   ```

## 🔍 診斷命令總覽

```vim
" LSP
:LspInfo                    " LSP 狀態
:LspLog                     " LSP 日誌
:LspRestart                 " 重啟 LSP

" 格式化
:ConformInfo                " Conform 狀態

" 測試
:Neotest summary            " 測試摘要（在窗口中按 <CR> 跳轉到測試）⭐
:lua require("neotest").run.run()  " 運行測試

" 測試摘要窗口中的快捷鍵:
" <CR> - 跳轉到測試文件並定位
" r    - 運行選中的測試
" i    - 查看測試輸出
" o    - 展開/折疊
" d    - 調試測試

" 調試
:lua require("dap").continue()      " 開始調試
:lua require("dapui").toggle()      " 切換調試 UI

" Treesitter
:TSInstallInfo              " Treesitter 狀態
:TSUpdate                   " 更新解析器

" 插件
:Lazy                       " 插件管理器
:checkhealth                " 完整健康檢查
```

## 📝 獲取幫助

1. **LazyVim 文檔**: https://lazyvim.github.io/
2. **neotest-golang 文檔**: https://fredrikaverpil.github.io/neotest-golang/
3. **neotest-golang GitHub**: https://github.com/fredrikaverpil/neotest-golang
4. **檢查健康**: `:checkhealth`
5. **查看快捷鍵**: `<leader>` 然後等待 which-key 顯示
6. **LazyVim 討論**: https://github.com/LazyVim/LazyVim/discussions

## 🐛 報告問題

如果問題持續存在，請提供以下資訊：

1. Neovim 版本: `:version`
2. 健康檢查: `:checkhealth`
3. LSP 日誌: `:LspLog`
4. neotest adapter 狀態: `:lua vim.print(require("neotest").state.adapter_ids())`
5. 錯誤訊息: 按 `<leader>xx` 查看 trouble 列表
6. 配置文件內容
