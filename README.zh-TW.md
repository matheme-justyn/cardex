<div align="center">

<img src="./.template/assets/images/20260225_vibe-scaffolding-logo.png" alt="Vibe Scaffolding Logo" width="400"/>

# My Vibe Scaffolding

[![Version](https://img.shields.io/badge/version-1.12.0-blue.svg)](./.template/VERSION)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![Semantic Versioning](https://img.shields.io/badge/semver-2.0.0-blue)](https://semver.org/)

[English](./README.md) | 繁體中文

</div>

> **📌 這是模板的 README**  
> 如果你已使用此模板建立專案，請執行 `.template/scripts/init-project.sh` 來初始化你的專案

## 🏛️ 什麼是 My Vibe Scaffolding？

**AI 驅動的專案鷹架模板** — 基於心理學家 Lev Vygotsky 的鷹架理論，透過 AI 輔助快速建立專案結構、遵循最佳實踐，並在成長後自由拆除或客製化。

<div align="center">
<img src="./.template/assets/images/20260225_vibe-scaffolding-illustration-american.png" alt="American Style" width="300"/>
<img src="./.template/assets/images/20260225_vibe-scaffolding-illustration-japanese.png" alt="Japanese Style" width="300"/>
</div>

---

## ⚡ 核心功能

### 🤖 AI Agent 整合

`AGENTS.md` 驅動的 OpenCode/Cursor 開發體驗，AI 自動遵守專案規範。

<details>
<summary>📄 AGENTS.md 範例預覽</summary>

```markdown
# AGENTS.md

## Coding Conventions
- **永遠先寫測試**：所有新功能和 bug 修復都必須先寫測試
- **所有函數要有 docstring 和型別標注**

## Commit Message
格式：`type: brief description`
允許的 type：feat, fix, docs, refactor, test, chore

## What NOT to do
- ❌ 不要自作主張改架構
- ❌ 不要在沒被要求的情況下重構
```

→ 完整內容見 [AGENTS.md](./AGENTS.md)
</details>

### 🌐 多語言支援

BCP 47 i18n 系統，AI 自動適應使用者語言偏好。

### 📦 嚴格版本管理

Pre-push hook 強制版本更新，避免版本混亂。每次推送都確保版本號已更新。

<details>
<summary>🔍 運作機制</summary>

**自動檢查**：每次 `git push` 時，hook 會比對：
- 當前 `VERSION` 檔案內容
- 最新 Git tag 的版本號

**如果版本未更新**：
- ❌ Push 被阻止
- 💡 提示執行 `.template/scripts/bump-version.sh patch|minor|major`

**緊急繞過**（不建議）：
```bash
git push --no-verify  # 跳過所有 hooks
```

**安裝 hook**：
```bash
./.template/scripts/install-hooks.sh
```
</details>

### 🗂️ 檔案分離設計

`.template/` 隔離鷹架基礎設施，專案檔案清晰獨立。

<details>
<summary>📁 目錄結構說明</summary>

```
.template/          # 鷹架基礎設施（模板本體）
├── docs/           # 模板文件
├── scripts/        # 模板腳本
└── VERSION         # 模板版本

.opencode/          # OpenCode AI 助手配置
└── INSTALL.md      # AI 輔助安裝指令

docs/               # 你的專案文件
scripts/            # 你的專案腳本
VERSION             # 你的專案版本（獨立於模板版本）
```

**版本檔案說明：**
- `.template/VERSION`: 模板版本（你正在使用哪個版本的 scaffolding）
- `VERSION`: 你專案的版本

→ 詳見 [AGENTS.md § Working Mode](./AGENTS.md#working-mode)
</details>

### 📚 完整專案指引

LICENSE、CONTRIBUTING、SECURITY 互動式設定。

---

## 🎯 技術選型

🧠 **核心概念：將 AI 助手變成你的虛擬開發團隊**

我們使用 [superpowers](https://github.com/ohmyopencode/superpowers) —— 一套可重複使用的 AI 開發工作流程。

| 技術決策 | 選擇理由 | 解決的問題 |
|---------|---------|-----------|
| **OpenCode**（開源 AI 助手） | 75+ 模型支援、CLI 優先、可腳本化 | 不被單一供應商綁定 |
| **AGENTS.md 標準** | 跨工具相容（OpenCode/Cursor/Windsurf） | AI 理解專案規範、編碼慣例 |
| **superpowers Skills** | 可重複使用的開發工作流程 | 將最佳實踐編碼成可執行指令 |
| **Subagents 多代理** | 專業分工（explore/librarian/oracle） | 模擬真實團隊協作 |
| **單實例工作流程** | 避免 SQLite 資料庫衝突（ADR 0005） | 穩定性提升（崩潰率從每天→每週一次） |
| **MCP Servers 支援** | 連接外部工具（資料庫、API、服務） | 擴展 AI 代理能力 |

_選擇開放、可組合、社群驅動的工具，而非封閉的商業解決方案。_

---

## 🚀 快速安裝

### 方式 1：AI 助手安裝（推薦）

在 OpenCode/Cursor/Claude 對話中貼上：

```
my-vibe-scaffolding (scaffolding template)
Install and configure my-vibe-scaffolding by following the instructions here:
https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/main/.opencode/INSTALL.md
```

### 方式 2：手動安裝

```bash
# 1. GitHub 點擊 "Use this template" → Clone 專案
# 2. 初始化專案
./.template/scripts/init-project.sh
```

詳細說明：[INSTALL.md](./.opencode/INSTALL.md)

---

## 📖 文件

- [模板更新日誌](./.template/CHANGELOG.md) - 模板版本變更記錄
- [專案更新日誌](./CHANGELOG.md) - 你的專案變更記錄
- [模板同步](./.template/docs/TEMPLATE_SYNC.md) - 更新到新版本
- [專案指引](./.template/docs/) - LICENSE、CONTRIBUTING、SECURITY 撰寫指南

---

## 📄 授權

MIT License - 詳見 [LICENSE](./LICENSE)

---

<div align="center">

**基於 Vygotsky 鷹架理論 | Powered by AI | 為開發者設計**

</div>
