# Skills 設定與使用指南

## 🎯 目標

設定「哪些工作自動使用哪些 skills」

---

## 📋 三種設定方式

### ✅ 方式 1：在 AGENTS.md 定義（推薦）

**優點：**
- ✅ AI 會讀取 AGENTS.md 了解專案使用的 skills
- ✅ 團隊成員都能看到
- ✅ 版本控制追蹤

**設定位置：** `AGENTS.md` 檔案

**範例：** 已經幫你在 AGENTS.md 加入以下內容：

```markdown
### Default Skills for This Project

**Auto-load these skills based on task context:**

| Task Type | Skills | Trigger Keywords |
|-----------|--------|------------------|
| Feature Development | brainstorming + test-driven-development | "新增功能", "實作", "開發" |
| Bug Fixing | systematic-debugging | "bug", "錯誤", "修正", "不work" |
| Code Review | requesting-code-review | "review", "檢查程式碼" |
| Planning | brainstorming + writing-plans | "規劃", "設計", "架構" |
| Git Workflow | using-git-worktrees | "feature branch", "worktree" |
```

**使用：**
```
User: "新增使用者登入功能"
→ AI 看到 AGENTS.md，知道應該用 brainstorming + test-driven-development
```

---

### ✅ 方式 2：建立自訂 Bundle

**優點：**
- ✅ 一次載入多個 skills
- ✅ 可重複使用
- ✅ 可在不同專案共享

**設定位置：** `data/bundles.yaml`

**範例：** 已經幫你加入以下 bundle：

```yaml
- id: "my-project-default"
  name: "My Project Default Skills"
  description: "本專案預設技能組合"
  version: "1.0.0"
  skills:
    - name: "brainstorming"
      version: ">=1.0.0"
      required: true
    - name: "test-driven-development"
      version: ">=1.0.0"
      required: true
    - name: "systematic-debugging"
      version: ">=1.0.0"
      required: true
    - name: "requesting-code-review"
      version: ">=1.0.0"
      required: false
  tags: ["default", "project"]
```

**使用：**
```
@use bundle:my-project-default
User: "開始工作"
```

---

### ✅ 方式 3：建立自訂 Workflow

**優點：**
- ✅ 定義完整的步驟流程
- ✅ 每個步驟用不同 skill
- ✅ 適合重複性任務

**設定位置：** `data/workflows.yaml`

**範例：** 已經幫你加入以下 workflow：

```yaml
- id: "my-feature-flow"
  name: "我的功能開發流程"
  description: "客製化的功能開發工作流程"
  version: "1.0.0"
  estimated_time: "2-3 days"
  difficulty: "intermediate"
  
  steps:
    - step: 1
      name: "構思與規劃"
      skill: "brainstorming"
      
    - step: 2
      name: "測試先行"
      skill: "test-driven-development"
      
    - step: 3
      name: "實作功能"
      skill: "coding"
      
    - step: 4
      name: "Code Review"
      skill: "requesting-code-review"
```

**使用：**
```
@workflow my-feature-flow
User: "新增使用者註冊功能"
```

---

## 🎮 實際使用範例

### 情境 1：我要開發新功能

```bash
# 方法 A：依賴 AGENTS.md 定義（自動）
User: "新增使用者登入功能"
→ AI 讀取 AGENTS.md，知道要用 brainstorming + test-driven-development

# 方法 B：手動載入 bundle
@use bundle:my-project-default
User: "新增使用者登入功能"

# 方法 C：使用 workflow
@workflow my-feature-flow
User: "新增使用者登入功能"
```

---

### 情境 2：我要修 bug

```bash
# 方法 A：依賴 AGENTS.md（自動）
User: "修正登入 bug"
→ AI 看到 "bug" 關鍵字，使用 systematic-debugging

# 方法 B：手動載入 skill
@use systematic-debugging
User: "登入時出現 500 錯誤"
```

---

### 情境 3：我要做 code review

```bash
# 方法 A：依賴 AGENTS.md（自動）
User: "review 這段程式碼"
→ AI 看到 "review" 關鍵字，使用 requesting-code-review

# 方法 B：手動載入
@use requesting-code-review
User: "檢查這個 API 的程式碼"
```

---

## 🔧 自訂設定教學

### 如何自訂 AGENTS.md 的 Skills 觸發規則

編輯 `AGENTS.md`，找到 `### Default Skills for This Project` 章節：

```markdown
| Task Type | Skills | Trigger Keywords |
|-----------|--------|------------------|
| 你的任務類型 | `skill-name` | "關鍵字1", "關鍵字2" |
```

**範例：**
```markdown
| API 開發 | `api-design`<br>`test-driven-development` | "建立 API", "REST", "endpoint" |
```

---

### 如何建立自己的 Bundle

編輯 `data/bundles.yaml`：

```yaml
- id: "your-bundle-id"
  name: "Your Bundle Name"
  description: "描述"
  version: "1.0.0"
  skills:
    - name: "skill-1"
      version: ">=1.0.0"
      required: true
    - name: "skill-2"
      version: ">=1.0.0"
      required: false
  tags: ["custom"]
```

---

### 如何建立自己的 Workflow

編輯 `data/workflows.yaml`：

```yaml
- id: "your-workflow-id"
  name: "Your Workflow Name"
  description: "描述"
  version: "1.0.0"
  estimated_time: "1-2 days"
  difficulty: "intermediate"
  
  steps:
    - step: 1
      name: "步驟名稱"
      skill: "skill-name"
      description: "步驟說明"
      actions:
        - "動作1"
        - "動作2"
      outputs:
        - "輸出1"
```

---

## 📊 優先順序

當同時有多種設定時，優先順序：

1. **手動載入** (`@use skill-name`) - 最高優先
2. **Workflow** (`@workflow workflow-id`)
3. **Bundle** (`@use bundle:bundle-id`)
4. **AGENTS.md 觸發規則** - 自動偵測

---

## ✅ 已完成的設定

### 在 AGENTS.md 中

✅ 定義了 5 種任務類型的 skill 觸發規則

### 在 bundles.yaml 中

✅ 建立了 `my-project-default` bundle（包含 4 個 skills）

### 在 workflows.yaml 中

✅ 建立了 `my-feature-flow` workflow（4 個步驟）

---

## 🚀 下一步

1. **測試現有設定**
   ```
   User: "新增一個功能"
   # 看 AI 是否自動載入 brainstorming + test-driven-development
   ```

2. **根據需求調整**
   - 修改 AGENTS.md 的觸發關鍵字
   - 調整 bundle 包含的 skills
   - 自訂 workflow 步驟

3. **建立專案專用 skills**（進階）
   ```bash
   mkdir -p .agents/skills
   cp -r .template/docs/examples/skills/template-skill .agents/skills/my-skill
   # 編輯 .agents/skills/my-skill/SKILL.md
   ```

---

## 📝 快速參考

| 我想要... | 使用方法 | 檔案 |
|-----------|----------|------|
| 自動觸發 skills | 在 AGENTS.md 定義觸發規則 | `AGENTS.md` |
| 組合多個 skills | 建立 bundle | `data/bundles.yaml` |
| 定義步驟流程 | 建立 workflow | `data/workflows.yaml` |
| 手動載入單一 skill | `@use skill-name` | - |
| 手動載入 bundle | `@use bundle:bundle-id` | - |
| 執行 workflow | `@workflow workflow-id` | - |

---

**總結：你現在已經有完整的 skills 設定系統！可以透過 AGENTS.md、bundles、workflows 三種方式來控制「哪些工作用哪些 skills」。** 🎉
