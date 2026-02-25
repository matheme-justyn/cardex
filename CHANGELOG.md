# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-02-25

### Added
- 初始版本發布
- 建立專案模板骨架，包含以下檔案：
  - `AGENTS.md` - OpenCode AI agent 指令文件
  - `README.md` - 專案說明文件
  - `.gitignore` - Git 忽略規則
  - `.editorconfig` - 編輯器統一設定
  - `.env.example` - 環境變數範例
  - `opencode.json` - OpenCode 專案設定
- GitHub Templates：
  - `.github/ISSUE_TEMPLATE/bug_report.md` - Bug 回報模板
  - `.github/ISSUE_TEMPLATE/feature_request.md` - 功能請求模板
  - `.github/pull_request_template.md` - Pull Request 模板
  - `.github/workflows/ci-placeholder.yml` - CI workflow 佔位檔案
- 文件：
  - `docs/adr/0001-record-architecture-decisions.md` - ADR 首個範例
- 版本管理：
  - `VERSION` - 版本號檔案
  - `CHANGELOG.md` - 版本變更記錄
  - `TEMPLATE_SYNC.md` - 模板同步指南

### 編碼規範
- 永遠先寫測試（TDD）
- 所有函數要有 docstring 和型別標注
- 避免過度工程化
- Commit message 使用繁體中文

### 版本管理
- 採用語意化版本（Semantic Versioning 2.0.0）
- 使用 Git tags 標記版本
- 提供模板同步機制，讓舊專案可以引入新版本的變更

---

## 版本號規則

遵循 [語意化版本 2.0.0](https://semver.org/lang/zh-TW/)：

- **MAJOR 版本**（X.0.0）：不相容的 API 變更、重大架構調整
- **MINOR 版本**（0.X.0）：向下相容的新增功能
- **PATCH 版本**（0.0.X）：向下相容的問題修正、文件更新

### 範例

- `1.0.0` → `1.0.1`：修正文件錯字、更新 .gitignore
- `1.0.0` → `1.1.0`：新增 Docker 支援、新增測試框架設定
- `1.0.0` → `2.0.0`：改變專案結構、移除某些檔案

[Unreleased]: https://github.com/matheme-justyn/my-vibe-scaffolding/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/matheme-justyn/my-vibe-scaffolding/releases/tag/v1.0.0
