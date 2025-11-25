-- Neotest Go 診斷腳本
-- 在 Neovim 中執行: :source /tmp/neotest_debug.lua

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔍 Neotest Go 診斷")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- 1. 檢查當前文件
local bufnr = vim.api.nvim_get_current_buf()
local filepath = vim.api.nvim_buf_get_name(bufnr)
local filetype = vim.bo[bufnr].filetype

print("\n📄 當前文件資訊:")
print("  路徑: " .. filepath)
print("  類型: " .. filetype)
print("  文件名: " .. vim.fn.fnamemodify(filepath, ":t"))

-- 2. 檢查是否是測試文件
local is_test_file = filepath:match("_test%.go$") ~= nil
print("  是測試文件: " .. tostring(is_test_file))

-- 3. 檢查 neotest 是否已加載
local neotest_ok, neotest = pcall(require, "neotest")
if not neotest_ok then
  print("\n❌ neotest 未加載!")
  print("請運行: :Lazy load neotest")
  return
end
print("\n✅ neotest 已加載")

-- 4. 檢查 neotest-go adapter
local adapter_ok, adapter = pcall(require, "neotest-go")
if not adapter_ok then
  print("❌ neotest-go adapter 未加載!")
  print("請運行: :Lazy load neotest-go")
  return
end
print("✅ neotest-go adapter 已加載")

-- 5. 列出已註冊的 adapters
print("\n📦 已註冊的 Adapters:")
local config = require("neotest.config")
if config.adapters and #config.adapters > 0 then
  for i, v in ipairs(config.adapters) do
    print("  " .. i .. ". " .. tostring(v.name or "Unknown"))
  end
else
  print("  ⚠️  沒有找到任何 adapter!")
end

-- 6. 檢查當前文件是否被識別
print("\n🔍 檢查當前文件:")
local tree = neotest.state.positions(bufnr)
if tree then
  print("✅ neotest 可以解析此文件")
  
  -- 顯示找到的測試
  local positions = tree:to_list()
  print("\n📋 找到的測試位置:")
  for _, pos in ipairs(positions) do
    if pos.type == "test" then
      print("  ✓ " .. pos.name)
    elseif pos.type == "namespace" then
      print("  📦 " .. pos.name .. " (namespace)")
    end
  end
  
  if #positions == 0 or #positions == 1 then
    print("  ⚠️  沒有找到測試函數!")
  end
else
  print("❌ neotest 無法解析此文件")
end

-- 7. 嘗試查找最近的測試
print("\n🎯 檢查光標位置的測試:")
local nearest = neotest.run.get_tree_from_args({ nearest = true })
if nearest then
  print("✅ 找到最近的測試")
else
  print("❌ 沒有找到最近的測試 (這就是為什麼顯示 'no test')")
end

-- 8. 檢查 go.mod
print("\n📦 Go 模組檢查:")
local root = vim.fn.getcwd()
local go_mod = root .. "/go.mod"
if vim.fn.filereadable(go_mod) == 1 then
  print("✅ 找到 go.mod: " .. go_mod)
else
  print("⚠️  未找到 go.mod (某些功能可能受限)")
end

-- 9. 檢查 gopls
print("\n🔧 LSP 狀態:")
local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
if #clients > 0 then
  for _, client in ipairs(clients) do
    print("✅ LSP: " .. client.name)
  end
else
  print("⚠️  沒有 LSP 連接到此文件")
end

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("�� 建議:")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("1. 確保文件名以 _test.go 結尾")
print("2. 確保文件中有測試函數:")
print("   func TestXxx(t *testing.T) { ... }")
print("3. 確保光標在測試函數內或附近")
print("4. 嘗試使用 <leader>tt 運行整個文件")
print("5. 檢查 :Neotest summary 查看測試樹")
