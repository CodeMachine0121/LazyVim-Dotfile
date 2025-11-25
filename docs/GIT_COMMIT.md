# Git 提交建議

## 提交訊息

```
feat: 實現模組化 LazyVim 開發環境配置

- 支持 Go、TypeScript/JavaScript、Vue 3、React、Astro 開發
- 實現模組化 LSP 配置架構
- 添加 Go 調試和單元測試支持
- 自動根據文件類型切換 LSP
- 提供自動安裝和健康檢查腳本
- 完整的文檔和快速開始指南

新增文件:
- lua/config/lsp/ - LSP 配置模組
- lua/plugins/{lsp,dap,testing,formatting,treesitter,extras}.lua
- QUICKSTART.md - 快速開始指南
- CONFIG_ARCHITECTURE.md - 配置架構說明
- DEVELOPMENT_PLAN.md - 開發規劃文檔
- install.sh - 依賴安裝腳本
- check.sh - 健康檢查腳本

修改文件:
- README.md - 更新為開發環境說明

刪除文件:
- lua/plugins/example.lua - 移除範例文件
```

## 提交命令

```bash
# 添加所有新文件
git add .

# 提交
git commit -m "feat: 實現模組化 LazyVim 開發環境配置

- 支持 Go、TypeScript/JavaScript、Vue 3、React、Astro 開發
- 實現模組化 LSP 配置架構 (lua/config/lsp/)
- 添加 Go 調試 (nvim-dap) 和單元測試 (neotest) 支持
- 自動根據文件類型切換 LSP 和格式化工具
- 提供安裝腳本 (install.sh) 和健康檢查 (check.sh)
- 完整的文檔系統 (QUICKSTART.md, CONFIG_ARCHITECTURE.md, DEVELOPMENT_PLAN.md)

新增配置模組:
- lua/config/lsp/init.lua - LSP 核心配置
- lua/config/lsp/{go,typescript,vue,astro}.lua - 語言特定配置
- lua/plugins/{lsp,dap,testing,formatting,treesitter,extras}.lua - 插件配置
"

# 查看變更
git log -1 --stat
```

## 可選: 創建標籤

```bash
git tag -a v1.0.0 -m "初始模組化配置版本

完整支持:
- Go: LSP + 調試 + 測試
- TypeScript/JavaScript/Vue/React/Astro: LSP + 格式化
- 自動文件類型偵測和 LSP 切換
"

git tag -l -n9
```
