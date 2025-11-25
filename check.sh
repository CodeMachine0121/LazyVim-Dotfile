#!/bin/bash

# Neovim 配置健康檢查腳本
# 檢查所有必要的工具是否已安裝

set -e

# 顏色定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

check_installed=0
check_missing=0

# 檢查命令是否存在
check_tool() {
  local tool=$1
  local name=$2
  local category=$3
  
  if command -v "$tool" &> /dev/null; then
    echo -e "${GREEN}✅ $name${NC}"
    ((check_installed++))
    return 0
  else
    echo -e "${RED}❌ $name (未安裝)${NC}"
    ((check_missing++))
    return 1
  fi
}

# 檢查 Go 環境
check_go_env() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🐹 Go 開發環境"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  check_tool "go" "Go 編譯器"
  check_tool "gopls" "gopls (Go LSP)"
  check_tool "goimports" "goimports (格式化)"
  check_tool "dlv" "delve (調試器)"
  check_tool "golangci-lint" "golangci-lint (可選)"
}

# 檢查 Node.js 環境
check_node_env() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🎨 Node.js/前端開發環境"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  check_tool "node" "Node.js"
  check_tool "npm" "npm"
  check_tool "typescript-language-server" "TypeScript LSP"
  check_tool "vue-language-server" "Vue LSP"
  check_tool "astro-languageserver" "Astro LSP"
  check_tool "prettier" "Prettier (格式化)"
  check_tool "eslint_d" "ESLint (Linting)"
  check_tool "tailwindcss-language-server" "Tailwind CSS LSP (可選)"
}

# 檢查 Neovim
check_neovim() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "⚙️  Neovim 環境"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1)
    echo -e "${GREEN}✅ Neovim: $NVIM_VERSION${NC}"
    ((check_installed++))
    
    # 檢查版本號（使用 sed 替代 grep -P 以支持 macOS）
    NVIM_MAJOR=$(nvim --version | head -n1 | sed -n 's/.*v\([0-9]\+\)\..*/\1/p')
    NVIM_MINOR=$(nvim --version | head -n1 | sed -n 's/.*v[0-9]\+\.\([0-9]\+\).*/\1/p')
    
    if [ -n "$NVIM_MAJOR" ] && [ -n "$NVIM_MINOR" ]; then
      if [ "$NVIM_MAJOR" -lt 0 ] || ([ "$NVIM_MAJOR" -eq 0 ] && [ "$NVIM_MINOR" -lt 9 ]); then
        echo -e "${YELLOW}⚠️  警告: 需要 Neovim >= 0.9.0${NC}"
      fi
    fi
  else
    echo -e "${RED}❌ Neovim (未安裝)${NC}"
    ((check_missing++))
  fi
  
  # 檢查配置目錄
  CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  if [ -d "$CONFIG_DIR" ]; then
    echo -e "${GREEN}✅ 配置目錄: $CONFIG_DIR${NC}"
    ((check_installed++))
  else
    echo -e "${RED}❌ 配置目錄不存在: $CONFIG_DIR${NC}"
    ((check_missing++))
  fi
}

# 檢查配置文件結構
check_config_structure() {
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📁 配置文件結構"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  
  declare -a required_files=(
    "init.lua"
    "lua/config/lazy.lua"
    "lua/config/lsp/init.lua"
    "lua/config/lsp/go.lua"
    "lua/config/lsp/typescript.lua"
    "lua/config/lsp/vue.lua"
    "lua/config/lsp/astro.lua"
    "lua/plugins/extras.lua"
    "lua/plugins/lsp.lua"
    "lua/plugins/dap.lua"
    "lua/plugins/testing.lua"
    "lua/plugins/formatting.lua"
    "lua/plugins/treesitter.lua"
  )
  
  for file in "${required_files[@]}"; do
    if [ -f "$SCRIPT_DIR/$file" ]; then
      echo -e "${GREEN}✅ $file${NC}"
      ((check_installed++))
    else
      echo -e "${RED}❌ $file (缺失)${NC}"
      ((check_missing++))
    fi
  done
}

# 主函數
main() {
  echo ""
  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
  echo "┃   Neovim 開發環境健康檢查              ┃"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
  
  check_neovim
  check_config_structure
  check_go_env
  check_node_env
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "📊 檢查摘要"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "${GREEN}已安裝: $check_installed${NC}"
  echo -e "${RED}缺失: $check_missing${NC}"
  
  echo ""
  if [ $check_missing -gt 0 ]; then
    echo -e "${YELLOW}⚠️  有 $check_missing 個項目缺失${NC}"
    echo "請運行 ./install.sh 安裝缺失的工具"
    exit 1
  else
    echo -e "${GREEN}✅ 所有檢查通過！環境配置完整${NC}"
    echo ""
    echo "🚀 你可以開始使用 Neovim 開發了！"
    exit 0
  fi
}

# 執行
main
