# Neovim LazyVim 開發環境規劃

## 📋 專案概述
Pure LazyVim 配置，支持 Go、TypeScript/JavaScript 及現代前端框架開發環境

---

## 🎯 核心需求

### 1. Go 開發支持
#### LSP (Language Server Protocol)
- **gopls** - Go 官方 LSP 伺服器
  - 代碼補全
  - 定義跳轉
  - 符號搜索

#### 重構工具
- **gofmt** - 代碼格式化
- **goimports** - 自動導入管理
- **golangci-lint** - 靜態代碼分析（可選集成）

#### 調試工具
- **delve** (DAP - Debug Adapter Protocol)
  - 斷點調試
  - 變量檢查
  - 調用棧檢查

#### 單元測試
- **go test** 集成
- 測試執行和結果預覽
- 測試覆蓋率可視化

#### 預期插件/配置
```lua
-- LSP: gopls
-- DAP: nvim-dap + nvim-dap-go
-- Testing: nvim-dap-go + neotest + neotest-go
-- Formatting: conform.nvim with gofmt/goimports
```

---

### 2. TypeScript/JavaScript + 現代前端框架支持
#### 支持框架
- **TypeScript/JavaScript** (核心)
- **Vue 3**
- **React**
- **Astro**

#### LSP 配置
| 框架/語言 | LSP 伺服器 | 說明 |
|---------|---------|------|
| TypeScript/JavaScript | `typescript-language-server` | 內置於 Neovim 或 tsserver |
| Vue 3 | `vue-language-server` | Vue 官方 LSP |
| React (JSX/TSX) | `typescript-language-server` | 可同時處理 React 類型 |
| Astro | `astro-language-server` | Astro 官方支持 |

#### 重構工具
- **prettier** - 代碼格式化
- **eslint** - JavaScript/TypeScript linting
- **stylelint** - CSS/SCSS linting（可選）

#### 額外功能
- **tailwindcss-language-server** - Tailwind CSS 自動補全（常用於現代前端框架）
- **emmet-language-server** - HTML/CSS 快速編寫（可選）

#### 預期插件/配置
```lua
-- LSP: typescript-language-server, vue-language-server, astro-language-server
-- Formatting: conform.nvim with prettier, eslint_d
-- Linting: nvim-lint with eslint
-- Extras: tailwindcss-language-server
```

---

### 3. 自動檔案類型偵測與 LSP 切換
#### 實現機制

##### 方案 A: 基於 filetype 的自動配置（推薦）
```
檔案類型偵測流程：
┌─ 讀取文件擴展名 → 映射到 filetype
├─ .go → 觸發 Go LSP 配置 (gopls)
├─ .ts/.tsx → 觸發 TypeScript LSP (tsserver)
├─ .vue → 觸發 Vue LSP (vue-language-server)
├─ .jsx → 觸發 React LSP (tsserver)
├─ .astro → 觸發 Astro LSP (astro-language-server)
└─ .js → 觸發 JavaScript LSP (tsserver)
```

##### 實現工具
- **nvim-lspconfig** - 自動根據 filetype 加載正確的 LSP
- **nvim-treesitter** - 代碼語法高亮和解析（基於 filetype）
- **conform.nvim** - 根據 filetype 自動選擇格式化工具

#### 設定位置
```
lua/config/
├── lsp/
│   ├── init.lua           # LSP 核心配置
│   ├── go.lua            # Go 特定配置
│   ├── typescript.lua    # TypeScript 配置
│   ├── vue.lua           # Vue 特定配置
│   └── astro.lua         # Astro 特定配置
├── dap.lua               # 調試配置（主要用於 Go）
└── testing.lua           # 測試配置（主要用於 Go）

lua/plugins/
├── lsp.lua               # LSP 相關插件
├── dap.lua               # DAP 相關插件
├── testing.lua           # 測試相關插件
└── formatting.lua        # 格式化/Linting 插件
```

---

## 🔧 配置詳細規劃

### 第 1 階段: Go 開發環境
**優先級: HIGH** | **預期工作量: 中**

#### 1.1 安裝依賴
```bash
# Go LSP
go install github.com/golang/tools/gopls@latest

# Formatting
# gofmt 通常已隨 Go 安裝
# goimports
go install golang.org/x/tools/cmd/goimports@latest

# Debugging
go install github.com/go-delve/delve/cmd/dlv@latest

# Linting (可選)
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

#### 1.2 插件配置
- `nvim-lspconfig`: 配置 gopls
- `nvim-dap` + `nvim-dap-go`: 調試支持
- `conform.nvim`: gofmt/goimports 集成
- `neotest` + `neotest-go`: 測試框架

#### 1.3 快鍵綁定
```
<leader>lr  - 重命名
<leader>la  - 代碼操作 (refactor)
<leader>ld  - 調試功能
<leader>t   - 測試相關
```

#### 1.4 驗證清單
- [ ] `gopls` 正常運行
- [ ] 代碼補全工作
- [ ] 斷點調試工作
- [ ] `go test` 可視化執行
- [ ] 代碼格式化自動應用

---

### 第 2 階段: TypeScript/JavaScript 開發環境
**優先級: HIGH** | **預期工作量: 中**

#### 2.1 安裝依賴
```bash
# TypeScript LSP (可選，tsserver 通常內置)
npm install -g typescript

