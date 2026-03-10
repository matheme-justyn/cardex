# Resource Analysis: Agent Skills Ecosystem Integration Assessment

**Date**: 2026-03-10  
**Version**: 1.0.0  
**Status**: Complete  
**Template Mode**: Scaffolding

---

## Executive Summary

本文件分析 7 個 agent skills 生態系資源，評估對 `my-vibe-scaffolding` 專案的整合價值。此鷹架專案為 OpenCode workflows 提供多語言、opinionated 的架構，目標是透過技能系統、代理委派模式和文件標準來增強 AI 編碼助手。

**核心發現**:
- **AGENTS.md 標準**: 已被 60k+ 專案採用的開放格式，與現有 scaffolding 的 AGENTS.md 完美對齊
- **Skill 架構模式**: Anthropic, HuggingFace, RooCode 展示了 production-grade skill 系統實作
- **社群資源**: antigravity-awesome-skills 提供 1,234+ 技能但需要嚴格的品質過濾
- **工具特定實作**: 每個工具 (Claude Code, Cursor, Gemini CLI) 有各自的 skill 發現和載入機制

---

## 分析方法論

### 評估標準

每個資源依據以下標準評估：

1. **架構一致性**: 與 scaffolding template 架構的相容性
2. **實作成熟度**: Production readiness 和採用率
3. **維護負擔**: 導入後的持續維護成本
4. **使用者影響**: 對 scaffolding 使用者的價值提升
5. **文件品質**: 清晰度和完整性

### 影響範圍

整合決策影響以下 scaffolding 元件：

- `.template/docs/` — 文件結構和範例
- `.template/i18n/` — 多語言翻譯檔案
- `AGENTS.md` — AI agent 指令檔案
- `README.md` — 專案說明和 Getting Started
- `docs/adr/` — Architecture Decision Records

---

## 資源 1: agents.md 標準

### 來源
- **URL**: https://agents.md/
- **性質**: Open standard by OpenAI, Anthropic, Google, Amp, Factory
- **採用率**: 60,000+ open-source projects

### 核心特性

**AGENTS.md 檔案格式**:
```markdown
# AGENTS.md

## Setup commands
- Install deps: `pnpm install`
- Start dev server: `pnpm dev`
- Run tests: `pnpm test`

## Code style
- TypeScript strict mode
- Single quotes, no semicolons
- Use functional patterns where possible
```

**關鍵特點**:
1. **Markdown 格式**: 無需結構化 frontmatter，純 Markdown
2. **跨工具相容**: Claude Code, Codex, Gemini CLI, Cursor, GitHub Copilot 皆支援
3. **專案優先**: 補充 README.md，focus on agent-specific instructions
4. **階層支援**: 支援 monorepo 中的巢狀 AGENTS.md

**支援工具清單**:
- Claude (claude.ai, Claude Code)
- Codex (OpenAI)
- Gemini CLI (Google)
- Jules (Google)
- GitHub Copilot
- Cursor
- RooCode
- VS Code
- Windsurf
- Factory
- Aider
- Goose
- OpenCode
- Zed
- Warp
- Devin
- Autopilot (UiPath)

### 整合評估

#### ✅ 優勢

1. **無縫整合**: scaffolding 已有 `AGENTS.md`，完全符合標準
2. **零破壞性**: 不改變現有架構，純增強
3. **社群驗證**: 60k 專案採用證明穩定性
4. **多語言友善**: Markdown 格式易於 i18n 處理

#### ⚠️ 限制

1. **自由格式**: 無 schema 驗證，需人工維護一致性
2. **無工具註冊**: 不支援 tool registration（需配合 MCP）
3. **發現機制**: 依賴檔案系統掃描，無 metadata index

#### 🎯 決策點

| 功能 | 整合建議 | 影響範圍 |
|------|---------|---------|
| **標準採用** | ✅ 立即整合 | AGENTS.md 已存在，加強文件說明標準來源 |
| **範例擴充** | ✅ 高優先 | 在 `.template/docs/` 提供不同角色的 AGENTS.md 範例 |
| **驗證工具** | 🔶 中優先 | 開發 linter 檢查 AGENTS.md 格式一致性 |
| **i18n 支援** | ✅ 立即整合 | 為 agents.toml 新增翻譯 key（已支援） |

### 實作建議

**Phase 1: 文件強化** (立即)
```bash
# 新增檔案
.template/docs/AGENTS_MD_GUIDE.md          # agents.md 標準說明
.template/docs/examples/AGENTS.md.minimal  # 最小範例
.template/docs/examples/AGENTS.md.full     # 完整範例
```

**Phase 2: 範例多樣化** (v1.4.0)
```bash
# 依角色提供範例
.template/docs/examples/agents/
├── frontend-developer.md
├── backend-engineer.md
├── devops-specialist.md
└── ml-researcher.md
```

**Phase 3: 驗證工具** (v1.5.0)
```bash
# 新增 linter
.template/scripts/validate-agents-md.sh
```

**不建議整合**:
- ❌ 棄用現有 AGENTS.md 改用其他格式
- ❌ 強制結構化 frontmatter（違反標準精神）

---

## 資源 2: heilcheng/awesome-agent-skills

### 來源
- **URL**: https://github.com/heilcheng/awesome-agent-skills
- **性質**: Community-curated skill catalog (Chinese language focus)
- **範圍**: 綜合清單包含 official 和 community skills

### 核心特性

**Skill 分類架構**:
1. **Official Claude Skills**: docx, xlsx, pptx, pdf 處理
2. **Official OpenAI Codex Skills**: Repo/User/Admin scope 系統
3. **Official HuggingFace Skills**: dataset creator, model evaluation, trainer
4. **Community Collections**: 
   - skillcreatorai/Ai-Agent-Skills
   - agentskill.sh (44k+ skills)
   - karanb192/awesome-claude-skills (50+)

