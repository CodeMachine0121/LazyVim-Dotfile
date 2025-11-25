# 配置架構說明

## 📁 目錄結構

```
nvim/
├── init.lua                      # Neovim 入口文件
├── lua/
│   ├── config/                   # 核心配置
│   │   ├── lazy.lua             # Lazy.nvim 插件管理器配置
│   │   ├── options.lua          # Vim 選項設定
│   │   ├── keymaps.lua          # 全局快捷鍵
│   │   ├── autocmds.lua         # 自動命令
│   │   └── lsp/                 # LSP 配置模組（模組化）
│   │       ├── init.lua         # LSP 核心配置，通用 on_attach 和 capabilities
│   │       ├── go.lua           # Go LSP 專屬配置
│   │       ├── typescript.lua   # TypeScript/JavaScript LSP 配置
│   │       ├── vue.lua          # Vue LSP 配置
│   │       └── astro.lua        # Astro LSP 配置
│   └── plugins/                  # 插件定義（模組化）
│       ├── extras.lua           # LazyVim extras 導入
│       ├── lsp.lua              # LSP 插件配置
│       ├── treesitter.lua       # Treesitter 語法解析
│       ├── formatting.lua       # 格式化和 Linting (conform.nvim + nvim-lint)
│       ├── dap.lua              # 調試器配置 (nvim-dap + nvim-dap-go + dapui)
│       └── testing.lua          # 測試框架 (neotest + neotest-go)
└── DEVELOPMENT_PLAN.md          # 開發規劃文檔
```

## 🎯 模組說明

### 1. `lua/config/lsp/` - LSP 配置模組

**設計理念**: 將不同語言的 LSP 配置獨立成模組，便於維護和擴展。

- **`init.lua`**: 提供通用的 `on_attach`、`capabilities` 函數，並加載所有語言模組
- **`go.lua`**: Go (gopls) 專屬設定
- **`typescript.lua`**: TypeScript/JavaScript (ts_ls) 設定
- **`vue.lua`**: Vue (volar) 設定
- **`astro.lua`**: Astro 設定

每個模組返回一個包含以下字段的表：
```lua
{
  server_name = "lsp_server_name",
  settings = { ... },
  on_attach = function(client, bufnr) ... end,
}
```

### 2. `lua/plugins/` - 插件定義模組

**設計理念**: 按功能分類插件，每個文件負責一個領域。

#### `extras.lua`
導入 LazyVim 官方 extras，自動啟用對應語言支持：
- `lazyvim.plugins.extras.lang.go`
- `lazyvim.plugins.extras.lang.typescript`
- `lazyvim.plugins.extras.lang.vue`
- `lazyvim.plugins.extras.lang.astro`
- `lazyvim.plugins.extras.lang.tailwind`
- `lazyvim.plugins.extras.formatting.prettier`
- `lazyvim.plugins.extras.linting.eslint`
- `lazyvim.plugins.extras.dap.core`
- `lazyvim.plugins.extras.test.core`

#### `lsp.lua`
配置 `nvim-lspconfig`，定義所有 LSP 伺服器設定。

#### `treesitter.lua`
配置 Treesitter，確保所需語言的語法解析器已安裝。

#### `formatting.lua`
配置 `conform.nvim` 和 `nvim-lint`，根據文件類型自動選擇格式化和 linting 工具。

#### `dap.lua`
配置 Debug Adapter Protocol (DAP)，主要支持 Go 調試：
- `nvim-dap`: 核心調試插件
- `nvim-dap-go`: Go 專用適配器
- `nvim-dap-ui`: 調試界面

**快捷鍵**:
- `<leader>db`: 切換斷點
- `<leader>dc`: 繼續執行
- `<leader>di`: 單步進入
- `<leader>do`: 單步跳出
- `<leader>dO`: 單步跳過
- `<leader>du`: 切換調試 UI

#### `testing.lua`
配置 `neotest`，支持單元測試執行和結果可視化：
- `neotest-go`: Go 測試適配器

**快捷鍵**:
- `<leader>tt`: 運行當前文件測試
- `<leader>tr`: 運行最近的測試
- `<leader>ts`: 切換測試摘要
- `<leader>to`: 顯示測試輸出

## 🚀 使用方式

### 首次安裝

1. 確保已安裝 Neovim >= 0.9.0
2. 克隆此配置到 `~/.config/nvim`
3. 啟動 Neovim，Lazy.nvim 會自動安裝所有插件

### 安裝語言工具

#### Go
```bash
# LSP
go install golang.org/x/tools/gopls@latest

# Formatting
go install golang.org/x/tools/cmd/goimports@latest

# Debugging
go install github.com/go-delve/delve/cmd/dlv@latest
```

#### TypeScript/JavaScript/前端框架
```bash
# TypeScript LSP
npm install -g typescript typescript-language-server

# Vue LSP
npm install -g @vue/language-server

# Astro LSP
npm install -g @astrojs/language-server

# Formatting & Linting
npm install -g prettier eslint_d

# Tailwind CSS (可選)
npm install -g @tailwindcss/language-server
```

## 🔧 自定義配置

### 添加新的 LSP

1. 在 `lua/config/lsp/` 創建新模組，例如 `python.lua`
2. 在 `lua/plugins/lsp.lua` 的 `servers` 中添加配置
3. 在 `lua/plugins/extras.lua` 導入對應的 LazyVim extra（如有）

### 修改快捷鍵

- 全局快捷鍵: 編輯 `lua/config/keymaps.lua`
- LSP 快捷鍵: 編輯 `lua/config/lsp/init.lua` 的 `on_attach` 函數
- 插件快捷鍵: 編輯對應的插件配置文件

### 添加格式化工具

編輯 `lua/plugins/formatting.lua`，在 `formatters_by_ft` 中添加文件類型和對應工具。

## 📚 自動檔案類型偵測

配置會自動根據文件擴展名啟用對應的 LSP：

| 文件類型 | LSP 伺服器 | 格式化工具 |
|---------|-----------|----------|
| `.go` | gopls | goimports, gofmt |
| `.ts`, `.tsx` | ts_ls | prettier |
| `.js`, `.jsx` | ts_ls | prettier |
| `.vue` | volar | prettier |
| `.astro` | astro | prettier |

無需手動切換，開啟文件時自動啟用！

## 🎨 特色功能

✅ **模組化設計**: 各語言 LSP 配置獨立，易於維護  
✅ **LazyVim Extras**: 利用官方 extras 減少配置量  
✅ **Go 全功能支持**: LSP + DAP 調試 + 單元測試  
✅ **前端完整支持**: TypeScript/Vue/React/Astro + Prettier + ESLint  
✅ **自動切換**: 根據文件類型自動啟用 LSP 和格式化工具  
✅ **統一快捷鍵**: 所有語言使用相同的快捷鍵方案

## 📝 注意事項

1. **首次啟動較慢**: 需要下載和編譯 Treesitter 解析器
2. **需要安裝外部工具**: LSP、格式化器等需要單獨安裝（見上文）
3. **LazyVim Extras**: 此配置依賴 LazyVim 的 extras，自動處理大部分插件依賴

## 🔗 相關資源

- [LazyVim 官方文檔](https://lazyvim.github.io/)
- [nvim-lspconfig 伺服器配置](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
- [Neovim LSP 官方文檔](https://neovim.io/doc/user/lsp.html)
