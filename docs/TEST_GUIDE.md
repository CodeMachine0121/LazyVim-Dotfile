# Go 測試快速指南

> **注意**: 本配置使用 [neotest-golang](https://github.com/fredrikaverpil/neotest-golang) adapter,這是一個更可靠的 neotest Go adapter,專門解決目錄層級測試和 monorepo 支持。

## 🧪 測試文件要求

### 1. 文件命名
- **必須**以 `_test.go` 結尾
- 示例: `main_test.go`, `handler_test.go`, `utils_test.go`

### 2. 測試函數格式
```go
func Test<名稱>(t *testing.T) {
    // 測試代碼
}
```

**關鍵點**:
- 函數名必須以 `Test` 開頭（大寫 T）
- 必須接受 `*testing.T` 參數
- 函數名的第一個字母必須大寫（如 `TestAdd` 而不是 `Testadd`）

## 📝 完整測試範例

### main.go
```go
package main

import "fmt"

// Add 加法函數
func Add(a, b int) int {
    return a + b
}

// Subtract 減法函數
func Subtract(a, b int) int {
    return a - b
}

func main() {
    fmt.Println(Add(1, 2))
}
```

### main_test.go
```go
package main

import "testing"

func TestAdd(t *testing.T) {
    // 準備測試數據
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 1, 2, 3},
        {"negative numbers", -1, -2, -3},
        {"mixed numbers", -1, 2, 1},
        {"zero", 0, 0, 0},
    }

    // 執行測試
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d, %d) = %d; want %d", 
                    tt.a, tt.b, result, tt.expected)
            }
        })
    }
}

func TestSubtract(t *testing.T) {
    result := Subtract(5, 3)
    expected := 2
    
    if result != expected {
        t.Errorf("Subtract(5, 3) = %d; want %d", result, expected)
    }
}
```

## ⌨️ Neovim 測試快捷鍵

### 基本測試
| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `<leader>tr` | Run Nearest | 運行光標下的測試（光標需在測試函數內） |
| `<leader>tt` | Run File | 運行當前文件所有測試 |
| `<leader>tT` | Run All | 運行整個專案所有測試 |
| `<leader>tl` | Run Last | 重新運行上次的測試 |

### 測試導航和顯示
| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `<leader>ts` | Toggle Summary | 切換測試摘要窗口 |
| `<leader>to` | Show Output | 顯示測試輸出 |
| `<leader>tO` | Toggle Output Panel | 切換輸出面板 |
| `<leader>tS` | Stop | 停止正在運行的測試 |

**在測試摘要窗口 (Summary) 中的操作**:
| 按鍵 | 功能 | 說明 |
|------|------|------|
| `<CR>` (Enter) | 跳轉到測試 | **打開文件並跳轉到該測試位置** ⭐ |
| `o` | 展開/折疊 | 展開或折疊測試節點 |
| `r` | 運行測試 | 運行選中的測試 |
| `d` | 調試測試 | 調試選中的測試 |
| `i` | 顯示輸出 | 顯示測試輸出 |
| `s` | 停止 | 停止運行中的測試 |
| `m` | 標記 | 標記測試 |
| `t` | 目標 | 設置為目標 |

### 測試調試
| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `<leader>td` | Debug Nearest | 調試最近的測試 |
| `<leader>tD` | Debug Last | 調試上次的測試 |

## 🔍 診斷測試問題

### 方法 1: 使用診斷腳本

在 Neovim 中打開測試文件後執行:
```vim
:source neotest_debug.lua
```

這會顯示:
- 當前文件信息
- neotest 加載狀態
- adapter 註冊狀態
- 找到的測試函數
- LSP 連接狀態

### 方法 2: 查看測試摘要（推薦）⭐

```vim
:Neotest summary
```

**在測試摘要窗口中的操作**:
- `<CR>` (Enter) - **跳轉到測試文件並定位到該測試** ⭐
- `o` - 展開/折疊測試節點
- `r` - 運行選中的測試
- `d` - 調試選中的測試  
- `i` - 查看測試輸出
- `s` - 停止測試

**使用流程**:
1. 按 `<leader>ts` 打開測試摘要窗口
2. 使用 `j`/`k` 移動到想要的測試
3. 按 `<CR>` (Enter) 跳轉到該測試位置
4. 或直接按 `r` 運行該測試

### 方法 3: 手動運行命令

```vim
" 運行最近的測試
:lua require("neotest").run.run()

" 運行當前文件
:lua require("neotest").run.run(vim.fn.expand("%"))

" 顯示測試樹
:lua require("neotest").summary.toggle()
```

## ❌ 常見錯誤

### "no test" 錯誤

**原因**:
1. 文件名不是 `*_test.go`
2. 測試函數格式不正確
3. 光標不在測試函數內（使用 `<leader>tr` 時）
4. neotest-go adapter 未正確註冊

**解決方案**:
```vim
" 1. 檢查文件是否被識別
:Neotest summary

" 2. 運行診斷
:source neotest_debug.lua

" 3. 使用運行整個文件而不是最近的測試
<leader>tt  (而不是 <leader>tr)

" 4. 重新同步插件
:Lazy sync
```

### 測試沒有顯示在摘要中

**檢查清單**:
- [ ] 文件名以 `_test.go` 結尾
- [ ] 有 `package <name>` 聲明
- [ ] 有 `import "testing"`
- [ ] 測試函數格式正確: `func TestXxx(t *testing.T)`
- [ ] 項目根目錄有 `go.mod`
- [ ] gopls LSP 已連接 (`:LspInfo`)

### 測試運行但看不到輸出

```vim
" 顯示測試輸出
<leader>to

" 或打開輸出面板
<leader>tO

" 或在摘要窗口中按 o
:Neotest summary
" 然後按 o 在測試上
```

## 💡 最佳實踐

### 1. 使用表驅動測試
```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name string
        a, b int
        want int
    }{
        {"case1", 1, 2, 3},
        {"case2", 0, 0, 0},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            if got := Add(tt.a, tt.b); got != tt.want {
                t.Errorf("got %v, want %v", got, tt.want)
            }
        })
    }
}
```

### 2. 使用測試輔助函數
```go
func assertEqual(t *testing.T, got, want int) {
    t.Helper()
    if got != want {
        t.Errorf("got %v, want %v", got, want)
    }
}

func TestAdd(t *testing.T) {
    result := Add(1, 2)
    assertEqual(t, result, 3)
}
```

### 3. 組織測試文件
```
myproject/
├── go.mod
├── main.go
├── main_test.go
├── handlers/
│   ├── user.go
│   └── user_test.go
└── utils/
    ├── string.go
    └── string_test.go
```

## 🚀 工作流程示例

### 快速工作流程（推薦）⭐

1. **打開測試摘要**:
   ```
   <leader>ts
   ```

2. **瀏覽測試**:
   - 使用 `j`/`k` 上下移動
   - 使用 `o` 展開/折疊測試組

3. **跳轉到測試**:
   - 將光標移到想要的測試上
   - 按 `<CR>` (Enter) - **自動打開文件並跳轉到該測試位置**

4. **運行測試**:
   - 在摘要窗口按 `r` 運行選中的測試
   - 或在測試文件中按 `<leader>tr` 運行當前測試

5. **查看結果**:
   - ✅ 通過: 綠色 `✓` 標記
   - ❌ 失敗: 紅色 `✗` 標記
   - 按 `i` 查看輸出詳情

### 傳統工作流程

1. **編寫代碼**: 在 `main.go` 中實現功能
2. **編寫測試**: 在 `main_test.go` 中編寫測試
3. **運行測試**: 按 `<leader>tt`
4. **查看結果**: 
   - ✅ 通過: 綠色標記
   - ❌ 失敗: 紅色標記，按 `<leader>to` 查看詳情
5. **修復問題**: 根據輸出修復代碼
6. **重新運行**: 按 `<leader>tl` 重新運行上次測試
7. **查看摘要**: 按 `<leader>ts` 查看所有測試狀態

### 測試摘要窗口完整示例

```
按 <leader>ts 後看到的畫面:

  📦 myproject
  ├─ ✓ main_test.go
  │  ├─ ✓ TestAdd          ← 光標在這裡
  │  ├─ ✗ TestSubtract
  │  └─ ✓ TestMultiply
  └─ ✓ utils_test.go
     └─ ✓ TestStringUtils

操作:
1. 按 <CR> → 跳轉到 TestAdd 函數
2. 按 r    → 運行 TestAdd
3. 按 i    → 查看 TestAdd 輸出
4. 按 o    → 折疊/展開 main_test.go
```

## 📚 更多資源

- [Go Testing 官方文檔](https://golang.org/pkg/testing/)
- [Neotest 文檔](https://github.com/nvim-neotest/neotest)
- [neotest-golang 文檔](https://fredrikaverpil.github.io/neotest-golang/)
- [neotest-golang GitHub](https://github.com/fredrikaverpil/neotest-golang)
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - 疑難排解指南
