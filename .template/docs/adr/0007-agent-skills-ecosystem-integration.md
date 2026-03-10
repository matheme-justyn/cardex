# 7. Agent Skills 生態系整合決策

Date: 2026-03-10

## Status

Accepted

## Context

### 問題背景

my-vibe-scaffolding 作為 AI agent 工作流程鷹架模板，目前已有基礎的 `AGENTS.md` 支援，但缺乏完整的 skills 生態系整合。使用者需要：

1. **跨工具相容性**：支援 Claude Code, Cursor, Gemini CLI, RooCode, OpenCode 等多種 agent 工具
2. **可重複使用的工作流程**：將最佳實踐編碼成可執行的 skills
3. **降低認知負擔**：透過 bundles 和 workflows 簡化從大量 skills 中選擇的過程
4. **多語言支援**：繁體中文和英文文件同步

### 生態系調查

我們評估了 7 個主要資源：

1. **agents.md 標準**（60k+ 專案採用）
2. **heilcheng/awesome-agent-skills**（社群策展清單）
3. **anthropics/skills**（Official Anthropic）
4. **RooCode Skills Documentation**（工具文件）
5. **sickn33/antigravity-awesome-skills**（1,234+ skills 大集合）
6. **huggingface/skills**（ML/AI 專用）
7. **Claude Code 官方文件**（繁體中文）

詳細分析見：`.template/docs/RESOURCE_ANALYSIS_AGENT_SKILLS_ECOSYSTEM.md`

### 關鍵發現

**正面發現**：
- AGENTS.md 標準成熟穩定，60k 專案驗證
- SKILL.md frontmatter 格式已有共識（Anthropic, HuggingFace, RooCode 一致）
- `.agents/` 跨工具路徑設計可共享配置
- Bundle 和 Workflow 概念有效降低選擇負擔

**風險發現**：
- 大量社群 skills（如 antigravity 的 1,234 個）品質參差不齊
- 授權混雜（Apache 2.0, Custom, Source-available）
- 維護成本隨 skills 數量指數增長
- 工具特定功能（如 Claude plugin marketplace）違反跨工具通用性

## Decision

### 核心決策

我們決定**選擇性整合** agent skills 生態系，採用「策展優於數量」原則：

#### ✅ 立即整合（Phase 1: v1.3.0 → v1.3.1）

1. **AGENTS.md 標準支援**
   - 在文件中明確標註 agents.md 標準來源
   - 強化 AGENTS.md 說明 skill system 章節
   - 提供跨工具相容的使用指引

2. **SKILL.md 格式標準**
   - 採納 YAML frontmatter + Markdown 格式
   - 定義 `name` 和 `description` 為必填欄位
   - 支援 `scripts/`, `templates/`, `resources/` 目錄結構

3. **跨工具路徑支援**
   - `.agents/skills/` — 跨工具共享（Global: `~/.agents/skills/`, Project: `.agents/skills/`）
   - `.claude/skills/` — Claude Code 專用
   - `.roo/skills/` — RooCode 專用

4. **Bundle 和 Workflow 系統**
   - 建立 `data/bundles.yaml` — Role-based skill collections
   - 建立 `data/workflows.yaml` — Step-by-step execution playbooks
   - 初始提供 3 個 bundles（Essentials, Frontend, Backend）
   - 初始提供 2 個 workflows（Ship SaaS MVP, Security Audit）

5. **繁體中文支援**
   - 更新 `i18n/locales/zh-TW/agents.toml` 加入 skills, bundles, workflows 翻譯

#### 🔶 選擇性整合（Phase 2: v1.4.0）

1. **Skill 範例庫**
   - 策展 10-20 個高品質 skills（非 1,234 個）
   - 每個 skill 需有完整文件和測試範例
   - 只納入 official repositories（anthropics, huggingface）

2. **Plugin Manifests**
   - 建立 `.claude-plugin/plugin.json`
   - 建立 `gemini-extension.json`
   - 支援 Claude Code 和 Gemini CLI 的 plugin 發現機制

