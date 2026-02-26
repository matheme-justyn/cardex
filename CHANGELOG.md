# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.5.4] - 2026-02-26

### Changed
- **README Format**: Complete restructure to proper bilingual format
  - Headers: `## 中文 | English` (same line)
  - Bullet lists: Chinese line, then English line (two-space line break)
  - Tables: `<br>` for line breaks within cells (Chinese<br>English)
  - Code blocks: Appear only once (no duplication)
  - Links: Inline bilingual `詳細說明 | For details:`

### Added
- **README_BILINGUAL_FORMAT.md**: Complete bilingual formatting rules for AI agents
  - Language pairing rules (zh-TW+EN, ja-JP+EN, etc.)
  - Formatting rules for headers, paragraphs, lists, tables, code
  - AI agent implementation guidelines
  - Validation examples and common mistakes

### Fixed
- AGENTS.md now references README_BILINGUAL_FORMAT.md for bilingual generation


## [1.5.3] - 2026-02-26

### Changed
- **README Quick Install**: Fixed bilingual format - code blocks appear only once (not duplicated for each language)
  - Chinese description + English description + Code block (once)
  - Comments in code blocks are bilingual where appropriate


## [1.5.2] - 2026-02-26

### Changed
- **README Bilingual Format**: Restructured to paragraph-by-paragraph format (Chinese then English)
- **README Illustrations**: Added back two illustrations under scaffolding theory section
- **README Tech Stack**: Core philosophy changed from heading to italic text


### Changed
- **README Simplification**: Drastically simplified README to focus on core message
  - What is this scaffolding
  - Core features (bullet points)
  - **Vibe Tech Stack**: Replaced generic tech choices (BCP 47, SemVer, TOML) with actual Vibe methodology
    - OpenCode, AGENTS.md, superpowers Skills, Subagents, Single-instance workflow, MCP
  - Quick installation (one-line AI command)
  - Removed detailed sections (moved to INSTALL.md and .template/docs/)


### Changed
- **README Simplification**: Drastically simplified README to focus on core message
  - What is this scaffolding
  - Core features (bullet points)
  - Vibe Coding tech stack choices
  - Quick installation (one-line AI command)
  - Removed detailed sections (moved to INSTALL.md and .template/docs/)


## [1.5.0] - 2026-02-26

### Added
- **One-Line Installation for AI Assistants**:
  - Created `.opencode/INSTALL.md` with comprehensive installation guide
  - Support for OpenCode, Cursor, and other AI assistants
  - Three installation options: New project, Existing project, Cherry-pick features
  - AI can read and guide users through the entire setup process

### Changed
- **README Updates**:
  - Added Quick Install section with AI-friendly one-liner
  - Reorganized installation instructions for clarity
  - Added manual installation alternatives

### Documentation
- **INSTALL.md Sections**:
  - Option 1: New Project (GitHub template method)
  - Option 2: Integrate into Existing Project (git merge method)
  - Option 3: Cherry-Pick Features (selective installation)
  - Configuration guide (mode, language, project info)
  - Troubleshooting section
  - What You Get overview

### Infrastructure
- Cleaned up duplicate lines in pre-push hook


## [1.4.0] - 2026-02-26

### Added
- **Version Management Enforcement**:
  - Pre-push git hook automatically checks if VERSION has been updated
  - Push to main branch is blocked if version hasn't changed since last tag
  - install-hooks.sh script to install version check hook
  - Clear error messages with instructions when version check fails

### Changed
- **AGENTS.md Updates**:
  - Added strict semantic versioning rules (MAJOR.MINOR.PATCH)
  - Defined clear criteria for breaking changes
  - Added "When in doubt: Choose MINOR over MAJOR" guideline
  - Updated version management workflow with hook enforcement
- **init-project.sh Enhancement**:
  - Added interactive Git hooks installation step
  - Prompts user to install version check hook for their project

### Documentation
- **Semantic Versioning Clarification**:
  - Explicit PATCH examples (bug fixes, docs, comments)
  - Explicit MINOR examples (new features, backward compatible)
  - Explicit MAJOR criteria (ONLY user-impacting breaking changes)
  - Common misconceptions listed (NOT breaking changes)
