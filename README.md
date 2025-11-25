# 💤 LazyVim 開發環境配置

基於 [LazyVim](https://github.com/LazyVim/LazyVim) 的模組化開發環境，支持：

- 🐹 **Go**: LSP (gopls) + 調試 (delve) + 測試 (neotest)
- 🎨 **前端**: TypeScript/JavaScript, Vue 3, React, Astro
- 🔧 **自動切換**: 根據文件類型自動啟用對應 LSP
- 📦 **模組化設計**: 易於維護和擴展

## 🚀 快速開始

### 1. 安裝依賴

```bash
# 自動安裝所有 LSP 和工具
./install.sh
```

或手動安裝（詳見 `CONFIG_ARCHITECTURE.md`）

### 2. 啟動 Neovim

```bash
nvim
```

首次啟動會自動安裝所有插件，請耐心等待。

## 📁 配置結構

```
lua/
├── config/
│   ├── lsp/          # LSP 配置模組
│   │   ├── init.lua  # 通用配置
│   │   ├── go.lua    # Go 專屬
│   │   ├── typescript.lua
│   │   ├── vue.lua
│   │   └── astro.lua
│   └── ...
└── plugins/          # 插件配置
    ├── extras.lua    # LazyVim extras
    ├── lsp.lua       # LSP 插件
    ├── dap.lua       # 調試器
    ├── testing.lua   # 測試框架
    └── ...
```

## 🎯 支持的語言

| 語言 | LSP | 格式化 | 調試 | 測試 |
|------|-----|--------|------|------|
| Go | ✅ gopls | ✅ gofmt + goimports | ✅ delve | ✅ neotest-go |
| TypeScript/JavaScript | ✅ ts_ls | ✅ prettier | - | - |
| Vue 3 | ✅ volar | ✅ prettier | - | - |
| React (JSX/TSX) | ✅ ts_ls | ✅ prettier | - | - |
| Astro | ✅ astro | ✅ prettier | - | - |

## ⌨️ 主要快捷鍵

### LSP (所有語言通用)
- `gd`: 跳轉到定義
- `gr`: 查找引用
- `K`: 顯示文檔
- `<leader>rn`: 重命名
- `<leader>ca`: 代碼操作

### Go 調試 (DAP)
- `<leader>db`: 切換斷點
- `<leader>dc`: 繼續執行
- `<leader>di`: 單步進入
- `<leader>do`: 單步跳出
- `<leader>du`: 切換調試 UI

### Go 測試 (Neotest)
- `<leader>tt`: 運行當前文件測試
- `<leader>tr`: 運行最近的測試
- `<leader>ts`: 切換測試摘要
- `<leader>to`: 顯示測試輸出

## 📚 文檔

- [配置架構說明](CONFIG_ARCHITECTURE.md) - 詳細的模組化設計說明
- [開發規劃](DEVELOPMENT_PLAN.md) - 完整的需求和實施計劃
- [LazyVim 文檔](https://lazyvim.github.io/)

## 🔧 自定義

參見 `CONFIG_ARCHITECTURE.md` 了解如何：
- 添加新的 LSP
- 修改快捷鍵
- 添加格式化工具