3. **驗證工具**
   - `.template/scripts/validate-agents-md.sh` — AGENTS.md linter
   - CI workflow 自動驗證 skill 格式

#### ❌ 明確拒絕整合

1. **Antigravity 完整 1,234 skills 集**
   - 理由：規模失控、品質風險、維護成本不可行

2. **大量社群 skills 匯入**
   - 理由：授權混雜、品質參差不齊、無法驗證

3. **工具特定複雜功能**
   - 如 RooCode 的 8 層 override priority
   - 理由：違反跨工具通用性，增加認知負擔

### 檔案結構變更

```
.template/
├── docs/
│   ├── AGENTS_MD_GUIDE.md              # [NEW] agents.md 標準說明
│   ├── SKILL_FORMAT_GUIDE.md           # [NEW] SKILL.md 格式指南
│   ├── RESOURCE_ANALYSIS_*.md          # [NEW] 資源分析報告
│   └── examples/
│       ├── skills/                     # [NEW] Skill 範例目錄
│       │   ├── template-skill/         # 範本結構
│       │   │   ├── SKILL.md
│       │   │   ├── scripts/
│       │   │   ├── templates/
│       │   │   └── resources/
│       │   └── README.md
│       └── agents/                     # [NEW] AGENTS.md 範例
│           ├── minimal.md
│           ├── full-featured.md
│           └── role-specific/
│               ├── frontend-developer.md
│               ├── backend-engineer.md
│               └── devops-specialist.md
├── i18n/
│   └── locales/
│       └── zh-TW/
│           └── agents.toml              # [UPDATE] 新增 skills, workflows 翻譯
└── scripts/
    ├── consolidate-agent-configs.sh    # [NEW] 整併既有 agent 配置
    └── validate-agents-md.sh           # [NEW Phase 2] AGENTS.md linter

data/
├── bundles.yaml                        # [NEW] Role-based skill collections
└── workflows.yaml                      # [NEW] Step-by-step playbooks

AGENTS.md                               # [UPDATE] 新增 Skill System 章節

.agents/                                # [NEW] 跨工具配置目錄
└── skills/                             # 專案層級共享 skills
```

### AGENTS.md 更新內容

在 AGENTS.md 新增以下章節：

```markdown
## Skill System

本專案支援 Agent Skills 標準，讓 AI coding assistants 載入專用的任務指令。

### Skill 格式

Skills 使用 `SKILL.md` 檔案格式，包含 YAML frontmatter 和 Markdown 指令。

### Skill 安裝位置

**全域 skills (所有專案可用)**:
- `~/.agents/skills/` — Cross-agent, shared with Codex, RooCode, etc.
- `~/.claude/skills/` — Claude Code specific
- `~/.roo/skills/` — RooCode specific

**專案 skills (當前專案)**:
- `.agents/skills/` — Cross-agent, team-shared
- `.claude/skills/` — Claude Code specific

### 使用 Skills

在提示中使用 `@skill-name` 引用 skill。

### 延伸閱讀

- [AGENTS.md Standard](https://agents.md/)
- [Agent Skills Specification](https://agentskills.io/)
- [Skill Management Guide](./docs/users/skill-management.md)
```

## Consequences

### 正面影響

1. **跨工具相容性提升**
   - 支援 6+ agent 工具（Claude Code, Cursor, Gemini CLI, RooCode, OpenCode, Codex）
   - `.agents/` 路徑設計讓團隊成員使用不同工具時仍可共享配置

2. **降低使用者認知負擔**
   - Bundle 系統提供 role-based 的 skill 推薦
   - Workflow 系統提供 step-by-step 的任務指引
   - 不需從 1,234 個 skills 中盲目選擇

3. **品質可控**
   - 策展 10-20 個高品質 skills 勝過 1,234 個未驗證的
   - 每個 skill 都有文件、範例、測試
   - 授權清晰（只納入 Apache 2.0 或相容授權）

4. **維護成本可控**
   - 少量 skills 讓維護負擔可管理
   - 外部資源採「連結參考」而非「直接整合」
   - 季度審查週期追蹤上游變更

