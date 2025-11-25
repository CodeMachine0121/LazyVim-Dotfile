# 🚀 快速開始指南

## 步驟 1: 檢查配置

執行健康檢查腳本，查看缺少哪些工具：

```bash
./check.sh
```

## 步驟 2: 安裝依賴

### 自動安裝（推薦）

```bash
./install.sh
```

這會自動安裝所有 Go 和 Node.js 開發工具。

### 手動安裝

#### Go 工具

```bash
# LSP
go install golang.org/x/tools/gopls@latest

# 格式化
go install golang.org/x/tools/cmd/goimports@latest

# 調試
go install github.com/go-delve/delve/cmd/dlv@latest

# Linting (可選)
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

#### Node.js 工具

```bash
# TypeScript
npm install -g typescript typescript-language-server

# Vue
npm install -g @vue/language-server

# Astro
npm install -g @astrojs/language-server

# 格式化和 Linting
npm install -g prettier eslint_d

# Tailwind (可選)
npm install -g @tailwindcss/language-server
```

## 步驟 3: 啟動 Neovim

```bash
nvim
```

首次啟動時，Lazy.nvim 會：
1. 自動下載所有插件
2. 編譯 Treesitter 語法解析器
3. 配置 LSP 伺服器

**注意**: 首次啟動需要幾分鐘時間，請耐心等待。

## 步驟 4: 驗證安裝

在 Neovim 中執行：

```vim
:checkhealth
```

檢查所有 LSP 和插件是否正常工作。

## 步驟 5: 測試功能

### 測試 Go 開發

1. 創建測試文件：
```bash
mkdir test-go && cd test-go
nvim main.go
```

2. 輸入代碼：
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

3. 測試功能：
   - LSP 自動補全：輸入 `fmt.` 應該看到方法建議
   - 格式化：保存文件時自動格式化
   - 跳轉定義：將光標移到 `Println` 上，按 `gd`

### 測試 TypeScript 開發

1. 創建測試文件：
```bash
mkdir test-ts && cd test-ts
npm init -y
nvim index.ts
```

2. 輸入代碼：
```typescript
const greeting: string = "Hello, TypeScript!";
console.log(greeting);
```

3. 測試功能：
   - 類型提示：將鼠標懸停在變量上應該看到類型
   - 自動補全：輸入 `console.` 應該看到方法建議
   - 格式化：`:w` 保存時自動格式化

## 常用快捷鍵提醒

### 通用 LSP
- `gd` - 跳轉到定義
- `gr` - 查找引用
- `K` - 顯示文檔
- `<leader>rn` - 重命名符號
- `<leader>ca` - 代碼操作

### Go 調試
- `<leader>db` - 設置/取消斷點
- `<leader>dc` - 開始/繼續調試
- `<leader>di` - 單步進入
- `<leader>do` - 單步跳出
- `<leader>dO` - 單步跳過
- `<leader>du` - 切換調試 UI

### Go 測試
- `<leader>tt` - 運行當前文件測試
- `<leader>tr` - 運行光標下的測試
- `<leader>ts` - 顯示測試摘要
- `<leader>to` - 顯示測試輸出

### 文件導航（LazyVim 預設）
- `<leader>ff` - 查找文件
- `<leader>fg` - 全局搜索文本
- `<leader>e` - 切換文件樹

## 疑難排解

### LSP 沒有啟動

1. 檢查 LSP 伺服器是否安裝：
```bash
./check.sh
```

2. 在 Neovim 中檢查 LSP 狀態：
```vim
:LspInfo
```

### 插件沒有加載

1. 更新插件：
```vim
:Lazy sync
```

2. 重啟 Neovim

### Treesitter 語法高亮異常

1. 更新 Treesitter：
```vim
:TSUpdate
```

2. 重新安裝特定語言解析器：
```vim
:TSInstall go typescript tsx vue astro
```

### 格式化不工作

1. 檢查格式化工具是否安裝（prettier, gofmt 等）
2. 在 Neovim 中手動格式化測試：
```vim
:lua vim.lsp.buf.format()
```

## 下一步

- 閱讀 [CONFIG_ARCHITECTURE.md](CONFIG_ARCHITECTURE.md) 了解配置架構
- 閱讀 [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) 了解完整規劃
- 查看 [LazyVim 文檔](https://lazyvim.github.io/) 了解更多功能

## 獲取幫助

- LazyVim 問題：https://github.com/LazyVim/LazyVim/discussions
- Neovim LSP：`:help lsp`
- Neovim DAP：`:help dap`
