<div align="center">

<img src="./.template/assets/images/20260225_vibe-scaffolding-logo.png" alt="Vibe Scaffolding Logo" width="400"/>

# My Vibe Coding Template

[![Version](https://img.shields.io/badge/version-1.2.0-blue.svg)](./VERSION)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![Semantic Versioning](https://img.shields.io/badge/semver-2.0.0-blue)](https://semver.org/)


</div>


## 🏛️ 理念與靈感 | Concept & Inspiration

<div align="center">
<img src="./.template/assets/images/20260225_vibe-scaffolding-illustration-american.png" alt="American Style Illustration" width="300"/>
<img src="./.template/assets/images/20260225_vibe-scaffolding-illustration-japanese.png" alt="Japanese Style Illustration" width="300"/>
</div>

### Vygotsky 的鷹架理論 | Vygotsky's Scaffolding Theory

心理學家 Lev Vygotsky 提出的 **鷹架理論**：透過暫時性的支持結構，幫助學習者從當前能力提升到潛在發展區（ZPD）。一旦學習者成長，鷹架就逐步拆除。

**Scaffolding theory** by psychologist Lev Vygotsky: temporary support structures help learners progress from current capability to their Zone of Proximal Development (ZPD). Once learners grow, the scaffolding is gradually removed.

### Vibe Coding = 程式開發的鷹架

**Vibe Coding 就是這種概念的實踐：**

- 🪧 **AI 作為鷹架** — 快速建立專案骨架、遵循最佳實踐
- 🛠️ **模板作為結構** — 精心設計的檔案結構、編碼規範、工作流程
- 📈 **逐步成長** — 客製化模板、調整規範、形成自己的風格
- 🔄 **可拆除性** — 不再需要時可自由拆除或修改

**Vibe Coding embodies this concept:**

- 🪧 **AI as Scaffolding** — Build foundations quickly, follow best practices
- 🛠️ **Template as Structure** — Pre-designed files, conventions, workflows
- 📈 **Progressive Growth** — Customize, adjust, develop your own style
- 🔄 **Removability** — Remove or modify when no longer needed

這是一個 **成長式的學習與開發框架**，在 AI 輔助下逐步提升開發技能。

A **growth-oriented learning and development framework** that progressively improves your development skills with AI assistance.

---

## 🚀 使用方式

1. 點擊 GitHub 上的 **"Use this template"** 按鈕
2. 建立新的 repository
3. Clone 到本地開始開發

## 📁 包含檔案

此模板包含以下檔案和目錄結構：

### 核心設定檔

- **`AGENTS.md`** - OpenCode AI agent 的主要指令文件，定義專案規範、編碼慣例和工作流程
- **`opencode.json`** - OpenCode 的專案層級設定檔，可在此加入專案特定的 MCP servers
- **`.gitignore`** - 通用的 Git 忽略規則，包含常見的 OS、編輯器和語言 artifacts
- **`.editorconfig`** - 統一的編輯器設定（縮排、編碼、換行符等）
- **`.env.example`** - 環境變數範例檔案，提供設定結構但不含真實值
- **`VERSION`** - 當前模板版本號（語意化版本）
- **`CHANGELOG.md`** - 版本變更歷史記錄
- **`.template/docs/TEMPLATE_SYNC.md`** - 模板更新同步指南

### GitHub Templates

- **`.github/ISSUE_TEMPLATE/bug_report.md`** - Bug 回報的 issue 模板
- **`.github/ISSUE_TEMPLATE/feature_request.md`** - 功能請求的 issue 模板
- **`.github/pull_request_template.md`** - Pull Request 模板
- **`.github/workflows/ci-placeholder.yml`** - GitHub Actions CI workflow 佔位檔案

### 文件

- **`docs/adr/0001-record-architecture-decisions.md`** - 架構決策記錄（ADR）的首個範例，說明為何使用 ADR

## 🌏 語言支援 | Language Support

### 💻 程式語言支援 | Programming Language Support

**位置 | Location:** `languages/` directory

此模板包含多種**程式語言**的開發環境配置模組，每個模組包含該語言的工具鏈、linter、formatter 和最佳實踐。

This template includes development environment configuration modules for multiple **programming languages**, each containing the language's toolchain, linters, formatters, and best practices.

**支援的程式語言 | Supported Programming Languages:**
- **Go** - golangci-lint, Makefile, go.mod
- **Python** - pyproject.toml, .python-version
- **TypeScript** - tsconfig.json, ESLint, package.json
- **Rust** - Cargo.toml, rust-toolchain.toml

詳細使用方式請參考「🌐 語言支援」章節。

For detailed usage, see the "🌐 語言支援" section below.

### 🌐 自然語言支援 (i18n) | Natural Language Support (i18n)

**位置 | Location:** `i18n/` directory
**標準 | Standard:** **BCP 47 (RFC 5646)** - IETF Language Tags

此模板支援多種**自然語言** (human languages) 的文件和模板自訂，使用 BCP 47 語言標籤進行精確的語言識別。

This template supports multiple **natural languages** (human languages) for documentation and templates, using BCP 47 language tags for precise language identification.

**BCP 47 語言標籤示例 | BCP 47 Language Tag Examples:**
- `zh-TW` - 台灣繁體中文 (Traditional Chinese, Taiwan)
- `zh-HK` - 香港繁體中文 (Traditional Chinese, Hong Kong)
- `zh-CN` - 簡體中文 (Simplified Chinese, China)
- `en-US` - 美式英語 (English, United States)
- `en-GB` - 英式英語 (English, United Kingdom)
- `ja-JP` - 日文 (Japanese, Japan)

**使用場景 | Use Cases:**
每個使用此模板的人可以設定自己偏好的自然語言，將 AGENTS.md、README、GitHub 模板等切換成該語言，而程式碼保持英文，確保團隊協作無障礙。

Each user can set their preferred natural language to switch AGENTS.md, README, GitHub templates, etc. to that language, while code remains in English to ensure seamless team collaboration.

**可用語系 | Available Locales:**
- ✅ `en-US` - English (US) - Base language
- ✅ `zh-TW` - Traditional Chinese (Taiwan)
- 🔜 `zh-HK` - Traditional Chinese (Hong Kong) - Planned
- 🔜 `zh-CN` - Simplified Chinese (China) - Planned
- 🔜 `ja-JP` - Japanese (Japan) - Planned

詳細設定請參考 [`i18n/README.md`](./i18n/README.md)。

For detailed setup, see [`i18n/README.md`](./i18n/README.md).

**參考標準 | Reference Standard:**
- [BCP 47 / RFC 5646 - Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646.html)
- [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry)
- [W3C Language Tags in HTML and XML](https://www.w3.org/International/articles/language-tags/)

## 🌐 語言支援 | Language Support

### 開箱即用支援 | Out-of-the-box Support

此模板的核心檔案（`.gitignore`, `.editorconfig`）已包含以下語言的基本支援：

This template's core files (`.gitignore`, `.editorconfig`) include basic support for:

- **Go** - Modern Go development
- **Python** - Python 3.x projects
- **TypeScript** - TypeScript/Node.js applications
- **Rust** - Rust systems programming

### 深度語言配置模組 | Deep Language Configuration Modules

在 `languages/` 目錄中提供各語言的**深度配置模組**，包含專屬的 linter、formatter、build tools 和範例：

The `languages/` directory provides **deep configuration modules** for each language, including language-specific linters, formatters, build tools, and examples:

```
languages/
├── go/              # Go: .golangci.yml, Makefile, go.mod.example
├── python/          # Python: pyproject.toml, .python-version
├── typescript/      # TypeScript: tsconfig.json, ESLint, package.json
└── rust/            # Rust: Cargo.toml, rust-toolchain.toml
```

**使用方式 | Usage:**

1. 選擇你的語言目錄 | Choose your language directory
2. 參考該目錄的 `README.md` | Refer to the `README.md` in that directory
3. 複製需要的配置檔案到專案根目錄 | Copy required config files to project root
4. 根據專案需求自訂配置 | Customize configs for your project needs

**範例 | Example (TypeScript):**

```bash
# 複製 TypeScript 專屬的 .gitignore 規則
cat languages/typescript/.gitignore >> .gitignore

# 複製 TypeScript compiler 配置
cp languages/typescript/tsconfig.json .

# 使用 package.json 作為參考
cp languages/typescript/package.json.example package.json

# 複製 ESLint 配置
cp languages/typescript/.eslintrc.json .
```

詳細的語言配置說明和最佳實踐，請參考各語言目錄內的 `README.md`。

For detailed language configuration instructions and best practices, refer to the `README.md` in each language directory.
## 📝 編碼規範

- 永遠先寫測試（TDD）
- 所有函數要有 docstring 和型別標注
- 避免過度工程化
- Commit message 使用繁體中文

詳細規範請參考 `AGENTS.md`。

## 🔖 版本管理

此模板採用 [語意化版本 2.0.0](https://semver.org/lang/zh-TW/) 進行版本管理。

- **查看當前版本**：`cat VERSION`
- **查看版本歷史**：參閱 [CHANGELOG.md](./CHANGELOG.md)
- **同步模板更新**：參閱 [.template/docs/TEMPLATE_SYNC.md](./.template/docs/TEMPLATE_SYNC.md)

### 如何將模板更新同步到現有專案？

如果你已經使用舊版本建立了專案，當模板發布新版本時，你可以選擇性地將新功能引入到你的專案中。

詳細的同步方法請參考 [.template/docs/TEMPLATE_SYNC.md](./.template/docs/TEMPLATE_SYNC.md)，支援：

- ✅ 選擇性手動同步（推薦）
- ✅ 使用 Git Remote 追蹤
- ✅ 完整差異比對

## 🎯 適用場景

這個模板適合：
- 需要 AI 輔助開發的專案
- 重視程式碼品質和文件的專案
- 採用測試驅動開發（TDD）的專案
- 需要記錄架構決策的專案

## 📚 資源

- [OpenCode 官方文件](https://github.com/OpenCodeProject/opencode)
- [Architecture Decision Records (ADR)](https://adr.github.io/)
- [語意化版本規範](https://semver.org/lang/zh-TW/)
- [Keep a Changelog](https://keepachangelog.com/zh-TW/1.0.0/)

## 📄 授權

此模板使用 MIT 授權。你可以自由使用、修改和分發。


## 使用此模板建立新專案

### 快速開始

1. **點擊 GitHub 的 "Use this template" 按鈕**
2. **執行初始化腳本**：
   ```bash
   ./.template/scripts/init-project.sh
   ```
3. **參考 [.template/docs/README_GUIDE.md](./.template/docs/README_GUIDE.md) 完成 README**

### 重要提醒

- ✅ 初始化腳本會自動記錄模板版本（`.template-version`）
- ✅ 原始 README 會備份到 `.template/docs/TEMPLATE_README.md.backup`
- ✅ 專案版本從 `0.1.0` 開始
- ⚠️ 記得更新 `AGENTS.md` 中的專案特定規範

### 同步模板更新

當模板有新版本時，參考 [.template/docs/TEMPLATE_SYNC.md](./.template/docs/TEMPLATE_SYNC.md)。