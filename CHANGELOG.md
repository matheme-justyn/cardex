# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
  - `docs/adr/0002-example-tech-stack-selection.md` - Technology stack selection example
  - `docs/adr/0003-example-api-design-principles.md` - API design principles example
  - `docs/adr/0004-example-testing-strategy.md` - Testing strategy example
- **Visual Branding**: Logo and illustration assets
  - `assets/images/20260225_vibe-scaffolding-logo.png` - Primary logo
  - `assets/images/20260225_vibe-scaffolding-illustration-american.png` - American style illustration
  - `assets/images/20260225_vibe-scaffolding-illustration-japanese.png` - Japanese style illustration

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
  - `docs/adr/0001-record-architecture-decisions.md` - First ADR example
- Version management:
  - `VERSION` - Version number file
  - `CHANGELOG.md` - Version changelog
  - `TEMPLATE_SYNC.md` - Template synchronization guide
  - `scripts/bump-version.sh` - Version management script

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
