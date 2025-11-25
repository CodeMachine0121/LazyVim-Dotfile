# 💤 LazyVim 開發環境配置

> 🎯 **基於 [LazyVim](https://github.com/LazyVim/LazyVim) 定制調整** - 本項目在 LazyVim 基礎上進行了優化和擴展，以支持多語言開發和高效工作流。

模組化開發環境，支持：

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

或手動安裝（詳見 [配置架構說明](docs/CONFIG_ARCHITECTURE.md)）

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

- [快速開始指南](docs/QUICKSTART.md) - 詳細的安裝和使用步驟
- [Go 測試指南](docs/TEST_GUIDE.md) - **完整的 Go 測試使用說明** ⭐
- [Neotest 速查表](docs/NEOTEST_CHEATSHEET.md) - **測試快捷鍵一覽** 🚀
- [配置架構說明](docs/CONFIG_ARCHITECTURE.md) - 詳細的模組化設計說明
- [開發規劃](docs/DEVELOPMENT_PLAN.md) - 完整的需求和實施計劃
- [疑難排解](docs/TROUBLESHOOTING.md) - 常見問題解決方案
- [修復總結導航](docs/FIX_SUMMARY_NAVIGATION.md) - 修復內容總結
- [Git 提交指南](docs/GIT_COMMIT.md) - 提交規範說明
- [LazyVim 文檔](https://lazyvim.github.io/)

## 🔧 自定義

參見 [配置架構說明](docs/CONFIG_ARCHITECTURE.md) 了解如何：
- 添加新的 LSP
- 修改快捷鍵
- 添加格式化工具

## ❓ 常見問題

**Q: `<leader>tt` 測試不工作？**  
A: LazyVim extras 提供了測試功能。按 `<leader>t` 查看所有測試快捷鍵，或參見 [疑難排解指南](docs/TROUBLESHOOTING.md)

**Q: Astro LSP 顯示未安裝？**  
A: 執行文件名是 `astro-ls`，運行 `./check.sh` 應該能正確檢測到

更多問題請查看 [疑難排解指南](docs/TROUBLESHOOTING.md)
