#!/bin/bash

# Neovim 開發環境安裝腳本
# 自動安裝所有必要的 LSP、格式化器和調試工具

set -e

echo "🚀 開始安裝 Neovim 開發環境依賴..."

# 檢查必要工具
check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "❌ 錯誤: $1 未安裝，請先安裝 $1"
    exit 1
  fi
}

# 顏色輸出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Go 工具安裝
install_go_tools() {
  echo ""
  echo "${YELLOW}📦 安裝 Go 開發工具...${NC}"
  
  if command -v go &> /dev/null; then
    echo "  - 安裝 gopls (Go LSP)..."
    go install golang.org/x/tools/gopls@latest
    
    echo "  - 安裝 goimports (格式化工具)..."
    go install golang.org/x/tools/cmd/goimports@latest
    
    echo "  - 安裝 delve (調試器)..."
    go install github.com/go-delve/delve/cmd/dlv@latest
    
    echo "  - 安裝 golangci-lint (可選 Linter)..."
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    
    echo "${GREEN}✅ Go 工具安裝完成${NC}"
  else
    echo "${YELLOW}⚠️  跳過 Go 工具 (未檢測到 Go)${NC}"
  fi
}

# Node.js/前端工具安裝
install_node_tools() {
  echo ""
  echo "${YELLOW}📦 安裝 Node.js 開發工具...${NC}"
  
  if command -v npm &> /dev/null; then
    echo "  - 安裝 TypeScript 和 TypeScript LSP..."
    npm install -g typescript typescript-language-server
    
    echo "  - 安裝 Vue LSP..."
    npm install -g @vue/language-server
    
    echo "  - 安裝 Astro LSP..."
    npm install -g @astrojs/language-server
    
    echo "  - 安裝 Prettier (格式化工具)..."
    npm install -g prettier
    
    echo "  - 安裝 ESLint (Linting 工具)..."
    npm install -g eslint_d
    
    echo "  - 安裝 Tailwind CSS LSP (可選)..."
    npm install -g @tailwindcss/language-server
    
    echo "${GREEN}✅ Node.js 工具安裝完成${NC}"
  else
    echo "${YELLOW}⚠️  跳過 Node.js 工具 (未檢測到 npm)${NC}"
  fi
}

# 主安裝流程
main() {
  echo ""
  echo "========================================="
  echo "  Neovim 開發環境依賴安裝"
  echo "========================================="
  
  # 檢查 Neovim
  if ! command -v nvim &> /dev/null; then
    echo "${YELLOW}⚠️  警告: 未檢測到 Neovim${NC}"
    echo "請先安裝 Neovim >= 0.9.0"
    echo "訪問: https://neovim.io/"
    exit 1
  else
    NVIM_VERSION=$(nvim --version | head -n1)
    echo "✅ 檢測到 Neovim: $NVIM_VERSION"
  fi
  
  # 安裝工具
  install_go_tools
  install_node_tools
  
  echo ""
  echo "${GREEN}=========================================${NC}"
  echo "${GREEN}✅ 所有工具安裝完成！${NC}"
  echo "${GREEN}=========================================${NC}"
  echo ""
  echo "📝 下一步:"
  echo "  1. 啟動 Neovim: nvim"
  echo "  2. Lazy.nvim 會自動安裝所有插件"
  echo "  3. 等待 Treesitter 編譯完成"
  echo "  4. 重啟 Neovim 即可使用"
  echo ""
  echo "📚 更多資訊請查看 CONFIG_ARCHITECTURE.md"
}

# 執行主程序
main
