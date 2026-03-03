# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.2] - 2026-03-03

### Added
- **Interactive Tutorial Tab**: Split main content into Library and Tutorial tabs
  - Comprehensive tutorial covering Quick Start, Features, Quick Buttons, and Tips
  - Full i18n support (Traditional Chinese and English)
  - AI-friendly prompts for configuration - users can copy/paste to AI assistants
  - Step-by-step organization suggestions for PDF libraries
- **Library Path Management Improvements**:
  - App now prioritizes `library.default_path` over `library.root_path` on startup
  - Quick selection buttons: Default (⭐), Desktop (🖥️), Documents (📝), Downloads (📥)
  - Desktop button with cross-platform support (macOS/Windows/Linux)
  - Relative path display in PDF table for better UX
- **AI-Assisted Configuration**:
  - Copy-paste prompts for setting default library path
  - Copy-paste prompts for organizing PDF folder structure
  - No manual YAML editing required
- **Comprehensive Testing**:
  - 11 automated tests for path resolution, cross-platform support, and error handling
  - Test reports in `.worklog/2026-03-03-test-report.md`
  - Manual test checklist for UI validation

### Changed
- Replaced "主目錄" (Home) with "桌面" (Desktop) in quick selection buttons
- Tutorial tips now provide AI prompts instead of manual editing instructions
- Improved button layout with emoji-only labels and tooltips

### Fixed

### Fixed
- Fixed Light theme switching bug in Streamlit UI - replaced JavaScript injection with pure CSS approach
- Theme switching now properly applies for Light, Dark, and Follow System modes

### Added
- Complete containerization support with Podman/Docker
  - Multi-stage Containerfile with uv for fast dependency installation
  - docker-compose.yml for easy deployment
  - podman.sh helper script with build, run, logs, shell, status commands
  - Volume mounts for PDF library and config directory
  - Health checks and automatic restart
- Container documentation in docs/phase-0-quickstart.md

### Changed
- Theme implementation now uses CSS media queries instead of JavaScript
- Improved CSS variable structure for better theme consistency

## [0.1.1] - 2026-03-03

### Changed
- Restructured README to be product-focused (moved technical details to docs/)
- Added "Recommended Workflow" section with three usage options
- Added "Development Status" section for better project visibility
- Simplified documentation structure per my-vibe-scaffolding guidelines

### Documentation
- All SQL schemas and file layouts now in `docs/data-model.md`
- README reduced from 472 to 221 lines
- Updated Chinese README (README.zh-TW.md) to match new structure

## [0.1.0] - 2026-03-03

## [1.0.0] - YYYY-MM-DD

### Added
- Initial project setup using my-vibe-scaffolding template

---

**📌 注意 | Note**:
- 這是**專案層級**的 CHANGELOG（紀錄你專案的變更）
- 模板自身的變更歷史請查看：[.template/CHANGELOG.md](./.template/CHANGELOG.md)

- This is the **project-level** CHANGELOG (tracks YOUR project changes)
- For template's own change history, see: [.template/CHANGELOG.md](./.template/CHANGELOG.md)