**Skill 類型**:
- Document Processing
- Development & Code Tools
- Data & Analysis
- Integration & Automation
- Collaboration & Project Management
- Security & Systems
- Advanced & Research

**關鍵洞察**:
1. **Skills vs MCP**: 文件清楚區分「instructions」(skills) 和「executable tools」(MCP)
2. **Format 標準化**: 主要使用 `SKILL.md` frontmatter 格式
3. **跨工具相容**: 涵蓋 Claude, Codex, Antigravity, Copilot, VS Code

### 整合評估

#### ✅ 優勢

1. **品質策展**: 已過濾和驗證的技能清單
2. **多工具視角**: 涵蓋多個 agent 工具的實作差異
3. **實作範例**: 提供實際可用的 skill 結構

#### ⚠️ 限制

1. **語言障礙**: 主要為英文和中文，繁體中文範例有限
2. **品質不均**: Community skills 品質參差不齊
3. **維護負擔**: 需持續追蹤外部更新

#### 🎯 決策點

| 功能 | 整合建議 | 影響範圍 |
|------|---------|---------|
| **Skill 目錄** | 🔶 選擇性參考 | 在文件中引用作為外部資源，不直接整合 |
| **格式範例** | ✅ 採納 | 使用 SKILL.md frontmatter 作為標準格式 |
| **分類系統** | ✅ 適應性採納 | 參考其分類架構設計 scaffolding 的 skill 範例 |
| **社群技能** | ❌ 不整合 | 品質風險高，維護成本不可控 |

### 實作建議

**可採納元素**:
1. **格式標準**: SKILL.md with YAML frontmatter
   ```markdown
   ---
   name: skill-name
   description: Clear description of what this skill does
   ---
   
   # Skill Instructions
   [Detailed guidance]
   ```

2. **分類參考**: 用於設計 `.template/docs/examples/skills/` 結構

**不建議整合**:
- ❌ 大量匯入社群 skills（品質風險）
- ❌ 依賴外部 skill repositories（維護負擔）

---

## 資源 3: anthropics/skills (Official)

### 來源
- **URL**: https://github.com/anthropics/skills
- **性質**: Official Anthropic skills repository
- **授權**: Apache 2.0 (open source) + Source-available (document skills)

### 核心特性

**Skill 結構**:
```
skill-name/
├── SKILL.md          # Required: Instructions and metadata
├── scripts/          # Optional: Helper scripts
├── templates/        # Optional: Document templates
└── resources/        # Optional: Reference files
```

**Frontmatter 規範**:
```yaml
---
name: my-skill-name
description: A clear description of what this skill does and when to use it
---
```

**Production Skills**:
- **docx**: Word document creation/editing with tracked changes
- **xlsx**: Spreadsheet manipulation with formulas and charts
- **pptx**: PowerPoint slide generation and adjustment
- **pdf**: PDF text/table extraction

**Creative & Technical Skills**:
- art, music, design
- testing web apps
- MCP server generation
- enterprise workflows

**Claude Code Plugin System**:
- `.claude-plugin/marketplace.json` — Human-readable skill descriptions
- Plugin marketplace integration
- Installation commands: `/plugin marketplace add`, `/plugin install`

### 整合評估

#### ✅ 優勢

1. **Official Standard**: Anthropic 官方維護，格式穩定
2. **Production-grade**: 實際用於 Claude.ai 的技能
3. **Complete Examples**: 包含複雜的 helper scripts 和 templates
4. **Clear Separation**: SKILL.md (agent guide) vs marketplace.json (human guide)

#### ⚠️ 限制

1. **Anthropic-specific**: Claude Code plugin 系統非通用標準
2. **文件技能閉源**: docx/pdf/pptx/xlsx 為 source-available，非 Apache 2.0

#### 🎯 決策點

| 功能 | 整合建議 | 影響範圍 |
|------|---------|---------|
| **SKILL.md 格式** | ✅ 完全採納 | 作為 scaffolding 的標準格式 |
| **Plugin marketplace** | ❌ 不整合 | Anthropic-specific，非跨工具標準 |
| **Skill 範例** | ✅ 參考設計 | 學習其 scripts/ 和 templates/ 結構 |
| **文件技能** | 📚 文件參考 | 在文件中引用但不複製（授權限制） |

### 實作建議

**採納的標準格式**:
```markdown
---
name: skill-name
description: Complete description for agent activation
---

# Skill Title

## When to Use This Skill
- Use case 1
- Use case 2

## Instructions
[Detailed guidance]

## Examples
[Real-world examples]
```

**Skill 結構範本**:
```
.template/docs/examples/skills/template-skill/
├── SKILL.md
├── scripts/
│   └── helper.sh
├── templates/
│   └── output-template.md
└── resources/
    └── reference.txt
```

**不建議整合**:
- ❌ Claude Code plugin 系統（工具特定）
- ❌ 複製文件技能實作（授權 + 維護成本）

---

## 資源 4: RooCode Skills Documentation

### 來源
- **URL**: https://docs.roocode.com/features/skills
- **性質**: RooCode (Cline fork) official documentation
- **工具**: VS Code extension with 574k installs

### 核心特性

**Progressive Disclosure 架構**:
1. **Level 1: Discovery** — 只讀取 frontmatter (name, description)
2. **Level 2: Instructions** — 需要時才 read_file 載入完整 SKILL.md
3. **Level 3: Resources** — On-demand 存取 bundled files

**目錄結構**:
```
~/.roo/skills/                    # Global Roo-specific (high priority)
~/.agents/skills/                 # Global cross-agent (shared)
.roo/skills/                      # Project Roo-specific
.agents/skills/                   # Project cross-agent
~/.roo/skills-code/              # Mode-specific (Code mode only)
.roo/skills-architect/           # Project mode-specific
```