- **Version Management Protocol**:
  - Mandatory version bump before every push to main
  - Why: Direct main workflow means every commit is "released"
  - Enforcement: Pre-push hook verification

### Infrastructure
- **.template/hooks/pre-push**: Git hook for version enforcement
- **.template/scripts/install-hooks.sh**: Hook installation script
- Removed empty root directories: `docs/` and `scripts/` (scaffolding mode)


## [1.3.0] - 2026-02-26

### Added
- **Complete Scaffolding Template Isolation**:
  - All scaffolding infrastructure moved to `.template/` directory
  - Clear separation between scaffolding and project files
  - Mode system: `scaffolding` (developing template) vs `project` (using template)
- **Working Mode Configuration**:
  - `config.toml` mode setting determines file organization
  - Template mode: ADRs, scripts, assets in `.template/`
  - Project mode: ADRs, scripts, assets in root directories
- **AI Agent i18n Integration**:
  - AI Agent Communication Protocol in AGENTS.md
  - Session start checklist for language configuration
  - Automatic translation loading from `.template/i18n/locales/`
  - Communication language adapts to user's `primary_locale`
- **Project Policy Files Management**:
  - Dual-location strategy for LICENSE, CONTRIBUTING.md, SECURITY.md
  - Root files for current context (scaffolding or project)
  - `.template/` copies as permanent reference
  - Comprehensive project guides for creating policies
- **Project Setup Guides**:
  - PROJECT_LICENSE_GUIDE.md - License selection and creation
  - PROJECT_CONTRIBUTING_GUIDE.md - Contribution policy writing
  - PROJECT_SECURITY_GUIDE.md - Security policy creation

### Changed
- **File Organization**:
  - Moved ADRs: `docs/adr/` → `.template/docs/adr/`
  - Moved scripts: `scripts/` → `.template/scripts/`
  - Moved assets: `assets/` → `.template/assets/`
  - TEMPLATE_SYNC.md → `.template/docs/TEMPLATE_SYNC.md`
- **Terminology Consistency**:
  - Unified use of "scaffolding" (鷹架) throughout
  - Mode values: `scaffolding` and `project` (not `template` or `framework`)
- **Enhanced init-project.sh**:
  - Interactive LICENSE creation (MIT or custom)
  - CONTRIBUTING.md generation (accepting PRs or not)
  - Optional SECURITY.md creation with contact info
  - Project VERSION initialization to 0.1.0

### Documentation
- **AGENTS.md Updates**:
  - Added Working Mode section explaining scaffolding vs project mode
  - Added AI Agent Communication Protocol (mandatory for all agents)
  - Updated file organization rules based on mode
- **README Updates**:
  - Updated all asset paths to `.template/assets/`
  - VERSION badge points to `.template/VERSION`
  - Clear documentation of dual-mode system
- **Path References**:
  - All documentation updated to reference `.template/` paths
  - CHANGELOG.md reflects new file structure

### Architecture
- **ADR 0006**: Template Directory Isolation
  - Documents the rationale for `.template/` structure
  - Explains scaffolding vs project file separation
  - Outlines migration strategy and benefits


## [1.2.0] - 2026-02-26

### Added
- **Multi-language Support**: Comprehensive language-specific configuration modules
  - `languages/go/` - Go development module (golangci-lint, Makefile, go.mod example)
  - `languages/python/` - Python development module (pyproject.toml, .python-version)
  - `languages/typescript/` - TypeScript development module (tsconfig, ESLint, package.json)
  - `languages/rust/` - Rust development module (Cargo.toml, rust-toolchain.toml)
- **Enhanced Core Configs**:
  - `.gitignore` - Added patterns for Go, Python, TypeScript, Rust
  - `.editorconfig` - Added language-specific formatting rules

### Documentation
- Each language module includes comprehensive README with:
  - Quick start guide
  - Configuration explanations
  - Best practices
  - Common workflows
  - Troubleshooting tips
