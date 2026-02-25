# 模板同步指南

本文件說明如何將此模板的更新同步到已經使用舊版本建立的專案中。

## 📋 目錄

- [查看模板版本](#查看模板版本)
- [查看可用更新](#查看可用更新)
- [同步方法](#同步方法)
  - [方法 1：選擇性手動同步（推薦）](#方法-1選擇性手動同步推薦)
  - [方法 2：使用 Git Remote 追蹤](#方法-2使用-git-remote-追蹤)
  - [方法 3：完整差異比對](#方法-3完整差異比對)
- [版本升級注意事項](#版本升級注意事項)

---

## 查看模板版本

### 查看你專案的模板版本

檢查專案根目錄的 `VERSION` 檔案：

```bash
cat VERSION
```

### 查看模板最新版本

前往模板 repository 查看最新版本：

```bash
# 查看所有版本標籤
git ls-remote --tags https://github.com/matheme-justyn/my-vibe-scaffolding.git

# 或直接訪問 GitHub Releases 頁面
# https://github.com/matheme-justyn/my-vibe-scaffolding/releases
```

---

## 查看可用更新

在模板 repository 的 [CHANGELOG.md](./CHANGELOG.md) 中查看各版本的變更內容，判斷是否需要更新。

**語意化版本說明：**

- **MAJOR（X.0.0）**：不相容的變更（需謹慎評估）
- **MINOR（0.X.0）**：新增功能（向下相容，可選擇性引入）
- **PATCH（0.0.X）**：錯誤修正和文件更新（建議更新）

---

## 同步方法

### 方法 1：選擇性手動同步（推薦）

這是最安全且最靈活的方法，適合大部分情況。

#### 步驟

1. **查看 CHANGELOG.md，識別你想要的變更**

   ```bash
   # 在瀏覽器開啟模板的 CHANGELOG
   open https://github.com/matheme-justyn/my-vibe-scaffolding/blob/main/CHANGELOG.md
   ```

2. **下載特定版本的檔案**

   ```bash
   # 方法 A：使用 curl 下載單一檔案
   curl -O https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/v1.1.0/path/to/file
   
   # 方法 B：Clone 特定版本到臨時目錄
   git clone --depth 1 --branch v1.1.0 https://github.com/matheme-justyn/my-vibe-scaffolding.git /tmp/template
   
   # 複製你需要的檔案
   cp /tmp/template/新檔案.md ./
   
   # 清理臨時目錄
   rm -rf /tmp/template
   ```

3. **手動合併變更**

   - 對於配置檔案（如 `.gitignore`, `opencode.json`），使用 diff 工具比對差異後合併
   - 對於新增檔案，直接複製即可
   - 對於刪除或重構，根據實際需求決定是否跟隨

4. **更新版本號**

   ```bash
   echo "1.1.0" > VERSION
   ```

5. **Commit 變更**

   ```bash
   git add .
   git commit -m "chore: 從模板 v1.1.0 同步變更"
   ```

---

### 方法 2：使用 Git Remote 追蹤

此方法使用 Git remote 來追蹤模板 repository，適合需要頻繁同步的情況。

#### 初次設定

```bash
# 添加模板 repository 作為 remote
git remote add template https://github.com/matheme-justyn/my-vibe-scaffolding.git

# 拉取模板的所有標籤
git fetch template --tags
```

#### 同步特定版本

```bash
# 查看可用的版本標籤
git tag -l

# 查看特定版本的變更
git diff v1.0.0..v1.1.0

# 選擇性合併特定檔案
git checkout v1.1.0 -- path/to/file

# 或使用 cherry-pick 選擇特定 commit
git cherry-pick <commit-hash>

# 更新版本號
echo "1.1.0" > VERSION

# Commit
git add .
git commit -m "chore: 從模板 v1.1.0 同步變更"
```

---

### 方法 3：完整差異比對

使用 `diff` 工具進行完整比對，適合需要全面檢視所有變更的情況。

```bash
# Clone 模板到臨時目錄
git clone --depth 1 --branch v1.1.0 https://github.com/matheme-justyn/my-vibe-scaffolding.git /tmp/template

# 使用 diff 比對差異
diff -r /tmp/template . --exclude=.git

# 或使用 GUI diff 工具（如 Meld, Beyond Compare）
meld /tmp/template .

# 手動選擇要合併的變更
# ...

# 清理
rm -rf /tmp/template
```

---

## 版本升級注意事項

### MAJOR 版本升級（例如 1.x.x → 2.0.0）

⚠️ **需謹慎評估**

- 可能包含不相容的變更
- 詳細閱讀 CHANGELOG 的 **Breaking Changes** 區塊
- 在測試分支上進行升級並充分測試
- 考慮是否值得升級，或保持在舊版本

### MINOR 版本升級（例如 1.0.0 → 1.1.0）

✅ **可選擇性引入**

- 新增功能，向下相容
- 根據需求選擇要引入的新功能
- 通常風險較低

### PATCH 版本升級（例如 1.0.0 → 1.0.1）

✅ **建議更新**

- 錯誤修正、文件更新
- 通常無風險，建議跟隨更新

---

## 衝突處理

如果在同步過程中遇到衝突：

1. **保留你的自訂內容**：如果該檔案已經高度客製化
2. **手動合併**：使用 diff 工具逐行檢視並合併
3. **諮詢 CHANGELOG**：理解模板變更的意圖後再決定
4. **測試驗證**：合併後確保專案功能正常

---

## 最佳實踐

1. **定期檢查更新**：每隔 1-2 個月檢查模板是否有新版本
2. **選擇性同步**：不是所有變更都適合你的專案，謹慎選擇
3. **保持記錄**：在 commit message 中註明同步的版本號
4. **測試分支**：在獨立分支上測試同步，確認無誤後再合併
5. **自訂追蹤**：維護一份「已客製化檔案清單」，避免覆蓋自訂內容

---

## 範例工作流程

```bash
# 1. 檢查當前版本
cat VERSION  # 假設輸出：1.0.0

# 2. 查看模板最新版本
open https://github.com/matheme-justyn/my-vibe-scaffolding/releases

# 3. 閱讀 CHANGELOG，決定是否升級
open https://github.com/matheme-justyn/my-vibe-scaffolding/blob/main/CHANGELOG.md

# 4. 建立同步分支
git checkout -b sync-template-v1.1.0

# 5. 使用方法 1 或方法 2 進行同步
# ...（依照上述步驟操作）

# 6. 測試
npm test  # 或其他測試命令

# 7. 合併到主分支
git checkout main
git merge sync-template-v1.1.0

# 8. 推送
git push origin main
```

---

## 需要幫助？

如果在同步過程中遇到問題：

1. 查看模板的 [Issues](https://github.com/matheme-justyn/my-vibe-scaffolding/issues)
2. 建立新的 Issue 描述你的問題
3. 參考 [AGENTS.md](./AGENTS.md) 中的規範，確保操作符合專案風格

---

## 自動化同步（進階）

如果需要更自動化的同步流程，可以考慮：

- 使用 GitHub Actions 定期檢查模板更新並建立 PR
- 撰寫自訂腳本來自動化常見的同步任務
- 使用工具如 [Cookiecutter](https://github.com/cookiecutter/cookiecutter) 或 [Yeoman](https://yeoman.io/) 來管理模板

（這些進階功能需要額外的設定，可以根據需求逐步導入）
