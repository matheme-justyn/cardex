<div align="center">

<img src="./.template/assets/images/20260225_vibe-scaffolding-logo.png" alt="Vibe Scaffolding Logo" width="400"/>

# My Vibe Scaffolding

[![Version](https://img.shields.io/badge/version-1.12.0-blue.svg)](./.template/VERSION)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![Semantic Versioning](https://img.shields.io/badge/semver-2.0.0-blue)](https://semver.org/)

English | [繁體中文](./README.zh-TW.md)

</div>

> **📌 This is the Template's README**  
> If you've used this template for your project, run `.template/scripts/init-project.sh` to initialize your project

## 🏛️ What is My Vibe Scaffolding?

**AI-driven project scaffolding template** — Based on psychologist Lev Vygotsky's scaffolding theory, quickly build project structures with AI assistance, follow best practices, and freely remove or customize as you grow.

<div align="center">
<img src="./.template/assets/images/20260225_vibe-scaffolding-illustration-american.png" alt="American Style" width="300"/>
<img src="./.template/assets/images/20260225_vibe-scaffolding-illustration-japanese.png" alt="Japanese Style" width="300"/>
</div>

---

## ⚡ Core Features

### 🤖 AI Agent Integration

OpenCode/Cursor development experience driven by `AGENTS.md`, AI automatically follows project conventions.

<details>
<summary>📄 AGENTS.md Preview</summary>

```markdown
# AGENTS.md

## Coding Conventions
- **Always write tests first**: All new features and bug fixes must have tests first
- **All functions must have docstrings and type annotations**

## Commit Message
Format: `type: brief description`
Allowed types: feat, fix, docs, refactor, test, chore

## What NOT to do
- ❌ Don't change architecture without discussion
- ❌ Don't refactor existing code unless requested
```

→ Full content: [AGENTS.md](./AGENTS.md)
</details>

### 🌐 Multi-language Support

BCP 47 i18n system, AI automatically adapts to user's language preference.

### 📦 Strict Version Management

Pre-push hook enforces version updates, preventing version chaos. Every push ensures version number is updated.

<details>
<summary>🔍 How It Works</summary>

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

### 🗂️ File Separation Design

`.template/` isolates scaffolding infrastructure, keeping project files clean and independent.

<details>
<summary>📁 Directory Structure</summary>

```
.template/          # Scaffolding infrastructure (template core)
├── docs/           # Template documentation
├── scripts/        # Template scripts
└── VERSION         # Template version

.opencode/          # OpenCode AI assistant configuration
└── INSTALL.md      # AI-assisted installation instructions

docs/               # Your project documentation
scripts/            # Your project scripts
VERSION             # Your project version (independent from template version)
```

**Version Files:**
- `.template/VERSION`: Template version (which scaffolding version you're using)
- `VERSION`: Your project version

→ See [AGENTS.md § Working Mode](./AGENTS.md#working-mode)
</details>

### 📚 Complete Project Guides

Interactive setup for LICENSE, CONTRIBUTING, SECURITY.

---

## 🎯 Tech Stack

🧠 **Core Concept: Turn AI assistants into your virtual dev team**

We use [superpowers](https://github.com/ohmyopencode/superpowers) — reusable AI development workflows.

| Technology | Why | Problem Solved |
|---------|---------|-----------|
| **OpenCode** (Open-source AI assistant) | 75+ models, CLI-first, scriptable | Avoid vendor lock-in |
| **AGENTS.md Standard** | Cross-tool compatible (OpenCode/Cursor/Windsurf) | AI understands project conventions |
| **superpowers Skills** | Reusable development workflows | Encode best practices as executable commands |
| **Subagents (Multi-agent)** | Specialized roles (explore/librarian/oracle) | Simulate real team collaboration |
| **Single-instance Workflow** | Avoid SQLite conflicts (ADR 0005) | Stability boost (crashes: daily → weekly) |
| **MCP Servers Support** | Connect external tools (DB, API, services) | Extend AI capabilities |

_Choose open, composable, community-driven tools over closed commercial solutions._

---

## 🚀 Quick Install

### Option 1: AI Assistant Install (Recommended)

Paste this in OpenCode/Cursor/Claude chat:

```
my-vibe-scaffolding (scaffolding template)
Install and configure my-vibe-scaffolding by following the instructions here:
https://raw.githubusercontent.com/matheme-justyn/my-vibe-scaffolding/main/.opencode/INSTALL.md
```

### Option 2: Manual Install

```bash
# 1. Click "Use this template" on GitHub → Clone project
# 2. Initialize project
./.template/scripts/init-project.sh
```

For details: [INSTALL.md](./.opencode/INSTALL.md)

---

## 📖 Documentation

- [Template Changelog](./.template/CHANGELOG.md) - Template version changes
- [Project Changelog](./CHANGELOG.md) - Your project changes
- [Template Sync](./.template/docs/TEMPLATE_SYNC.md) - Update to new versions
- **[Quick Update Guide](./.template/docs/QUICK_UPDATE.md)** - Fast update for existing projects (OpenCode multi-project support)
- [Project Guides](./.template/docs/) - LICENSE, CONTRIBUTING, SECURITY writing guides

---

## 📄 License

MIT License - See [LICENSE](./LICENSE)

---

<div align="center">

**Based on Vygotsky's Scaffolding Theory | Powered by AI | Designed for Developers**

</div>
