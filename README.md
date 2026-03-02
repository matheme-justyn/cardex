<div align="center">

<img src="./.template/assets/images/20260225_vibe-scaffolding-logo.png" alt="Vibe Scaffolding Logo" width="400"/>

# My Vibe Scaffolding

[![Version](https://img.shields.io/badge/version-1.8.1-blue.svg)](./.template/VERSION)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![Semantic Versioning](https://img.shields.io/badge/semver-2.0.0-blue)](https://semver.org/)

</div>

## 🏛️ 什麼是 My Vibe Scaffolding？ | What is My Vibe Scaffolding?

**AI 驅動的專案鷹架模板** — 基於心理學家 Lev Vygotsky 的鷹架理論，透過 AI 輔助快速建立專案結構、遵循最佳實踐，並在成長後自由拆除或客製化。

**AI-driven project scaffolding template** — Based on psychologist Lev Vygotsky's scaffolding theory, quickly build project structures with AI assistance, follow best practices, and freely remove or customize as you grow.

<div align="center">
<img src="./.template/assets/images/20260225_vibe-scaffolding-illustration-american.png" alt="American Style Illustration" width="300"/>
<img src="./.template/assets/images/20260225_vibe-scaffolding-illustration-japanese.png" alt="Japanese Style Illustration" width="300"/>
</div>

---

## ⚡ 核心功能 | Core Features

- 🤖 **AI Agent 整合** — `AGENTS.md` 驅動的 OpenCode/Cursor 開發體驗  
  **AI Agent Integration** — OpenCode/Cursor development experience driven by `AGENTS.md`

  <details>
  <summary>📄 AGENTS.md 範例預覽 | Preview</summary>
  
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

- 🌐 **多語言支援** — BCP 47 i18n 系統，AI 自動適應使用者語言  
  **Multi-language Support** — BCP 47 i18n system, AI automatically adapts to user's language

- 📦 **嚴格版本管理** — Pre-push hook 強制版本更新，避免混亂  
  **Strict Version Management** — Pre-push hook enforces version updates
  
  <details>
  <summary>🔍 運作機制 | How It Works</summary>
  
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
  
  **Automatic checks**: On every `git push`, the hook compares:
  - Current `VERSION` file content
  - Latest Git tag version
  
  **If version not updated**:
  - ❌ Push blocked
  - 💡 Prompts to run `.template/scripts/bump-version.sh patch|minor|major`
  
  **Emergency bypass** (not recommended):
  ```bash
  git push --no-verify  # Skip all hooks
  ```
  
  **Install hooks**:
  ```bash
  ./.template/scripts/install-hooks.sh
  ```
  </details>

- 🗂️ **檔案分離設計** — `.template/` 隔離鷹架基礎設施，專案檔案清晰獨立  
  **File Separation Design** — `.template/` isolates scaffolding infrastructure
  
  <details>
  <summary>📁 目錄結構說明 | Directory Structure</summary>
  
  ```
  .template/          # 鷹架基礎設施（模板本體）
  ├── docs/           # 模板文件
  ├── scripts/        # 模板腳本
  └── VERSION         # 模板版本（你使用的鷹架版本）
  
  .opencode/          # OpenCode AI 助手專用配置
  └── INSTALL.md      # AI 輔助安裝指令（供 AI 讀取）
  
  docs/               # 你的專案文件
  scripts/            # 你的專案腳本
  VERSION             # 你的專案版本（獨立於模板版本）
  ```
  
  **版本檔案說明 | Version Files:**
  - `.template/VERSION`: 模板自身的版本（你正在使用哪個版本的 scaffolding）
  - `VERSION`: 你專案的版本（你的專案目前是哪個版本）
  
  **Scaffolding Mode 特別註意 | Special Note for Scaffolding Mode:**
  - 如果你在開發這個模板本身（`config.toml` 設定 `mode = "scaffolding"`）
  - 兩個 VERSION 檔案**必須同步**，由 pre-push hook 強制檢查
  - 使用 `.template/scripts/bump-version.sh` 會自動同步兩個檔案
  
  → 詳見 [AGENTS.md § Working Mode](./AGENTS.md#working-mode)
  </details>

- 📚 **完整專案指引** — LICENSE、CONTRIBUTING、SECURITY 互動式設定  
  **Complete Project Guides** — Interactive setup for LICENSE, CONTRIBUTING, SECURITY

---

## 🎯 Vibe 技術選型 | Vibe Tech Stack

🧠 **核心概念：將 AI 助手變成你的虛擬開發團隊**  
**Core Concept: Turn AI assistants into your virtual dev team**

我們使用 [superpowers](https://github.com/ohmyopencode/superpowers) —— 一套可重複使用的 AI 開發工作流程（類似程式碼的函數，但針對 AI 行為）。

We use [superpowers](https://github.com/ohmyopencode/superpowers) — reusable AI development workflows (like functions for code, but for AI behavior).

---

**為什麼選擇這些技術？**  
**Why these technologies?**

| 技術決策<br>Technology | 選擇理由<br>Why | 解決的問題<br>Problem Solved |
|---------|---------|-----------|
| **OpenCode（開源 AI 助手）**<br>**OpenCode (Open-source AI assistant)** | 75+ 模型支援、CLI 優先、可腳本化<br>75+ models, CLI-first, scriptable | 不被單一供應商綁定，可自由選擇最佳模型<br>Avoid vendor lock-in, freely choose best model |
| **AGENTS.md 標準**<br>**AGENTS.md Standard** | 跨工具相容（OpenCode/Cursor/Windsurf 通用）<br>Cross-tool compatible | AI 理解專案規範、編碼慣例、測試要求<br>AI understands project conventions, coding practices, test requirements |
| **superpowers Skills** | 可重複使用的開發工作流程<br>Reusable development workflows | 將最佳實踐編碼成可執行指令，提升一致性<br>Encode best practices as executable commands, improve consistency |
| **Subagents 多代理**<br>**Subagents (Multi-agent)** | 專業分工（explore/librarian/oracle）<br>Specialized roles | 模擬真實團隊協作，提高複雜任務處理能力<br>Simulate real team collaboration, handle complex tasks |
| **單實例工作流程**<br>**Single-instance Workflow** | 避免 SQLite 資料庫衝突（ADR 0005）<br>Avoid SQLite conflicts (ADR 0005) | 穩定性提升（崩潰率從每天 → 每週一次）<br>Stability boost (crashes: daily → weekly) |
| **MCP Servers 支援**<br>**MCP Servers Support** | 連接外部工具（資料庫、API、服務）<br>Connect external tools (DB, API, services) | 擴展 AI 代理能力，自動化複雜任務<br>Extend AI capabilities, automate complex tasks |

_選擇開放、可組合、社群驅動的工具，而非封閉的商業解決方案。_  
_Choose open, composable, community-driven tools over closed commercial solutions._

---

## 📸 使用範例 | Usage Examples

_🚧 截圖製作中…… 以下是計劃中的 Demo | Screenshots in progress... Planned demos below:_

### AI 助手自動安裝 | AI-Assisted Installation

```
🤖 展示如何透過 AI 對話一鍵安裝配置
   Demo: One-command installation via AI chat

[尚未製作 | Not yet created]
```

### 版本管理自動執行 | Version Management Enforcement

```
🔒 展示 pre-push hook 阻止未更新版本的 push
   Demo: pre-push hook blocking push without version bump

[尚未製作 | Not yet created]
```

### OpenCode AGENTS.md 驅動開發 | AGENTS.md-Driven Development

```
🧠 展示 AI 讀取 AGENTS.md 後遵守專案規範
   Demo: AI following project conventions from AGENTS.md

[尚未製作 | Not yet created]
```

_如果你想貢獻截圖，歡迎開 PR！| Want to contribute screenshots? PRs welcome!_

---

## 🚀 快速安裝 | Quick Install

### 方式 1：AI 助手安裝（推薦） | Option 1: AI Assistant Install (Recommended)

在 OpenCode/Cursor/Claude 對話中貼上：  
Paste this in OpenCode/Cursor/Claude chat:

```
my-vibe-scaffolding (scaffolding template)
Install and configure my-vibe-scaffolding by following the instructions here:
https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/main/.opencode/INSTALL.md
```

### 方式 2：手動安裝 | Option 2: Manual Install

```bash
# 1. GitHub 點擊 "Use this template" → Clone 專案
# 1. Click "Use this template" on GitHub → Clone project
# 2. 初始化專案
# 2. Initialize project
./.template/scripts/init-project.sh
```

詳細說明 | For details: [INSTALL.md](./.opencode/INSTALL.md)

---

## 📖 文件 | Documentation

- [更新日誌](./CHANGELOG.md) - 版本變更記錄 | Version change log
- [模板同步](./.template/docs/TEMPLATE_SYNC.md) - 更新到新版本 | Update to new versions
- [專案指引](./.template/docs/) - LICENSE、CONTRIBUTING、SECURITY 撰寫指南 | Writing guides

---

## 📄 授權 | License

MIT License - 詳見 | See [LICENSE](./LICENSE)

---

<div align="center">

**基於 Vygotsky 鷹架理論 | Powered by AI | 為開發者設計**

</div>