**Override Priority** (highest → lowest):
1. Project `.roo` mode-specific
2. Project `.roo` generic
3. Project `.agents` mode-specific
4. Project `.agents` generic
5. Global `.roo` mode-specific
6. Global `.roo` generic
7. Global `.agents` mode-specific
8. Global `.agents` generic

**關鍵創新**:
- **Mode Targeting**: skills-{mode}/ 目錄讓技能只在特定 mode 啟用
- **Cross-agent Path**: `.agents/` 路徑與其他 agent 工具共享
- **Symlink Support**: 支援 symbolic links 共享 skill libraries

### 整合評估

#### ✅ 優勢

1. **漸進式載入**: 效能優化，只載入需要的內容
2. **模式系統**: mode-specific skills 避免 context 污染
3. **跨工具標準**: `.agents/` 路徑設計可跨工具共享
4. **清晰的優先級**: 明確的 override 規則

#### ⚠️ 限制

1. **RooCode-specific**: Mode 系統為 RooCode 特有功能
2. **複雜性**: 8 層優先級對使用者認知負擔高

#### 🎯 決策點

| 功能 | 整合建議 | 影響範圍 |
|------|---------|---------|
| **`.agents/` 路徑** | ✅ 採納 | 在 scaffolding 中支援 `.agents/skills/` 作為跨工具標準 |
| **Progressive loading** | 📚 文件說明 | 說明但不實作（由 agent 工具負責） |
| **Mode-specific skills** | 🔶 選擇性參考 | 文件中提及，但不強制實作 |
| **Override priority** | ❌ 不整合 | 過於複雜，scaffolding 維持簡單的 project > global |

### 實作建議

**採納的跨工具路徑標準**:
```bash
# Scaffolding 應支援
.agents/skills/          # Cross-agent, project-specific
~/.agents/skills/        # Cross-agent, global

# 可選的工具特定路徑
.roo/skills/            # RooCode-specific
.claude/skills/         # Claude Code-specific
```

**文件範例**:
```markdown
## Skill 安裝位置

### 全域技能 (所有專案可用)
- `~/.agents/skills/` — 跨 agent 工具共享
- `~/.claude/skills/` — Claude Code 專用
- `~/.roo/skills/` — RooCode 專用

### 專案技能 (當前專案)
- `.agents/skills/` — 跨 agent 工具，團隊共享
- `.claude/skills/` — Claude Code 專用
```

**不建議整合**:
- ❌ 完整的 8 層優先級系統（過於複雜）
- ❌ Mode-specific 目錄（工具特定功能）

---

## 資源 5: sickn33/antigravity-awesome-skills

### 來源
- **URL**: https://github.com/sickn33/antigravity-awesome-skills
- **規模**: 1,234+ skills (v7.3.0)
- **性質**: Community mega-collection with NPM installer

### 核心特性

**規模與結構**:
- **Skills 數量**: 1,234+ reusable SKILL.md files
- **分類系統**: Architecture, Business, Data & AI, Development, General, Infrastructure, Security, Testing, Workflow
- **Bundles**: Curated role-based collections (Web Wizard, Security Engineer, OSS Maintainer)
- **Workflows**: Step-by-step execution playbooks

**NPM Installer**:
```bash
npx antigravity-awesome-skills               # Default: ~/.gemini/antigravity/skills
npx antigravity-awesome-skills --claude     # Claude Code path
npx antigravity-awesome-skills --cursor     # Cursor path
npx antigravity-awesome-skills --path ./custom
```

**Web App**:
- Interactive browser at `apps/web-app`
- Search, filter, rendering
- Skills copied to `public/skills/`

**Bundle 範例**:
- **Essentials**: brainstorming, architecture, test-driven-development
- **Web Wizard**: frontend-design, api-design-principles
- **Security Engineer**: security-auditor, api-security-best-practices

**Workflow 範例**:
- Ship a SaaS MVP
- Security Audit for a Web App
- Build an AI Agent System

### 整合評估

#### ✅ 優勢

1. **豐富資源**: 1,234+ skills 涵蓋廣泛領域
2. **策展系統**: Bundles 和 workflows 降低選擇負擔
3. **安裝工具**: NPM installer 簡化部署
4. **跨工具支援**: 支援 Claude, Cursor, Gemini, Codex 等

#### ⚠️ 限制與風險

1. **品質不均**: 大量 community skills，品質難以驗證
2. **維護負擔**: 1,234 skills 的更新和測試成本極高
3. **授權混雜**: 
   - anthropics/skills: Apache 2.0 + Source-available
   - obra/superpowers: Custom license
   - HackTricks, OWASP: 各自授權
4. **重複與衝突**: 多來源 skills 可能有命名衝突
5. **規模過大**: 對 scaffolding template 來說過於龐大

#### 🎯 決策點

| 功能 | 整合建議 | 影響範圍 |
|------|---------|---------|
| **完整 skills 集** | ❌ 不整合 | 規模過大，品質風險，維護成本不可控 |
| **Bundle 概念** | ✅ 採納思想 | 參考其 bundle 設計，自行策展少量 skills |
| **Workflow 模式** | ✅ 採納思想 | 參考其 workflow playbook 格式 |
| **NPM installer** | 🔶 參考實作 | 學習安裝流程設計，不直接使用 |
| **Web app** | 🔶 參考 UI** | 學習 skill browser 設計模式 |

### 實作建議

**可採納的設計模式**:

1. **Bundle 概念** — 角色導向的技能組合
   ```yaml
   # data/bundles.yaml
   essentials:
     name: "Essentials"
     description: "Core skills for all projects"
     skills:
       - brainstorming
       - architecture
       - test-driven-development
   ```

2. **Workflow 格式** — 步驟導向的執行指南
   ```markdown
   # docs/users/workflows.md
   
   ## Ship a SaaS MVP
   
   **Goal**: Launch minimum viable product
   
   **Steps**:
   1. Use @brainstorming to plan features
   2. Use @architecture to design system
   3. Use @test-driven-development for implementation
   4. Use @lint-and-validate before commit
   5. Use @create-pr to package work
   ```

