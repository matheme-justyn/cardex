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

使用繁體中文撰寫 commit message，格式為：

```
type: 描述
```

**允許的 type：**
- `feat`: 新功能
- `fix`: 修復 bug
- `docs`: 文件更新
- `refactor`: 重構（不改變功能的程式碼改進）
- `test`: 測試相關
- `chore`: 其他維護性工作

**範例：**
```
feat: 新增使用者登入功能
fix: 修正資料庫連線錯誤
docs: 更新 API 文件
```

## File Structure

<!-- TODO: Document the project's directory structure and organization -->

## What NOT to do

- ❌ **不要自作主張改架構**：任何架構變更都必須先討論
- ❌ **不要在沒被要求的情況下重構既有程式碼**：專注在當前任務
- ❌ **不要安裝沒討論過的 dependency**：新增套件前必須先討論必要性和替代方案