5. **多語言支援**
   - 繁體中文和英文文件同步
   - i18n 系統整合 skills 術語

6. **符合 Scaffolding 定位**
   - 提供範例和指引，不強制特定實作
   - 使用者可自由擴充或移除
   - 保持簡單和通用

### 負面影響與緩解

1. **功能覆蓋不完整**
   - 風險：10-20 個 skills 無法涵蓋所有使用情境
   - 緩解：在文件中提供外部資源連結（如 antigravity, awesome-agent-skills）

2. **持續維護需求**
   - 風險：上游標準變更需要追蹤更新
   - 緩解：建立 `.template/docs/EXTERNAL_RESOURCES.md` 追蹤上游，季度審查

3. **學習曲線**
   - 風險：Skills, Bundles, Workflows 概念增加複雜度
   - 緩解：提供清晰的 Getting Started 和 Visual Guide

4. **翻譯維護**
   - 風險：新增內容增加翻譯負擔
   - 緩解：Phase 1 就同步建立翻譯，考慮使用 AI 翻譯工具

### Trade-offs

我們選擇：

- **品質 > 數量**：10-20 個驗證的 skills > 1,234 個未知品質
- **通用性 > 工具特定**：跨工具標準 > 單一工具的複雜功能
- **策展 > 自動化**：人工策展 > 大量匯入社群內容
- **文件 > 實作**：說明機制 > 實作所有功能

## Implementation Plan

### Phase 1: 基礎整合（v1.3.0 → v1.3.1）— 立即執行

**時程**：1-2 days

**工作項目**：
1. ✅ 建立 ADR 0007（本文件）
2. ☐ 建立 `.template/docs/AGENTS_MD_GUIDE.md`
3. ☐ 建立 `.template/docs/SKILL_FORMAT_GUIDE.md`
4. ☐ 建立 `.template/docs/examples/skills/template-skill/`
5. ☐ 更新 `AGENTS.md` 加入 Skill System 章節
6. ☐ 更新 `i18n/locales/zh-TW/agents.toml` 加入翻譯
7. ☐ 建立 `data/bundles.yaml`
8. ☐ 建立 `data/workflows.yaml`
9. ☐ 建立 `.template/scripts/consolidate-agent-configs.sh`
10. ☐ 更新 README.md 支援「安裝或更新」

**驗收標準**：
- AGENTS.md 包含完整的 skill system 說明
- 提供至少 1 個完整的 skill 範例
- 繁體中文翻譯完整
- 安裝腳本支援更新模式並整併既有配置

### Phase 2: 範例擴充（v1.4.0）— 2 weeks

**工作項目**：
1. 策展 10 個高品質 skills
2. 建立 role-specific AGENTS.md 範例
3. 設計 3 個 workflows

### Phase 3: 工具支援（v1.5.0）— 1 month

**工作項目**：
1. 開發 validate-agents-md.sh linter
2. 建立 plugin manifests
3. 設定 CI validation

## References

- `.template/docs/RESOURCE_ANALYSIS_AGENT_SKILLS_ECOSYSTEM.md` — 完整的 7 資源分析報告
- [agents.md](https://agents.md/) — Open standard for agent instructions
- [Agent Skills Specification](https://agentskills.io/) — SKILL.md format standard
- [anthropics/skills](https://github.com/anthropics/skills) — Official Anthropic skills
- [ADR 0001](./.template/docs/adr/0001-record-architecture-decisions.md) — ADR 格式規範
- [ADR 0006](./.template/docs/adr/0006-template-directory-isolation.md) — Template 目錄隔離

## Version Impact

此決策影響的版本：

- **Template Version**: 1.3.0 → 1.3.1 (Phase 1), → 1.4.0 (Phase 2), → 1.5.0 (Phase 3)
- **Breaking Changes**: None（向後相容）
- **Deprecations**: None

## Related ADRs

- Supersedes: None
- Superseded by: None
- Related to:
  - ADR 0001: Record architecture decisions
  - ADR 0006: Template directory isolation
