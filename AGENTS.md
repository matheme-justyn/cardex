
## System Environment

**CRITICAL: Read system information from `config.toml` before executing commands.**

The `[system]` section contains auto-detected operating system information:

```toml
[system]
os_type = "macOS"  # or "Linux", "Windows"
os_version = "26.3"
shell = "/bin/zsh"

[system.commands]
timeout_command = "none"  # macOS doesn't have timeout by default
sed_inplace = "sed -i ''"  # macOS requires empty string argument
has_brew = true
has_apt = false
# ... other command availability flags
```

### Command Selection Examples

**Before using commands with OS-specific differences:**

1. **timeout command** (Linux has it, macOS doesn't):
   ```bash
   # ❌ WRONG: Assume timeout exists
   timeout 5 command
   
   # ✅ CORRECT: Check config.toml first
   # If timeout_command = "none" → use alternative (sleep + kill)
   # If timeout_command = "gtimeout" → use gtimeout
   # If timeout_command = "timeout" → use timeout
   ```

2. **sed in-place editing** (macOS vs Linux syntax difference):
   ```bash
   # ❌ WRONG: Use Linux syntax on macOS
   sed -i 's/foo/bar/' file.txt  # Fails on macOS
   
   # ✅ CORRECT: Use config.toml value
   # Read sed_inplace from config.toml:
   #   macOS: sed -i ''
   #   Linux: sed -i
   ```

3. **Package managers**:
   ```bash
   # Check has_brew, has_apt, has_yum, has_choco
   # Install based on available package manager
   ```

### Updating System Information

System information is automatically detected and updated by:

```bash
./.template/scripts/detect-os.sh
```

This script is run during project initialization. Re-run it if:
- Operating system changes (e.g., WSL → native Linux)
- New development tools are installed
- AI agent encounters "command not found" errors


# AGENTS.md

This document serves as the primary instruction set for AI agents (like OpenCode) working on this project.

## Project Overview


**Cardex** is an academic knowledge management system — from PDF to structured knowledge cards.

**📋 Product Requirements**: See [docs/PRD.md](./docs/PRD.md) for complete specification.

**Key Features:**
- Automated PDF ingestion with metadata extraction
- Multi-angle summarization via pluggable Skill system
- Evidence-based quality assessment
- Citation graph and unread alerts
- AI-assisted argumentation engine


## Working Mode

**This scaffolding has two working modes configured in `config.toml`:**

### Scaffolding Mode (`mode = "scaffolding"`)

You're developing this scaffolding itself. File organization:

- **Scaffolding ADRs**: `.template/docs/adr/`
- **Scaffolding scripts**: `.template/scripts/`
- **Scaffolding assets**: `.template/assets/`
- **Root directories**: Keep `docs/`, `scripts/`, `assets/` empty or minimal

**AI Agent behavior:**
- Create new ADRs in `.template/docs/adr/`
- Reference scaffolding scripts from `.template/scripts/`
- Reference scaffolding assets from `.template/assets/`
- **Generate bilingual README** following [README_BILINGUAL_FORMAT.md](./.template/docs/README_BILINGUAL_FORMAT.md)
- **CHANGELOG**: Update `.template/CHANGELOG.md` (template changes)
- **README sync**: If `sync_readme = true`, root `README.md` auto-syncs to `.template/README.md`

### Project Mode (`mode = "project"`)

You're using this scaffolding for your project. File organization:

- **Project ADRs**: `docs/adr/`
- **Project scripts**: `scripts/`
- **Project assets**: `assets/`
- **.template/ directory**: Contains reference examples only

**AI Agent behavior:**
- Create new ADRs in `docs/adr/`
- Place project-specific scripts in `scripts/`
- Place project-specific assets in `assets/`
- Reference `.template/` examples but don't modify them
- **CHANGELOG**: Update root `CHANGELOG.md` (your project changes)
- **README**: Edit root `README.md` for your project (independent from template)

**To change mode:** Edit `config.toml` and set `[project] mode = "scaffolding"` or `"project"`



## Default Skills for This Project

**Auto-load these skills based on task context:**

| Task Type | Skills | Trigger Keywords |
|-----------|--------|------------------|
| Feature Development | `superpowers/brainstorming`<br>`superpowers/test-driven-development` | "新增功能", "實作", "開發" |
| Bug Fixing | `superpowers/systematic-debugging` | "bug", "錯誤", "修正", "不work" |
| Code Review | `superpowers/requesting-code-review` | "review", "檢查程式碼" |
| Planning | `superpowers/brainstorming`<br>`superpowers/writing-plans` | "規劃", "設計", "架構" |
| Git Workflow | `superpowers/using-git-worktrees` | "feature branch", "worktree" |

**Usage:**
```
# AI will auto-detect based on your request
User: "新增使用者登入功能"  → auto-loads brainstorming + test-driven-development
User: "修正登入 bug"        → auto-loads systematic-debugging

# Or manually load via skill tool
skill(name="superpowers/brainstorming")
```

**Available Skills:** See `.template/docs/SKILLS_USAGE_GUIDE.md` for complete guide.


## Tech Stack

<!-- TODO: List technologies, frameworks, and tools used in this project -->

## MCP (Model Context Protocol) Usage

**Priority: Always check for MCP tools first, then fallback to CLI.**

### GitHub Operations Priority

When performing GitHub operations (issues, PRs, releases):

1. **First**: Check if GitHub MCP server tools are available
   - Tool names: `github_*` (e.g., `github_create_issue`, `github_create_pull_request`)
   - Advantages: Faster, structured responses, cross-tool compatible

2. **Fallback**: Use `gh` CLI if MCP not available
   - Via `bash` tool: `gh issue create`, `gh pr create`, etc.
   - Reliable but slower (subprocess overhead)

### How to Check MCP Availability

```typescript
// At session start, list available tools
// If you see tools starting with 'github_', 'git_', 'filesystem_' → MCP is active
// If not → Use CLI fallbacks (gh, git commands via bash)
```

### MCP Servers Configuration

- **filesystem**: File operations (read/write/search)
- **git**: Git operations (status, diff, commit, push)
- **memory**: Persistent memory across sessions
- **github**: GitHub API (issues, PRs, releases, workflows)

Configuration: `opencode.json`  
Setup guide: [.template/docs/MCP_SETUP_GUIDE.md](./.template/docs/MCP_SETUP_GUIDE.md)

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

## AI Agent Communication Protocol

**CRITICAL: AI agents MUST follow this protocol at the start of EVERY session.**

### 1. Read User's Language Preference

On session start, ALWAYS read the user's language configuration:

```bash
# Read config.toml
[i18n]
primary_locale = "zh-TW"  # User's preferred language
fallback_locale = "en-US"
```

**If config.toml doesn't exist:** Use `en-US` as default.

### 2. Load Translation Files

Load translations from `.template/i18n/locales/{primary_locale}/`:

- `agents.toml` - Coding conventions, commit format, PR guidelines
- `readme.toml` - Project documentation phrases
- `templates.toml` - Issue/PR template text
- `adr.toml` - ADR template phrases

**Example (zh-TW):**
```bash
# Load coding conventions
.template/i18n/locales/zh-TW/agents.toml

[coding_conventions]
title = "編碼規範"
test_first = "**永遠先寫測試**：所有新功能和 bug 修復都必須先寫測試"
```

### 3. Communication Language Rules

**Use the user's configured language for ALL responses and communication:**

| Configuration | Communication Language | Example |
|---------------|------------------------|---------|
| `primary_locale = "zh-TW"` | 繁體中文（台灣） | "我已經完成了這個功能..." |
| `primary_locale = "en-US"` | English (US) | "I've completed this feature..." |
| `primary_locale = "ja-JP"` | 日本語 | "この機能を完了しました..." |

**Code and Technical Terms:**
- Variable names, function names → Always English
- Code comments → Use primary_locale language
- Commit messages → Follow locale-specific format in `agents.toml`
- Technical documentation → Use primary_locale language

### 4. Fallback Strategy

If a translation key is missing:

1. Check `fallback_locale` in config.toml (usually `en-US`)
2. Load the key from fallback locale
3. Continue without error
4. Optionally note the missing translation

### 5. Session Start Checklist

**Before responding to ANY user message:**

- [ ] Read `config.toml` and identify `primary_locale`
- [ ] Load translation files from `.template/i18n/locales/{primary_locale}/`
- [ ] Set communication language to match `primary_locale`
- [ ] Verify fallback locale is available

### 6. README Generation Protocol

**CRITICAL: Check `config.toml` README strategy BEFORE generating any README files.**

1. **Read README strategy from config:**
   ```toml
   [i18n.readme]
   strategy = "separate"  # or "bilingual" or "primary_only"
   ```

2. **Generate README based on strategy:**

   **If `strategy = "separate"` (Recommended):**
   - Create `README.md` in `primary_locale`
   - Create `README.{lang}.md` for each language in `commit_locales` (except primary)
   - Add language switcher at top of each file (e.g., `English | [繁體中文](./README.zh-TW.md)`)
   - Each file is **single-language** (standard Markdown)
   - Load content from `i18n/locales/{lang}/readme.toml`

   **Example output:**
   ```
   README.md          -> Chinese (if primary_locale = zh-TW)
   README.en-US.md    -> English
   README.ja-JP.md    -> Japanese (if ja-JP in commit_locales)
   ```

   **If `strategy = "bilingual"`:**
   - Create single `README.md` with both primary and fallback languages
   - Follow strict formatting: [中文 | English] pattern
   - See [`.template/docs/README_BILINGUAL_FORMAT.md`](./.template/docs/README_BILINGUAL_FORMAT.md) for detailed rules
   - Headers: `## 中文 | English` (same line)
   - Paragraphs: Chinese paragraph, blank line, English paragraph
   - Tables: Each cell contains `中文<br>English`

   **If `strategy = "primary_only"`:**
   - Create single `README.md` in `primary_locale` only
   - No translations, no language switcher
   - Standard Markdown

3. **Verify language switcher (for separate strategy):**
   - Top of README.md: Links to all language versions
   - Format: `English | [繁體中文](./README.zh-TW.md) | [日本語](./README.ja-JP.md)`
   - Current language shows as plain text (no link to itself)

4. **Validation:**
   - Separate: Each README file exists and is single-language
   - Bilingual: Single README.md follows bilingual formatting rules
   - Primary only: Only README.md exists

**Reference:** [`.template/docs/README_BILINGUAL_FORMAT.md`](./.template/docs/README_BILINGUAL_FORMAT.md)

**This is MANDATORY. No exceptions.**


## Documentation Standards

**CRITICAL: All AI agents MUST follow these rules when creating or modifying documentation.**

### Core Principles

1. **Read First**: Before creating ANY new document, check [`.template/docs/DOCUMENTATION_GUIDELINES.md`](./.template/docs/DOCUMENTATION_GUIDELINES.md)
2. **Root Level Simplicity**: Keep root directory minimal (only core files)
3. **No Intermediate Files**: No `GET_STARTED.md`, `TASK_*.md`, etc.
4. **Template vs Project**: Distinguish framework docs from project-specific docs

### Required Reading

- **[`.template/docs/DOCUMENTATION_GUIDELINES.md`](./.template/docs/DOCUMENTATION_GUIDELINES.md)** - File organization standards (MUST READ)
- **[`.template/docs/README_GUIDE.md`](./.template/docs/README_GUIDE.md)** - How to write project README when using this template
- **[`.template/docs/TEMPLATE_SYNC.md`](./.template/docs/TEMPLATE_SYNC.md)** - How to sync template updates

### When Creating Documents

**Ask yourself:**
1. Is this core functionality? → `docs/` or `docs/adr/`
2. Is this temporary? → Use `.worklog/` (gitignored) or don't create
3. Is this tool-specific? → Belongs in tool's own docs, not project root
4. Is this already documented? → Update existing file instead

### File Placement Rules

| File Type | Location | Example |
|-----------|----------|---------|
| Architecture decisions | `docs/adr/NNNN-*.md` | `0005-single-instance-opencode.md` |
| Core documentation | `docs/*.md` | `DOCUMENTATION_GUIDELINES.md` |
| Work logs (personal) | `.worklog/YYYY-MM-DD.md` | Gitignored, daily files |
| Tool usage guides | Tool's own README | `scripts/wl` → usage in `--help` |

**❌ NEVER create:**
- Root-level intermediate files (GET_STARTED, TASK_COMPLETION, etc.)
- Problem-specific guides (OPENCODE_STABILITY, etc.)
- Tool tutorials as separate docs

### Version Management

**CRITICAL: Every push to main MUST have a version bump.**

**Why:** Direct main branch workflow (no dev branch) means every commit is potentially "released". Without version bumps, v1.2.0 before your change and v1.2.0 after your change are different, causing confusion.

**Enforcement:**
- Pre-push git hook automatically checks if VERSION has been updated
- Push will be blocked if version hasn't changed since last tag
- Install hooks: `./.template/scripts/install-hooks.sh`

**Workflow:**
1. Make your changes
2. **Before committing**, bump version:
   ```bash
   ./.template/scripts/bump-version.sh patch  # Bug fixes
   ./.template/scripts/bump-version.sh minor  # New features
   ./.template/scripts/bump-version.sh major  # Breaking changes
   ```
3. The script will:
   - Update `.template/VERSION` and `VERSION`
   - Update `.template/CHANGELOG.md` and `README.md` badges
   - Create commit with version bump
   - Create git tag
4. Push (hook will verify version changed):
   ```bash
   git push && git push --tags
   ```

**For template maintainers:**
- Version file: `.template/VERSION`
- Always update `.template/CHANGELOG.md` when bumping version
- Create meaningful release notes

**Semantic Versioning Rules (MAJOR.MINOR.PATCH):**

Given a version number MAJOR.MINOR.PATCH (e.g., 1.3.0):

**PATCH (1.3.0 → 1.3.1)** - Bug fixes, documentation updates:
- ✅ Fix typos in documentation
- ✅ Fix broken links
- ✅ Correct code comments
- ✅ Fix linter warnings
- ✅ Security patches that don't change API
- ✅ Performance improvements (no API change)

**MINOR (1.3.0 → 1.4.0)** - New features (backward compatible):
- ✅ Add new optional parameters to functions
- ✅ Add new files/scripts
- ✅ Add new configuration options (with defaults)
- ✅ Deprecate features (but still functional)
- ✅ Add new documentation sections
- ✅ Enhance existing features without breaking old usage

**MAJOR (1.3.0 → 2.0.0)** - Breaking changes (STRICT CRITERIA):

**Only these scenarios qualify as breaking:**

1. **Remove or rename files that users depend on**
   - ❌ DELETE: `scripts/my-tool.sh` (if users run it)
   - ❌ RENAME: `AGENTS.md` → `AI_AGENTS.md`
   - ✅ OK: Add new files (not breaking)
   - ✅ OK: Rename internal `.template/` files (users don't directly use)

2. **Change required configuration format**
   - ❌ CHANGE: `config.toml` structure requires migration
   - ❌ REMOVE: Required config key without default
   - ✅ OK: Add optional config with sensible default
   - ✅ OK: Deprecate config (still works with warning)

3. **Change command signatures that break existing usage**
   - ❌ CHANGE: `bump-version.sh <type>` → `bump-version.sh --type <type>`
   - ❌ REMOVE: Required parameter
   - ✅ OK: Add optional parameter
   - ✅ OK: Add new command

4. **Change output format that tools depend on**
   - ❌ CHANGE: Script output from JSON to YAML
   - ❌ REMOVE: Expected output field
   - ✅ OK: Add new output fields
   - ✅ OK: Improve error messages

**Common misconceptions (NOT breaking):**
- ❌ Moving files within `.template/` (internal structure)
- ❌ Refactoring code (if API unchanged)
- ❌ Improving documentation
- ❌ Adding new features alongside old ones
- ❌ Changing internal implementation
- ❌ Reorganizing directory structure (if paths still work)

**When in doubt: Choose MINOR over MAJOR.**

Breaking changes require users to modify their code/config. If they don't need to change anything, it's NOT breaking.

**PROJECT-SPECIFIC VERSION POLICY:**

**🚨 CRITICAL: This project uses 0.X versioning until official release.**

- **All versions MUST stay below 1.0.0** until the project owner explicitly announces official release
- Version format: `0.MINOR.PATCH`
  - **0.1.0 → 0.2.0**: New features (equivalent to MINOR bump)
  - **0.2.0 → 0.2.1**: Bug fixes (equivalent to PATCH bump)
  - **0.X.Y → 1.0.0**: **FORBIDDEN** until official release announcement
- This signals to users that the API is not yet stable and may change
- Breaking changes are allowed in 0.X versions (part of pre-1.0 development)

**When bumping versions:**
```bash
./.template/scripts/bump-version.sh patch  # 0.1.0 → 0.1.1 (bug fixes)
./.template/scripts/bump-version.sh minor  # 0.1.0 → 0.2.0 (new features)
./.template/scripts/bump-version.sh major  # BLOCKED - will not exceed 0.X
```

**Before 1.0.0 release:**
- Core features must be stable
- API must be finalized
- Documentation must be complete
- Explicit approval from project owner required



**For template users:**
- After "Use this template": run `./.template/scripts/init-project.sh`
- This creates `.template-version` to track which template version you're using
- See [`.template/docs/README_GUIDE.md`](./.template/docs/README_GUIDE.md) for project README guidance