3. **Skills 目錄結構**
   ```
   .template/docs/examples/skills/
   ├── essentials/
   │   ├── brainstorming/SKILL.md
   │   ├── architecture/SKILL.md
   │   └── test-driven-development/SKILL.md
   ├── frontend/
   │   ├── frontend-design/SKILL.md
   │   └── react-patterns/SKILL.md
   └── security/
       ├── security-auditor/SKILL.md
       └── api-security/SKILL.md
   ```

**不建議整合**:
- ❌ 匯入完整 1,234 skills（規模過大）
- ❌ 依賴 npx installer（增加依賴）
- ❌ 引用未驗證的 community skills（品質風險）

**建議替代方案**:
1. **策展少量高品質 skills** (10-20 個)
2. **提供外部資源連結**而非直接整合
3. **建立 scaffolding-specific bundles**

---

## 資源 6: huggingface/skills

### 來源
- **URL**: https://github.com/huggingface/skills
- **性質**: Official HuggingFace skills for ML workflows
- **焦點**: Dataset creation, model training, evaluation, paper publishing

### 核心特性

**AI/ML 專用 Skills**:
- `gradio`: Build web UIs and demos in Python
- `hf-cli`: Execute HF Hub operations (download, upload, repos)
- `hugging-face-dataset-viewer`: Explore datasets via REST API
- `hugging-face-datasets`: Create and manage datasets on HF Hub
- `hugging-face-evaluation`: Add eval results to model cards
- `hugging-face-jobs`: Run compute jobs on HF infrastructure
- `hugging-face-model-trainer`: Train/fine-tune LLMs with TRL
- `hugging-face-paper-publisher`: Publish research papers on HF Hub
- `hugging-face-tool-builder`: Build reusable API operation scripts
- `hugging-face-trackio`: Track ML experiments

**跨工具相容性**:
- Claude Code plugin: `.claude-plugin/plugin.json`
- Cursor plugin: `.cursor-plugin/plugin.json`
- Gemini CLI: `gemini-extension.json`
- Codex: `.agents/skills` path

**Install 範例**:
```bash
# Claude Code
/plugin marketplace add huggingface/skills
/plugin install hugging-face-cli@huggingface/skills

# Gemini CLI
gemini extensions install https://github.com/huggingface/skills.git --consent

# Codex
cp skills/* $REPO_ROOT/.agents/skills/
```

### 整合評估

#### ✅ 優勢

1. **Domain-specific**: AI/ML workflows 的高品質範例
2. **Production-grade**: HuggingFace 官方維護
3. **Multi-tool support**: 展示跨工具相容的實作方式
4. **Complete examples**: 包含 CLI tools 和 Python scripts

#### ⚠️ 限制

1. **領域限定**: 主要為 ML/AI 使用情境
2. **依賴 HF 服務**: 技能綁定 HuggingFace 生態系

#### 🎯 決策點

| 功能 | 整合建議 | 影響範圍 |
|------|---------|---------|
| **Skills 內容** | 📚 文件參考 | 非通用需求，在文件中引用不整合 |
| **跨工具設定檔** | ✅ 參考格式 | 學習 plugin.json, gemini-extension.json 格式 |
| **Agent Skills 標準** | ✅ 驗證實作 | 確認 SKILL.md 格式與其他來源一致 |

### 實作建議

**可學習的跨工具整合模式**:

1. **Plugin manifests** — 為不同工具提供 metadata
   ```json
   // .claude-plugin/plugin.json
   {
     "name": "my-scaffolding-skills",
     "version": "1.0.0",
     "skills": [
       {
         "path": "skills/brainstorming",
         "name": "brainstorming"
       }
     ]
   }
   ```

2. **Agent Skills 標準** — 驗證 SKILL.md 格式一致性
   ```markdown
   ---
   name: skill-name
   description: When to use this skill
   ---
   
   # Instructions
   ...
   ```

**不建議整合**:
- ❌ 匯入 HF-specific skills（領域不符）
- ❌ 依賴 HF infrastructure（外部依賴）

---

## 資源 7: Claude Code 官方文件 (繁體中文)

### 來源
- **URL**: https://code.claude.com/docs/zh-TW/vs-code
- **性質**: Official Claude Code VS Code extension documentation
- **語言**: 繁體中文

### 核心特性

**VS Code 整合**:
- Extension 安裝和配置
- 聊天介面和提示框功能
- @-mentions for file/folder references
- Inline diffs and plan review
- Keyboard shortcuts

**Skills 管理**:
- `/plugins` command to open skill manager
- Install scope: user / project / local
- Marketplace management (add/remove sources)

**Chrome 整合**:
- `@browser` mentions
- Browser automation via Claude in Chrome extension

**Git 整合**:
- Commit creation
- Pull request generation
- Git worktrees for parallel tasks

**多對話支援**:
- Multiple chat tabs
- Session history
- Resume remote sessions from claude.ai

### 整合評估

#### ✅ 優勢

1. **繁體中文文件**: 與 scaffolding 的 i18n 目標一致
2. **完整功能說明**: 涵蓋 skill management UI 和 workflows
3. **實務範例**: 展示實際的 user flows

#### ⚠️ 限制

1. **工具特定**: Claude Code 獨有功能（如 plugin marketplace）
2. **文件為主**: 主要為使用說明，非技術規格

#### 🎯 決策點

| 功能 | 整合建議 | 影響範圍 |
|------|---------|---------|
| **繁體中文範例** | ✅ 參考翻譯 | 用於 i18n/locales/zh-TW/agents.toml |
| **Skill 管理 UI** | 📚 文件參考 | 在 scaffolding 文件中說明不同工具的 skill 管理方式 |
| **Workflow 範例** | ✅ 適應性採納 | 參考其 user flows 設計 getting started 文件 |

