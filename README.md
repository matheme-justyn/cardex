<div align="center">

<img src="./.template/assets/images/20260225_vibe-scaffolding-logo.png" alt="Vibe Scaffolding Logo" width="400"/>

# My Vibe Scaffolding

[![Version](https://img.shields.io/badge/version-1.5.1-blue.svg)](./.template/VERSION)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![Semantic Versioning](https://img.shields.io/badge/semver-2.0.0-blue)](https://semver.org/)

</div>

## 🏛️ 什麼是 My Vibe Scaffolding？

**AI 驅動的專案鷹架模板** — 基於心理學家 Lev Vygotsky 的鷹架理論，透過 AI 輔助快速建立專案結構、遵循最佳實踐，並在成長後自由拆除或客製化。

---

## ⚡ 核心功能

- 🤖 **AI Agent 整合** — `AGENTS.md` 驅動的 OpenCode/Cursor 開發體驗
- 🌐 **多語言支援** — BCP 47 i18n 系統，AI 自動適應使用者語言
- 📦 **嚴格版本管理** — Pre-push hook 強制版本更新，避免混亂
- 🗂️ **檔案分離設計** — `.template/` 隔離鷹架基礎設施，專案檔案清晰獨立
- 📚 **完整專案指引** — LICENSE、CONTRIBUTING、SECURITY 互動式設定

---

## 🎯 Vibe Coding 技術選型

| 技術決策 | 選擇理由 |
|---------|---------|
| **BCP 47 語言標籤** | IETF 標準，W3C WCAG 採用，精確區分 zh-TW/zh-CN/zh-HK |
| **語意化版本 2.0.0** | 嚴格 MAJOR/MINOR/PATCH 定義，明確 breaking change 標準 |
| **直接 main 分支** | 配合 pre-push hook 版本檢查，簡化工作流程 |
| **TOML 配置格式** | 人類可讀，註解友善，AI 易解析 |
| **模式分離架構** | Scaffolding mode（開發鷹架） vs Project mode（使用鷹架）清楚分離 |

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

- [更新日誌](./CHANGELOG.md) - 版本變更記錄
- [模板同步](./.template/docs/TEMPLATE_SYNC.md) - 更新到新版本
- [專案指引](./.template/docs/) - LICENSE、CONTRIBUTING、SECURITY 撰寫指南

---

## 📄 授權

MIT License - 詳見 [LICENSE](./LICENSE)

---

<div align="center">

**基於 Vygotsky 鷹架理論 | Powered by AI | 為開發者設計**

</div>
