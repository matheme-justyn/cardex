# AGENTS.md

This document serves as the primary instruction set for AI agents (like OpenCode) working on this project.

## Project Overview

<!-- TODO: Fill in project description, goals, and context -->

## Tech Stack

<!-- TODO: List technologies, frameworks, and tools used in this project -->

## Coding Conventions

- **永遠先寫測試**：所有新功能和 bug 修復都必須先寫測試
- **所有函數要有 docstring 和型別標注**：確保程式碼可讀性和可維護性
- **避免過度工程化**：保持簡單，只實作當前需要的功能

## Commit Message

Write commit messages in English, format:

```
type: brief description
```

**Allowed types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation update
- `refactor`: Refactoring (code improvement without changing functionality)
- `test`: Testing related
- `chore`: Other maintenance work

**Examples:**
```
feat: add user login functionality
fix: resolve database connection error
docs: update API documentation
```

## Pull Request

### PR Title Format (Angular Style)

**使用英文，格式為：**

```
type(scope): brief description
```

**允許的 type：**
- `feat`: 新功能 (New feature)
- `fix`: 修復 bug (Bug fix)
- `docs`: 文件更新 (Documentation)
- `style`: 程式碼風格 (Code style)
- `refactor`: 重構 (Refactoring)
- `test`: 測試 (Tests)
- `chore`: 維護性工作 (Maintenance)

**範例：**
```
feat(auth): add JWT authentication
fix(api): resolve memory leak in user service
docs(readme): update installation guide
refactor(core): simplify error handling logic
```

### PR 內容原則

- **簡潔為主**：只寫重點，避免冗長說明
- **中英並列**：重要資訊使用中英文對照
- **條列式**：使用 bullet points，每點簡短明確
- **必要資訊**：What（做了什麼）、Why（為什麼）、Testing（如何測試）

## File Structure

<!-- TODO: Document the project's directory structure and organization -->

## What NOT to do

- ❌ **不要自作主張改架構**：任何架構變更都必須先討論
- ❌ **不要在沒被要求的情況下重構既有程式碼**：專注在當前任務
- ❌ **不要安裝沒討論過的 dependency**：新增套件前必須先討論必要性和替代方案

## Internationalization (i18n)

This template supports multiple natural languages for documentation and templates using **BCP 47 (RFC 5646)** language tags.

### Quick Start

1. Copy the config example:
   ```bash
   cp config.toml.example config.toml
   ```

2. Edit `config.toml` to set your preferred language:
   ```toml
   [locale]
   primary = "zh-TW"  # or "en-US", "ja-JP", etc.
   fallback = "en-US"
   ```

3. The following content will adapt to your language:
   - This file (AGENTS.md) - Coding conventions, commit format
   - README.md - Project description, usage instructions
   - GitHub templates - Issue/PR templates
   - ADR templates - Architecture decision records

**Note:** Code (variable names, function names, comments) stays in English for universal comprehension.

### Available Languages

- `en-US` - English (United States) - Base language
- `zh-TW` - Traditional Chinese (Taiwan)
- `zh-HK` - Traditional Chinese (Hong Kong) - Planned
- `zh-CN` - Simplified Chinese (China) - Planned
- `ja-JP` - Japanese (Japan) - Planned

### Why BCP 47?

BCP 47 (RFC 5646) is the IETF standard for language identification, used by:
- W3C WCAG (Web accessibility)
- HTML `lang` attribute
- EPUB (e-books)
- Unicode CLDR

This allows precise distinction between:
- `zh-TW` (台灣繁體) vs `zh-HK` (香港繁體) vs `zh-CN` (簡體)
- `en-US` (American English) vs `en-GB` (British English)

### Git Strategy

**Committed to Git:**
- `config.toml.example` - Configuration template
- `i18n/locales/en-US/` - English (base)
- `i18n/locales/zh-TW/` - Traditional Chinese (Taiwan)

**Not committed (`.gitignored`):**
- `config.toml` - Your personal language preference

This allows each team member to use their preferred language locally while maintaining a language-agnostic codebase.

For detailed information, see [`i18n/README.md`](./i18n/README.md).

**Reference:** [RFC 5646 - Language Tags](https://www.rfc-editor.org/rfc/rfc5646.html)
