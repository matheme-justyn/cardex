# AGENTS.md 標準指南

**Date**: 2026-03-10  
**Version**: 1.0.0  
**Template Mode**: Scaffolding

---

## 什麼是 AGENTS.md？

**AGENTS.md** 是一個開放的標準格式，用於為 AI coding assistants 提供專案特定的指令和上下文。

類比：**README.md 是給人類讀的，AGENTS.md 是給 AI agents 讀的**。

### 標準來源

- **Official Website**: [https://agents.md/](https://agents.md/)
- **Adoption**: 60,000+ open-source projects
- **Support**: OpenAI, Anthropic, Google, Amp, Factory 等共同制定

### 支援的工具

以下 AI coding assistants 原生支援 AGENTS.md：

| 工具 | 開發商 | 說明 |
|------|--------|------|
| **Claude Code** | Anthropic | CLI 和 VS Code extension |
| **Codex** | OpenAI | CLI for Codex |
| **Gemini CLI** | Google | Command-line interface |
| **Jules** | Google | AI coding assistant |
| **GitHub Copilot** | GitHub/Microsoft | VS Code integration |
| **Cursor** | Cursor.sh | AI-first IDE |
| **RooCode** | Cline fork | VS Code extension (574k installs) |
| **Windsurf** | Codeium | AI-powered IDE |
| **OpenCode** | OpenCode.ai | Open-source AI assistant |
| **VS Code** | Microsoft | 透過 AI extensions |
| **Aider** | Paul Gauthier | Command-line AI pair programmer |
| **Goose** | Block | CLI AI assistant |

---

## 基本格式

AGENTS.md 是純 Markdown 檔案，沒有強制的結構要求。這是它的優點：**簡單、靈活、易於維護**。

### 最小範例

```markdown
# AGENTS.md

## Setup commands
- Install deps: `npm install`
- Start dev server: `npm run dev`
- Run tests: `npm test`

## Code style
- TypeScript strict mode
- Single quotes, no semicolons
- Use functional patterns where possible
```

### 完整範例

```markdown
# AGENTS.md

## Project Overview
This is a [brief description of your project].

## Setup commands
- Install dependencies: `npm install`
- Start development server: `npm run dev`
- Run tests: `npm test`
- Build for production: `npm run build`

## Code Style
- **Language**: TypeScript with strict mode
- **Formatting**: Prettier with single quotes
- **Testing**: Jest for unit tests, Playwright for E2E
- **Always write tests first**: TDD approach

## Coding Conventions
- All functions must have JSDoc comments
- Use descriptive variable names
- Prefer functional programming patterns
- Avoid `any` types

## Commit Message Format
Format: `type: brief description`

Allowed types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation update
- `refactor`: Code refactoring
- `test`: Testing related
- `chore`: Other maintenance work

Example:
```
feat: add user authentication
fix: resolve memory leak in worker
```

## Pull Request Guidelines
1. Create feature branch from `main`
2. Write tests for new features
3. Ensure all tests pass
4. Update relevant documentation
5. Request review from team lead

## What NOT to do
- ❌ Don't change architecture without discussion
- ❌ Don't refactor existing code unless requested
- ❌ Don't install dependencies without discussion
- ❌ Don't commit directly to `main` branch

## Skill System
This project supports Agent Skills. See Skill System section below for details.
```

---

## 為什麼需要 AGENTS.md？

### README.md 的限制

README.md 通常包含：
- 專案簡介和功能特色
- 安裝和快速開始指引
- 貢獻指南和授權資訊

但 **README.md 不適合放太詳細的開發規範**，因為：
1. 會讓 README 變得冗長
2. 人類讀者不需要那麼多細節
3. AI 需要的資訊和人類不同

### AGENTS.md 補充了什麼

AGENTS.md 提供 AI agents 需要的具體指令：
- 精確的命令語法
- 詳細的編碼規範
- 禁止事項清單
- 測試和驗證流程

**分工**：
- **README.md** → 給人類：專案介紹、快速開始
- **AGENTS.md** → 給 AI：開發規範、禁止事項、詳細指令

---

## AGENTS.md 與 Skill System

AGENTS.md 和 Skill System 是互補的：

| 特性 | AGENTS.md | Skills (SKILL.md) |
|------|-----------|-------------------|
| **範圍** | 整個專案的通用規範 | 特定任務的專用指令 |
| **格式** | 自由 Markdown | YAML frontmatter + Markdown |
| **啟用方式** | 自動載入 | 手動引用 (`@skill-name`) |
| **適用情境** | 編碼風格、commit 格式、禁止事項 | TDD 流程、API 設計、安全審查 |
| **位置** | 專案根目錄 `AGENTS.md` | `.agents/skills/` 或 `~/.agents/skills/` |

**建議使用方式**：

1. **AGENTS.md** — 寫專案的普遍規範
   ```markdown
   ## Coding Conventions
   - Always write tests first
   - All functions must have type annotations
   ```

2. **Skills** — 寫可重複使用的工作流程
   ```markdown
   # skills/test-driven-development/SKILL.md
   
   ---
   name: test-driven-development
   description: Guide for TDD workflow
   ---
   
   # Test-Driven Development Workflow
   
   1. Write failing test first
   2. Implement minimum code to pass
   3. Refactor while keeping tests green
   ...
   ```

在 AGENTS.md 中可以引用 skills：

```markdown
## Testing Approach

We follow Test-Driven Development. Use the `@test-driven-development` skill when implementing new features.
```

### 在 AGENTS.md 中加入 Skill System 章節

建議在 AGENTS.md 中加入：

```markdown
## Skill System

本專案支援 Agent Skills 標準，讓 AI coding assistants 載入專用的任務指令。

### Skill 格式

Skills 使用 `SKILL.md` 檔案格式，包含 YAML frontmatter 和 Markdown 指令：

\`\`\`markdown
---
name: skill-name
description: Clear description of when to use this skill
---

# Skill Instructions

[Detailed guidance for the AI agent]
\`\`\`

### Skill 安裝位置

**全域 skills (所有專案可用)**:
- `~/.agents/skills/` — Cross-agent, shared with Codex, RooCode, etc.
- `~/.claude/skills/` — Claude Code specific
- `~/.roo/skills/` — RooCode specific

**專案 skills (當前專案)**:
- `.agents/skills/` — Cross-agent, team-shared
- `.claude/skills/` — Claude Code specific

### 使用 Skills

在提示中使用 `@skill-name` 引用 skill：

\`\`\`
Use @brainstorming to plan this feature.
\`\`\`

### Skill 範例

參考 `.template/docs/examples/skills/` 中的範例。

### 延伸閱讀

- [AGENTS.md Standard](https://agents.md/) — Open format for agent instructions
- [Agent Skills Specification](https://agentskills.io/) — SKILL.md format standard
- [Skill Management Guide](./docs/users/skill-management.md) — 本專案的 skill 管理指南
```

---

## Monorepo 支援

AGENTS.md 支援階層式配置：

```
my-monorepo/
├── AGENTS.md                    # 通用規範
├── packages/
│   ├── frontend/
│   │   └── AGENTS.md           # Frontend 專用規範
│   ├── backend/
│   │   └── AGENTS.md           # Backend 專用規範
│   └── shared/
│       └── AGENTS.md           # Shared library 規範
```

**優先權**：最接近的 AGENTS.md 優先。

例如：在 `packages/frontend/` 工作時，AI 會讀取：
1. `packages/frontend/AGENTS.md` （最高優先）
2. 根目錄的 `AGENTS.md` （次要參考）

---

## 最佳實踐

### 1. 保持簡潔

AGENTS.md 應該簡短且易於掃描。避免冗長的解釋。

❌ **不好**：
```markdown
## Testing
We use Jest for testing. Jest is a JavaScript testing framework...
(長篇大論 Jest 的介紹)
```

✅ **好**：
```markdown
## Testing
- Framework: Jest
- Run tests: `npm test`
- Write tests first (TDD)
```

### 2. 使用具體命令

給 AI 可以直接執行的命令，而非模糊的描述。

❌ **不好**：
```markdown
## Setup
Install dependencies and start the server
```

✅ **好**：
```markdown
## Setup
\`\`\`bash
npm install
npm run dev
\`\`\```

### 3. 明確禁止事項

「What NOT to do」比「What to do」更重要，因為它防止 AI 犯錯。

```markdown
## What NOT to do
- ❌ **Never** use `as any` or `@ts-ignore`
- ❌ **Never** commit directly to `main`
- ❌ **Never** install dependencies without discussion
```

### 4. 定期更新

AGENTS.md 是活文件。隨著專案演進，持續更新：
- 新的編碼規範
- 新的工具或框架
- 新的禁止事項

### 5. 與 README 協調

確保 AGENTS.md 和 README.md 資訊一致：
- 命令應該相同
- 技術棧應該匹配
- 不要有矛盾的說明

---

## 範例：不同類型專案的 AGENTS.md

### TypeScript Full-stack App

```markdown
# AGENTS.md

## Tech Stack
- **Frontend**: React + TypeScript
- **Backend**: Node.js + Express
- **Database**: PostgreSQL with Prisma
- **Testing**: Jest + React Testing Library

## Setup
\`\`\`bash
npm install
npm run db:migrate
npm run dev
\`\`\`

## Code Style
- TypeScript strict mode
- ESLint + Prettier
- No `any` types
- Use functional components (React)

## Testing
- Write tests first (TDD)
- Coverage target: 80%+
- Run: `npm test`

## Commit Format
`type: description` (feat/fix/docs/refactor/test/chore)

## What NOT to do
- ❌ Don't use class components
- ❌ Don't bypass TypeScript errors
- ❌ Don't commit `.env` files
```

### Python Data Science Project

```markdown
# AGENTS.md

## Tech Stack
- **Language**: Python 3.11+
- **Framework**: pandas, scikit-learn, matplotlib
- **Testing**: pytest
- **Code Quality**: black, mypy, ruff

## Setup
\`\`\`bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
\`\`\`

## Code Style
- Follow PEP 8
- Format with black
- Type hints required (mypy)
- Docstrings for all public functions

## Testing
- Write tests with pytest
- Use fixtures for data
- Run: `pytest tests/`

## What NOT to do
- ❌ Don't use mutable default arguments
- ❌ Don't ignore type checking warnings
- ❌ Don't commit Jupyter checkpoint files
```

---

## 常見問題

### Q: AGENTS.md 是必須的嗎？

**A**: 不是必須，但強烈建議。60,000+ 專案採用證明了它的價值。

### Q: AGENTS.md 和 .cursorrules 的關係？

**A**: Cursor 最初使用 `.cursorrules`，但現在也支援 `AGENTS.md`。建議使用 AGENTS.md 以獲得跨工具相容性。

### Q: AGENTS.md 會暴露敏感資訊嗎？

**A**: 不要在 AGENTS.md 中放敏感資訊（API keys, passwords）。只放開發規範和流程。

### Q: AGENTS.md 需要提交到 Git 嗎？

**A**: **是的**。AGENTS.md 應該被提交並與團隊共享，就像 README.md 一樣。

### Q: 如何測試 AGENTS.md 是否有效？

**A**: 請 AI assistant 執行一個任務，觀察它是否遵循 AGENTS.md 中的規範。例如：
```
Create a new user authentication module.
(觀察 AI 是否先寫測試、是否遵循 commit 格式等)
```

---

## 延伸閱讀

- [agents.md](https://agents.md/) — Official website
- [SKILL.md Format Guide](./.template/docs/SKILL_FORMAT_GUIDE.md) — Skill 格式詳解
- [ADR 0007](./.template/docs/adr/0007-agent-skills-ecosystem-integration.md) — Agent skills 整合決策

---

## Changelog

| 日期 | 版本 | 變更 |
|------|------|------|
| 2026-03-10 | 1.0.0 | 初始版本 |