### 實作建議

**可參考的繁體中文術語**:
```toml
# i18n/locales/zh-TW/agents.toml

[skills]
title = "技能系統"
description = "可重複使用的 AI agent 指令套件"
installation = "技能安裝"
management = "技能管理"

[workflows]
title = "工作流程"
description = "步驟導向的任務執行指南"
```

**User flow 參考**:
```markdown
## 開始使用 Skills

1. **開啟 skill 管理介面**
   - 輸入 `/skills` 開啟管理面板
   
2. **瀏覽可用 skills**
   - 在「可用 skills」標籤中搜尋
   
3. **安裝 skill**
   - 選擇安裝範圍：使用者 / 專案 / 本機
   
4. **使用 skill**
   - 在提示中引用 `@skill-name`
```

**不建議整合**:
- ❌ 複製 Claude Code plugin 系統（工具特定）
- ❌ 依賴 Chrome extension 功能（外部依賴）

---

## 整合決策矩陣

### 高優先級：立即整合

| 功能 | 來源 | 實作方式 | 影響檔案 |
|------|------|---------|---------|
| **AGENTS.md 標準** | agents.md | 文件強化，明確標註標準來源 | `.template/docs/AGENTS_MD_GUIDE.md` |
| **SKILL.md 格式** | anthropics/skills | 採納為 scaffolding 標準 | `.template/docs/examples/skills/*/SKILL.md` |
| **`.agents/` 路徑** | RooCode docs | 支援跨工具 skill 路徑 | `AGENTS.md`, 文件範例 |
| **Bundle 概念** | antigravity | 設計 role-based skill collections | `data/bundles.yaml` |
| **Workflow 格式** | antigravity | 建立 step-by-step playbooks | `docs/users/workflows.md` |
| **繁體中文術語** | Claude Code docs | 提取翻譯 key | `i18n/locales/zh-TW/agents.toml` |

### 中優先級：Phase 2 整合

| 功能 | 來源 | 實作方式 | 預計版本 |
|------|------|---------|---------|
| **Skill 範例庫** | Multiple | 策展 10-20 個高品質 skills | v1.4.0 |
| **Plugin manifests** | HuggingFace | 為不同工具提供 metadata | v1.4.0 |
| **驗證工具** | agents.md | Linter for AGENTS.md format | v1.5.0 |
| **Web catalog** | antigravity | Skill browser UI (optional) | v1.6.0 |

### 低優先級：選擇性參考

| 功能 | 來源 | 處理方式 | 原因 |
|------|------|---------|------|
| **Mode-specific skills** | RooCode | 文件說明但不強制實作 | 工具特定功能 |
| **Progressive loading** | RooCode | 說明機制不實作 | Agent 工具負責 |
| **Claude plugin marketplace** | anthropics | 外部資源連結 | Anthropic-specific |
| **HF-specific skills** | HuggingFace | 外部資源連結 | 領域不符 |

### 不整合：明確排除

| 功能 | 來源 | 排除原因 |
|------|------|---------|
| **1,234 skills 完整集** | antigravity | 規模過大，品質風險，維護成本 |
| **Community skills** | awesome-agent-skills | 品質不均，授權混雜 |
| **RooCode 8 層優先級** | RooCode | 過於複雜 |
| **Tool-specific plugins** | Claude/HF | 非跨工具標準 |

---

## 架構影響分析

### 檔案結構變更

#### 新增檔案 (Phase 1: v1.3.0)

```
.template/
├── docs/
│   ├── AGENTS_MD_GUIDE.md              # agents.md 標準說明 [NEW]
│   ├── SKILL_FORMAT_GUIDE.md           # SKILL.md 格式指南 [NEW]
│   └── examples/
│       ├── skills/                     # Skill 範例目錄 [NEW]
│       │   ├── template-skill/         # 範本結構
│       │   │   ├── SKILL.md
│       │   │   ├── scripts/
│       │   │   ├── templates/
│       │   │   └── resources/
│       │   └── README.md
│       └── agents/                     # AGENTS.md 範例 [NEW]
│           ├── minimal.md
│           ├── full-featured.md
│           └── role-specific/
│               ├── frontend-developer.md
│               ├── backend-engineer.md
│               └── devops-specialist.md
└── i18n/
    └── locales/
        └── zh-TW/
            └── agents.toml             # 新增 skills, workflows 翻譯 [UPDATE]

data/
├── bundles.yaml                        # Role-based skill collections [NEW]
└── workflows.yaml                      # Step-by-step playbooks [NEW]

docs/
└── users/
    ├── skill-management.md             # Skill 管理指南 [NEW]
    └── workflows.md                    # Workflow 執行指南 [NEW]
```

#### Phase 2 檔案 (v1.4.0)

```
.template/
├── docs/
│   └── examples/
│       └── skills/
│           ├── essentials/             # 策展的 skills [NEW]
│           │   ├── brainstorming/
│           │   ├── architecture/
│           │   └── test-driven-development/
│           ├── frontend/
│           │   └── frontend-design/
│           └── security/
│               └── security-auditor/
└── scripts/
    └── validate-agents-md.sh           # AGENTS.md linter [NEW]

.claude-plugin/                         # Claude Code plugin manifest [NEW]
└── plugin.json

gemini-extension.json                   # Gemini CLI extension manifest [NEW]
```

### AGENTS.md 更新

#### 現有 AGENTS.md 需強化的章節

```markdown
<!-- 現有內容維持不變 -->

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

### i18n 更新

#### i18n/locales/zh-TW/agents.toml

```toml
# 現有內容...

[skills]
title = "技能系統 (Skills)"
description = """
可重複使用的 AI agent 指令套件。Skills 讓 agent 專注於特定任務，
例如「brainstorming」、「architecture」或「test-driven-development」。
"""

