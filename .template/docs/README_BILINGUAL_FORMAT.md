# README Bilingual Format Rules

This document defines how AI agents should generate bilingual content in README.md based on `config.toml` locale settings.

## Core Principles

1. **Primary locale determines bilingual pairing**
2. **English (`en-US`) is always included** (unless primary locale IS English)
3. **Format: Primary language first, then English**

## Language Pairing Rules

```toml
# config.toml
[i18n]
primary_locale = "zh-TW"  # Traditional Chinese (Taiwan)
fallback_locale = "en-US"
```

**Result**: README is **Traditional Chinese + English**

### Language Pairing Table

| primary_locale | README Languages | Order |
|----------------|------------------|-------|
| `zh-TW` | 繁體中文 + English | Chinese first, then English |
| `zh-CN` | 简体中文 + English | Chinese first, then English |
| `ja-JP` | 日本語 + English | Japanese first, then English |
| `ko-KR` | 한국어 + English | Korean first, then English |
| `en-US` | English only | No bilingual needed |
| `en-GB` | English only | No bilingual needed |

## Formatting Rules

### 1. Headers (Headings)

**Format**: `## 中文 | English` (same line, separated by `|`)

**Example**:
```markdown
## 🏛️ 什麼是 My Vibe Scaffolding？ | What is My Vibe Scaffolding?
## ⚡ 核心功能 | Core Features
## 🎯 Vibe 技術選型 | Vibe Tech Stack
```

**❌ WRONG**:
```markdown
## 🏛️ 什麼是 My Vibe Scaffolding？

## What is My Vibe Scaffolding?
```

### 2. Paragraphs

**Format**: Chinese paragraph, blank line, English paragraph

**Example**:
```markdown
**AI 驅動的專案鷹架模板** — 基於心理學家 Lev Vygotsky 的鷹架理論，透過 AI 輔助快速建立專案結構、遵循最佳實踐，並在成長後自由拆除或客製化。

**AI-driven project scaffolding template** — Based on psychologist Lev Vygotsky's scaffolding theory, quickly build project structures with AI assistance, follow best practices, and freely remove or customize as you grow.
```

### 3. Bullet Lists

**Format**: Each bullet has Chinese line, then English line (using `<br>` or two spaces)

**Example**:
```markdown
- 🤖 **AI Agent 整合** — `AGENTS.md` 驅動的 OpenCode/Cursor 開發體驗  
  **AI Agent Integration** — OpenCode/Cursor development experience driven by `AGENTS.md`

- 🌐 **多語言支援** — BCP 47 i18n 系統，AI 自動適應使用者語言  
  **Multi-language Support** — BCP 47 i18n system, AI automatically adapts to user's language
```

### 4. Tables

**Format**: Each cell contains Chinese `<br>` English

**Example**:
```markdown
| 技術決策<br>Technology | 選擇理由<br>Why | 解決的問題<br>Problem Solved |
|---------|---------|-----------|
| **OpenCode（開源 AI 助手）**<br>**OpenCode (Open-source AI assistant)** | 75+ 模型支援、CLI 優先、可腳本化<br>75+ models, CLI-first, scriptable | 不被單一供應商綁定<br>Avoid vendor lock-in |
```

**Key**: Use `<br>` (HTML line break) inside table cells for line breaks.

### 5. Code Blocks

**Format**: Code appears ONCE (no duplication). Comments can be bilingual if needed.

**Example**:
```markdown
### 方式 1：AI 助手安裝（推薦） | Option 1: AI Assistant Install (Recommended)

在 OpenCode/Cursor/Claude 對話中貼上：  
Paste this in OpenCode/Cursor/Claude chat:

\```
my-vibe-scaffolding (scaffolding template)
Install and configure my-vibe-scaffolding by following the instructions here:
https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/main/.opencode/INSTALL.md
\```
```

**Example with bilingual comments**:
```markdown
\```bash
# 1. GitHub 點擊 "Use this template" → Clone 專案
# 1. Click "Use this template" on GitHub → Clone project
# 2. 初始化專案
# 2. Initialize project
./.template/scripts/init-project.sh
\```
```

**❌ WRONG**: Don't duplicate entire code blocks
```markdown
\```bash
# 中文版
./.template/scripts/init-project.sh
\```

\```bash
# English version
./.template/scripts/init-project.sh
\```
```

### 6. Links

**Format**: Inline bilingual description separated by `|`

**Example**:
```markdown
詳細說明 | For details: [INSTALL.md](./.opencode/INSTALL.md)

- [更新日誌](./CHANGELOG.md) - 版本變更記錄 | Version change log
- [模板同步](./.template/docs/TEMPLATE_SYNC.md) - 更新到新版本 | Update to new versions
```

## AI Agent Implementation

### Session Start Checklist

1. **Read `config.toml`**
   ```bash
   cat config.toml
   ```

2. **Extract `primary_locale`**
   ```toml
   [i18n]
   primary_locale = "zh-TW"
   ```

3. **Determine bilingual pairing**
   - If `zh-TW` → Traditional Chinese + English
   - If `ja-JP` → Japanese + English
   - If `en-US` → English only

4. **Apply formatting rules** from this document

### Code Example

```python
# Pseudocode for AI agents
def generate_readme_header(title_zh, title_en, primary_locale):
    if primary_locale == "en-US":
        return f"## {title_en}"
    else:
        return f"## {title_zh} | {title_en}"

def generate_readme_paragraph(content_zh, content_en, primary_locale):
    if primary_locale == "en-US":
        return content_en
    else:
        return f"{content_zh}\n\n{content_en}"
```

## Validation

### Correct README Structure

```markdown
## 🏛️ 什麼是 My Vibe Scaffolding？ | What is My Vibe Scaffolding?

**AI 驅動的專案鷹架模板** — 基於...

**AI-driven project scaffolding template** — Based on...

---

## ⚡ 核心功能 | Core Features

- 🤖 **AI Agent 整合** — `AGENTS.md` 驅動...  
  **AI Agent Integration** — OpenCode/Cursor experience...
```

### Common Mistakes

❌ **Headers on separate lines**
```markdown
## 什麼是 My Vibe Scaffolding？

## What is My Vibe Scaffolding?
```

❌ **Duplicated code blocks**
```markdown
\```bash
./.template/scripts/init-project.sh
\```

\```bash
./.template/scripts/init-project.sh
\```
```

❌ **Table cells without `<br>`**
```markdown
| Technology | Why |
|------------|-----|
| **OpenCode** (Open-source) | 75+ models |
```

## Version History

- **1.5.3** - Initial documentation (2026-02-26)