# Prettier 格式化
npm install -g prettier

# ESLint
npm install -g eslint

# Tailwind CSS LSP (如使用 Tailwind)
npm install -g @tailwindcss/language-server
```

#### 2.2 插件配置
- `nvim-lspconfig`: 配置 tsserver/typescript-language-server
- `conform.nvim`: prettier 集成
- `nvim-lint`: eslint 集成
- `nvim-treesitter`: TypeScript/JSX 語法高亮

#### 2.3 快鍵綁定
- 同 Go 環境（統一快鍵方案）

#### 2.4 驗證清單
- [ ] TypeScript LSP 正常運行
- [ ] JSX/TSX 語法高亮
- [ ] Prettier 自動格式化
- [ ] ESLint 診斷顯示

---

### 第 3 階段: Vue 3 支持
**優先級: MEDIUM** | **預期工作量: 低**

#### 3.1 安裝依賴
```bash
npm install -g @vue/language-server
```

#### 3.2 插件配置
- `nvim-lspconfig`: 配置 vueLanguageServer
- `nvim-treesitter`: vue 語法解析（ensure_installed = {"vue"}）

#### 3.3 驗證清單
- [ ] Vue 文件 LSP 連接
- [ ] `<template>`, `<script>`, `<style>` 各部分高亮

---

### 第 4 階段: React 支持
**優先級: MEDIUM** | **預期工作量: 低**

#### 4.1 配置說明
- React 使用與 TypeScript 相同的 LSP (tsserver)
- JSX/TSX 自動支持
- 確保 `jsx = true` 在 tsserver 配置中

#### 4.2 驗證清單
- [ ] `.jsx`/`.tsx` 文件 LSP 正常
- [ ] React hooks 自動補全

---

### 第 5 階段: Astro 支持
**優先級: MEDIUM** | **預期工作量: 低**

#### 5.1 安裝依賴
```bash
npm install -g @astrojs/language-server
```

#### 5.2 插件配置
- `nvim-lspconfig`: 配置 astroLanguageServer

#### 5.3 驗證清單
- [ ] Astro 文件 LSP 連接
- [ ] Frontmatter 部分正常高亮

---

## 📁 建議的配置結構

```
nvim/
├── init.lua
├── lua/
│   ├── config/
│   │   ├── lazy.lua
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   ├── autocmds.lua
│   │   ├── lsp/                      # LSP 配置模塊
│   │   │   ├── init.lua
│   │   │   ├── go.lua
│   │   │   ├── typescript.lua
│   │   │   ├── vue.lua
│   │   │   └── astro.lua
│   │   ├── dap.lua                   # 調試配置
│   │   └── testing.lua               # 測試配置
│   └── plugins/
│       ├── lsp.lua                   # LSP 插件定義
│       ├── dap.lua                   # DAP 插件定義
│       ├── testing.lua               # Testing 插件定義
│       ├── treesitter.lua            # Treesitter 插件
│       └── formatting.lua            # 格式化/Linting 插件
└── stylua.toml
```

---

## 🚀 實施順序（建議）

1. **第 1 階段**: Go 開發環境配置
2. **第 2 階段**: TypeScript/JavaScript 開發環境配置
3. **第 3-5 階段**: 前端框架支持（並行或順序）

---

## ✅ 整體驗收標準

### Go 開發
- ✅ LSP 自動補全、定義跳轉
- ✅ 代碼格式化 (gofmt + goimports)
- ✅ 斷點調試 (delve)
- ✅ 單元測試可視化執行

### TypeScript/JavaScript
- ✅ LSP 自動補全、定義跳轉
- ✅ Prettier 格式化
- ✅ ESLint 診斷

### Vue 3 / React / Astro
- ✅ LSP 連接正常
- ✅ 語法高亮完整
- ✅ 自動補全工作

### 自動偵測與切換
- ✅ 根據文件類型自動加載正確的 LSP
- ✅ 快鍵綁定一致
- ✅ 格式化工具自動選擇

---

## 📚 參考資源

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [LazyVim Configuration](https://lazyvim.github.io/)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [neotest](https://github.com/nvim-neotest/neotest)
- [conform.nvim](https://github.com/stevearc/conform.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

---

## 📝 補充說明

### 自動檔案偵測機制細節
Neovim 的 LSP 會根據 `buffer` 的 `filetype` 自動選擇啟用哪些 LSP 伺服器。`nvim-lspconfig` 支持以下流程：

1. 文件被打開時，Neovim 自動偵測 `filetype`
2. 所有已配置的 LSP 會檢查其 `filetypes` 列表
3. 匹配的 LSP 伺服器自動啟動並連接到 buffer
4. 代碼診斷、補全等功能自動可用

**無需手動切換** - 這是 LSP 的核心優勢

### 工具選擇說明
- **gopls vs other Go tools**: gopls 是官方工具，最穩定且功能全面
- **tsserver vs typescript-language-server**: tsserver 功能更完整，推薦使用
- **prettier vs other formatters**: 業界標準，格式化風格一致
- **conform.nvim vs other formatters**: 更靈活的多工具支持

---

**文檔版本**: 1.0  
**更新日期**: 2025-11-25