[skills.format]
title = "Skill 格式"
description = """
Skills 使用 SKILL.md 檔案，包含 YAML frontmatter 和 Markdown 指令。
Frontmatter 定義 name 和 description，Markdown 內容為執行指令。
"""

[skills.installation]
title = "安裝位置"
global_title = "全域 Skills (所有專案)"
global_agents = "~/.agents/skills/ — 跨 agent 工具共享"
global_claude = "~/.claude/skills/ — Claude Code 專用"
global_roo = "~/.roo/skills/ — RooCode 專用"
project_title = "專案 Skills (當前專案)"
project_agents = ".agents/skills/ — 跨 agent 工具，團隊共享"
project_claude = ".claude/skills/ — Claude Code 專用"

[skills.usage]
title = "使用方式"
description = """
在提示中使用 @skill-name 引用 skill：

> Use @brainstorming to plan this feature.

Agent 會自動載入對應的 SKILL.md 並遵循其指令。
"""

[skills.examples]
title = "範例"
description = "參考 .template/docs/examples/skills/ 中的範例。"

[bundles]
title = "技能組合 (Bundles)"
description = """
依角色策展的技能集合，降低從大量 skills 中選擇的負擔。
"""

[bundles.essentials]
name = "核心技能"
description = "所有專案的基礎技能"

[bundles.frontend]
name = "前端開發"
description = "UI/UX、React、設計系統相關技能"

[bundles.backend]
name = "後端工程"
description = "API、資料庫、系統設計相關技能"

[bundles.devops]
name = "DevOps"
description = "部署、CI/CD、基礎設施相關技能"

[bundles.security]
name = "安全工程"
description = "AppSec、測試、合規性相關技能"

[workflows]
title = "工作流程 (Workflows)"
description = """
步驟導向的任務執行指南，結合多個 skills 完成特定目標。
"""

[workflows.mvp]
title = "發布 SaaS MVP"
description = "從想法到產品上線的完整流程"

[workflows.security_audit]
title = "安全性稽核"
description = "Web app 的安全性檢查流程"

[workflows.ai_agent]
title = "建構 AI Agent 系統"
description = "AI agent 開發和部署流程"
```

### data/bundles.yaml (新檔案)

```yaml
# Role-based skill collections
# Format: bundle-id → { name, description, skills[] }

essentials:
  name: "Essentials"
  description: "Core skills for all projects"
  skills:
    - brainstorming
    - architecture
    - test-driven-development
    - doc-coauthoring
    - lint-and-validate

frontend:
  name: "Frontend Development"
  description: "UI/UX, React, design systems"
  skills:
    - frontend-design
    - react-patterns
    - typescript-expert
    - responsive-design
    - accessibility-audit

backend:
  name: "Backend Engineering"
  description: "API, database, system design"
  skills:
    - api-design-principles
    - database-optimization
    - microservices-patterns
    - system-architecture
    - performance-profiling

devops:
  name: "DevOps & Cloud"
  description: "Deployment, CI/CD, infrastructure"
  skills:
    - docker-expert
    - kubernetes-patterns
    - ci-cd-automation
    - infrastructure-as-code
    - monitoring-observability

security:
  name: "Security Engineering"
  description: "AppSec, testing, compliance"
  skills:
    - security-auditor
    - api-security-best-practices
    - sql-injection-testing
    - vulnerability-scanner
    - compliance-checker
```

### data/workflows.yaml (新檔案)

```yaml
# Step-by-step execution playbooks
# Format: workflow-id → { name, goal, steps[] }

ship-saas-mvp:
  name: "Ship a SaaS MVP"
  goal: "Launch minimum viable product from idea to production"
  steps:
    - step: 1
      skill: brainstorming
      action: "Use @brainstorming to plan MVP features and scope"
    - step: 2
      skill: architecture
      action: "Use @architecture to design system components"
    - step: 3
      skill: test-driven-development
      action: "Use @test-driven-development for implementation"
    - step: 4
      skill: lint-and-validate
      action: "Use @lint-and-validate before each commit"
    - step: 5
      skill: create-pr
      action: "Use @create-pr to package work for review"

security-audit:
  name: "Security Audit for Web App"
  goal: "Comprehensive security review of web application"
  steps:
    - step: 1
      skill: security-auditor
      action: "Use @security-auditor for overall security assessment"
    - step: 2
      skill: api-security-best-practices
      action: "Use @api-security-best-practices to review API endpoints"
    - step: 3
      skill: sql-injection-testing
      action: "Use @sql-injection-testing on all database queries"
    - step: 4
      skill: vulnerability-scanner
      action: "Use @vulnerability-scanner for dependency audit"
    - step: 5
      skill: compliance-checker
      action: "Use @compliance-checker for regulatory requirements"

build-ai-agent:
  name: "Build an AI Agent System"
  goal: "Develop and deploy AI agent with tools and workflows"
  steps:
    - step: 1
      skill: architecture
      action: "Use @architecture to design agent system"
    - step: 2
      skill: api-design-principles
      action: "Use @api-design-principles for agent API"
    - step: 3
      skill: test-driven-development
      action: "Use @test-driven-development for agent logic"
    - step: 4
      skill: monitoring-observability
      action: "Use @monitoring-observability for agent metrics"
    - step: 5
      skill: deployment-automation
      action: "Use @deployment-automation for agent deployment"
```

---

## 維護策略

### 品質控管

#### Skill 策展原則

1. **數量限制**: 維持 10-20 個高品質 skills
2. **來源驗證**: 只納入 official repositories (anthropics, huggingface)
3. **測試要求**: 每個 skill 需有使用範例和預期輸出
4. **授權檢查**: 確保 Apache 2.0 或相容授權

#### 審核流程

```yaml
# .github/workflows/validate-skills.yml
name: Validate Skills