- **README.md**: Added "Language Support" section explaining out-of-box and deep module support

### Philosophy
- Hybrid approach: basic support out-of-box, opt-in deep configurations
- Language modules in `languages/` directory (not `templates/` to avoid confusion)
- Each module is self-contained and optional

## [1.1.0] - 2026-02-25

### Added
- **LICENSE**: MIT License for open source distribution
- **CONTRIBUTING.md**: Contribution guidelines (no PRs accepted, issues welcome)
- **SECURITY.md**: Security policy and vulnerability reporting guidelines
- **ADR Examples**: Three comprehensive Architecture Decision Record templates:
  - `.template/docs/adr/0002-example-tech-stack-selection.md` - Technology stack selection example
  - `.template/docs/adr/0003-example-api-design-principles.md` - API design principles example
  - `.template/docs/adr/0004-example-testing-strategy.md` - Testing strategy example
- **Visual Branding**: Logo and illustration assets
  - `.template/assets/images/20260225_vibe-scaffolding-logo.png` - Primary logo
  - `.template/assets/images/20260225_vibe-scaffolding-illustration-american.png` - American style illustration
  - `.template/assets/images/20260225_vibe-scaffolding-illustration-japanese.png` - Japanese style illustration

### Changed
- **CHANGELOG.md**: Converted to English for international accessibility
- **README.md**: Added Vygotsky's scaffolding theory explanation and visual branding
- **PR Template**: Simplified to Angular style with bilingual (EN/ZH) format

### Documentation
- Enhanced README with concept explanation inspired by Vygotsky's scaffolding theory
- Added comprehensive ADR examples covering different decision types
- Clarified contribution policy (clone/fork encouraged, PRs not accepted)


## [1.0.0] - 2026-02-25

### Added
- Initial release of vibe coding template
- Core configuration files:
  - `AGENTS.md` - OpenCode AI agent instructions
  - `README.md` - Project documentation
  - `.gitignore` - Git ignore rules
  - `.editorconfig` - Editor configuration
  - `.env.example` - Environment variables example
  - `opencode.json` - OpenCode project configuration
- GitHub Templates:
  - `.github/ISSUE_TEMPLATE/bug_report.md` - Bug report template
  - `.github/ISSUE_TEMPLATE/feature_request.md` - Feature request template
  - `.github/pull_request_template.md` - Pull request template (Angular style)
  - `.github/workflows/ci-placeholder.yml` - CI workflow placeholder
- Documentation:
  - `.template/docs/adr/0001-record-architecture-decisions.md` - First ADR example
- Version management:
  - `.template/VERSION` - Scaffolding version number file
  - `CHANGELOG.md` - Version changelog
  - `.template/docs/TEMPLATE_SYNC.md` - Template synchronization guide
  - `.template/scripts/bump-version.sh` - Version management script

### Coding Conventions
- Test-driven development (TDD) approach
- All functions require docstrings and type annotations
- Avoid over-engineering
- Commit messages in Traditional Chinese

### Version Management
- Semantic Versioning 2.0.0
- Git tags for version marking
- Template sync mechanism for updating existing projects

---

## Version Rules

Following [Semantic Versioning 2.0.0](https://semver.org/):

- **MAJOR version** (X.0.0): Incompatible API changes, major architectural adjustments
- **MINOR version** (0.X.0): Backward-compatible new features
- **PATCH version** (0.0.X): Backward-compatible bug fixes, documentation updates

### Examples

- `1.0.0` → `1.0.1`: Fix documentation typos, update .gitignore
- `1.0.0` → `1.1.0`: Add Docker support, add testing framework configuration
- `1.0.0` → `2.0.0`: Change project structure, remove certain files

[Unreleased]: https://github.com/matheme-justyn/my-vibe-scaffolding/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/matheme-justyn/my-vibe-scaffolding/compare/v1.1.0...v1.2.0
[1.0.0]: https://github.com/matheme-justyn/my-vibe-scaffolding/releases/tag/v1.0.0