on: [pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check SKILL.md format
        run: ./.template/scripts/validate-agents-md.sh
      - name: Validate frontmatter
        run: |
          for skill in .template/docs/examples/skills/*/SKILL.md; do
            # Check required fields: name, description
            if ! grep -q "^name:" "$skill"; then
              echo "Missing 'name' in $skill"
              exit 1
            fi
            if ! grep -q "^description:" "$skill"; then
              echo "Missing 'description' in $skill"
              exit 1
            fi
          done
```

### 更新策略

#### 外部資源追蹤

```markdown
<!-- .template/docs/EXTERNAL_RESOURCES.md -->

# External Resources Tracking

## Upstream Repositories

| Resource | Current Version | Last Checked | Update Frequency |
|----------|----------------|--------------|------------------|
| anthropics/skills | Latest | 2026-03-10 | Monthly |
| agents.md | v1.0 | 2026-03-10 | Quarterly |
| Agent Skills Spec | v1.0 | 2026-03-10 | Quarterly |

## Change Log

### 2026-03-10
- Reviewed anthropics/skills: No breaking changes
- agents.md: Standard stable, no updates

### Next Review: 2026-04-10
```

#### 版本更新觸發條件

**Major version bump** (2.0.0):
- SKILL.md 格式標準變更
- AGENTS.md 標準不相容變更

**Minor version bump** (1.4.0):
- 新增 skill 範例
- 新增 bundles 或 workflows
- 新增跨工具支援

**Patch version bump** (1.3.1):
- 修正 skill 範例錯誤
- 更新文件連結
- 翻譯修正

---

## 實作計畫

### Phase 1: 基礎整合 (v1.3.0 → v1.3.1)

**時程**: 立即 (1-2 days)

**工作項目**:
1. ✅ 建立 `.template/docs/AGENTS_MD_GUIDE.md`
2. ✅ 建立 `.template/docs/SKILL_FORMAT_GUIDE.md`
3. ✅ 建立 `.template/docs/examples/skills/template-skill/`
4. ✅ 更新 `AGENTS.md` 加入 Skill System 章節
5. ✅ 更新 `i18n/locales/zh-TW/agents.toml` 加入翻譯
6. ✅ 建立 `data/bundles.yaml`
7. ✅ 建立 `data/workflows.yaml`

**驗收標準**:
- [ ] AGENTS.md 包含 skill system 說明
- [ ] 提供至少 1 個完整的 skill 範例
- [ ] 繁體中文翻譯完整

### Phase 2: 範例擴充 (v1.4.0)

**時程**: 2 weeks

**工作項目**:
1. ⏳ 策展 10 個高品質 skills
   - brainstorming
   - architecture
   - test-driven-development
   - frontend-design
   - security-auditor
   - api-design-principles
   - docker-expert
   - lint-and-validate
   - doc-coauthoring
   - create-pr

2. ⏳ 建立 role-specific AGENTS.md 範例
   - frontend-developer.md
   - backend-engineer.md
   - devops-specialist.md

3. ⏳ 設計 3 個 workflows
   - Ship a SaaS MVP
   - Security Audit
   - Build AI Agent System

**驗收標準**:
- [ ] 每個 skill 有完整的 SKILL.md 和 examples
- [ ] 每個 workflow 有 step-by-step playbook
- [ ] 所有內容有繁體中文翻譯

### Phase 3: 工具支援 (v1.5.0)

**時程**: 1 month

**工作項目**:
1. ⏳ 開發 `.template/scripts/validate-agents-md.sh`
2. ⏳ 建立 `.claude-plugin/plugin.json`
3. ⏳ 建立 `gemini-extension.json`
4. ⏳ 設定 CI workflow for skill validation

**驗收標準**:
- [ ] Linter 檢查 AGENTS.md 和 SKILL.md 格式
- [ ] Plugin manifests 支援 Claude Code 和 Gemini CLI
- [ ] CI 自動驗證所有 skills

### Phase 4: Web Catalog (Optional, v1.6.0)

**時程**: TBD

**工作項目**:
1. ⏳ 參考 antigravity 的 web app 設計
2. ⏳ 建立簡單的 skill browser
3. ⏳ 提供搜尋和篩選功能

**決策**: 評估是否為 template 必要功能

---

## 風險評估與緩解

### 高風險項目

#### 1. 品質控制失控

**風險**: 大量匯入未驗證的 community skills

**影響**: 
- 品質參差不齊影響 scaffolding 信譽
- 授權問題導致法律風險
- 維護成本失控

**緩解措施**:
- ✅ 明確拒絕匯入 antigravity 的完整 1,234 skills
- ✅ 只納入 official repositories 的 skills
- ✅ 建立嚴格的審核流程
- ✅ 限制 skills 數量在 10-20 個

#### 2. 工具特定功能鎖定

**風險**: 過度整合 Claude Code 或 RooCode 特定功能

**影響**:
- Scaffolding 失去跨工具通用性
- 使用者困惑於哪些功能可用

**緩解措施**:
- ✅ 優先採用跨工具標準 (AGENTS.md, SKILL.md, `.agents/`)
- ✅ 工具特定功能僅在文件中說明，不強制實作
- ✅ 明確標註哪些功能為特定工具專用

#### 3. 維護負擔過重

**風險**: 外部資源變更導致持續更新需求

**影響**:
- 開發資源被維護工作佔用
- Scaffolding 更新頻率被拖慢

**緩解措施**:
- ✅ 建立 `.template/docs/EXTERNAL_RESOURCES.md` 追蹤上游變更
- ✅ 設定季度審查週期
- ✅ 只依賴穩定的 official standards

### 中風險項目

#### 4. 使用者認知負擔

**風險**: Skills, bundles, workflows 概念讓使用者困惑

**影響**:
- 學習曲線過高
- 功能被低估使用

**緩解措施**:
- ✅ 提供清晰的 getting started 文件
- ✅ 用 bundles 降低選擇負擔
- ✅ 提供 step-by-step workflows

#### 5. 多語言維護

**風險**: 新增大量內容增加翻譯負擔

**影響**:
- 繁體中文文件落後英文版本
- 維護成本上升

**緩解措施**:
- ✅ Phase 1 就同步建立翻譯
- ✅ 限制內容規模
- ✅ 考慮使用 AI 翻譯工具協助

---

## 結論與建議

### 核心建議

**✅ 立即整合**:
1. **AGENTS.md 標準** — 文件強化，明確標註標準來源
2. **SKILL.md 格式** — 採納為 scaffolding 標準格式
3. **`.agents/` 路徑** — 支援跨工具 skill 共享路徑
4. **Bundle 概念** — 設計 role-based skill collections
5. **Workflow 格式** — 建立 step-by-step playbooks
6. **繁體中文術語** — 提取並標準化翻譯

**🔶 選擇性整合**:
1. **Skill 範例庫** — 策展 10-20 個高品質 skills
2. **Plugin manifests** — 支援 Claude Code, Gemini CLI metadata
3. **驗證工具** — 開發 AGENTS.md linter

**❌ 明確拒絕**:
1. **Antigravity 完整 skills 集** — 規模過大，品質風險
2. **Community skills 大量匯入** — 授權混雜，維護成本
3. **工具特定複雜功能** — 違反跨工具通用性原則

### 成功指標

**短期目標 (v1.3.0-1.4.0)**:
- [ ] AGENTS.md 包含完整的 skill system 說明
- [ ] 至少 5 個策展的高品質 skills
- [ ] 3 個 role-based bundles
- [ ] 2 個 workflows with step-by-step guides
- [ ] 所有新內容有繁體中文翻譯

**長期目標 (v1.5.0+)**:
- [ ] 10-20 個驗證的 skills
- [ ] CI 自動驗證 skill 格式
- [ ] Plugin manifests 支援 3+ agent 工具
- [ ] 使用者反饋正面，學習曲線可接受

### 架構原則

1. **簡單優於複雜**: 保持 scaffolding 的簡潔性
2. **標準優於特定**: 優先採用跨工具標準
3. **策展優於數量**: 少量高品質勝過大量低品質
4. **文件優於程式碼**: 說明機制而非實作所有功能
5. **使用者優於技術**: 降低認知負擔，提升易用性

### 最終決策

**對 my-vibe-scaffolding 專案的整合建議**:

1. **採納 agents.md 和 SKILL.md 標準** — 與現有架構完美契合
2. **設計少量策展的 skills** — 10-20 個高品質範例
3. **提供 bundles 和 workflows** — 降低使用者選擇負擔
4. **支援跨工具路徑** — `.agents/skills/` 標準
5. **保持簡單架構** — 避免複雜的 mode systems 和 priority rules
6. **專注文件品質** — 清晰的 guides 勝過大量功能

**不整合的明確理由**:

1. **Antigravity 的 1,234 skills** — 規模失控，品質風險，維護不可行
2. **Community skills 大量匯入** — 授權混雜，無法驗證品質
3. **工具特定 plugin 系統** — 違反跨工具通用性
4. **複雜的 override priority** — 增加使用者認知負擔

---

## 附錄

### A. Skill 格式範本

```markdown
---
name: skill-name
description: Clear, specific description of when to use this skill and what it does
---

# Skill Name

## Overview

Brief explanation of the skill's purpose and use cases.

## When to Use This Skill

- Specific scenario 1
- Specific scenario 2
- Specific scenario 3

## Prerequisites

- Required tool/library version
- Expected file structure
- Environment setup

## Instructions

### Step 1: [Action Name]

Detailed guidance for the first step.

### Step 2: [Action Name]

Detailed guidance for the second step.

## Examples

### Example 1: [Use Case]

\`\`\`language
code example
\`\`\`

**Expected Output**:
\`\`\`
output example
\`\`\`

## Common Issues

### Issue 1: [Problem Description]

**Symptoms**: What the user will see

**Cause**: Why this happens

**Solution**: How to fix it

## Related Skills

- `@related-skill-1`: When to use instead
- `@related-skill-2`: Use together for X

## References

- [Official documentation](https://example.com)
- [Related tutorial](https://example.com)
```

### B. Bundle 範本

```yaml
bundle-id:
  name: "Bundle Name"
  description: "Brief description of the bundle's purpose and target audience"
  target_role: "Role name (e.g., Frontend Developer)"
  skills:
    - skill-1
    - skill-2
    - skill-3
  recommended_workflows:
    - workflow-1
    - workflow-2
```

### C. Workflow 範本

```yaml
workflow-id:
  name: "Workflow Name"
  goal: "Clear statement of what this workflow achieves"
  target_outcome: "Specific deliverable or end state"
  estimated_time: "2-4 hours"
  prerequisites:
    - "Prerequisite 1"
    - "Prerequisite 2"
  steps:
    - step: 1
      skill: skill-name-1
      action: "Specific instruction for using the skill"
      expected_output: "What the user should have after this step"
    - step: 2
      skill: skill-name-2
      action: "Next specific instruction"
      expected_output: "Expected result"
  validation:
    - "How to verify the workflow succeeded"
    - "Common failure points to check"
```

---

## 變更記錄

| 日期 | 版本 | 變更描述 |
|------|------|---------|
| 2026-03-10 | 1.0.0 | 初始版本：完成 7 個資源的全面分析 |

---

## 核准簽署

**分析師**: Claude (Anthropic AI)  
**審核者**: [待指派]  
**核准者**: [待指派]

**狀態**: ✅ 分析完成，待審核

**下一步行動**:
1. 審核本分析文件
2. 確認整合範圍和優先級
3. 建立實作 issues
4. 開始 Phase 1 實作
