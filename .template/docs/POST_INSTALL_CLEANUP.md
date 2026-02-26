# Post-Installation Cleanup Guide

安裝 scaffolding 後的清理指引 | Post-installation cleanup guide after integrating scaffolding

---

## 🎯 核心原則 | Core Principle

**Scaffolding 是鷹架，不是永久結構。**  
安裝後，刪除不需要的部分，只保留對你的專案有用的。

**Scaffolding is temporary support, not permanent structure.**  
After installation, remove what you don't need, keep only what's useful for your project.

---

## 🗑️ 可安全刪除的內容 | Safe to Delete

### 1. 鷹架宣傳素材 | Scaffolding Marketing Assets

```bash
# 刪除鷹架的 logo 和插圖（6MB）
rm -rf .template/assets/images/
```

**為什麼？| Why?**
- 這些是 my-vibe-scaffolding 專案的宣傳圖片
- 你的專案不需要展示「鷹架」的 logo

### 2. 不需要的語言配置 | Unused Language Configs

```bash
# 只保留你專案用的語言，刪除其他
# 例如：TypeScript 專案

rm -rf .template/languages/go/
rm -rf .template/languages/python/
rm -rf .template/languages/rust/
# 保留 .template/languages/typescript/
```

**為什麼？| Why?**
- Scaffolding 支援多種語言（Go, Python, Rust, TypeScript）
- 你的專案只需要自己用的語言配置

### 3. 鷹架說明書（看完就可以刪）| Scaffolding Guides (delete after reading)

```bash
# 看完這些指南後，可以刪除
rm .template/docs/README_GUIDE.md
rm .template/docs/TEMPLATE_SYNC.md
rm .template/docs/README_BILINGUAL_FORMAT.md

# 或整個刪除（如果你已經熟悉）
rm -rf .template/docs/
```

**為什麼？| Why?**
- 這些是「如何使用鷹架」的說明書
- 讀過、應用後就不需要了

**⚠️ 例外 | Exception:**
- **保留 `.template/docs/adr/`** - 這些是 ADR 範例，值得參考
- **保留專案指南** - 如果你覺得 LICENSE_GUIDE, CONTRIBUTING_GUIDE 還會用到

### 4. 不需要的 AI 工具配置 | Unused AI Tool Configs

```bash
# 如果團隊只用 OpenCode
rm -rf .claude/
rm -rf .roo/

# 如果團隊只用 Claude
rm -rf .opencode/
rm -rf .roo/
```

**為什麼？| Why?**
- 大部分團隊只會用一種 AI 工具
- 保留你用的，刪除其他

---

## ✅ 應該保留的內容 | Should Keep

### 核心基礎設施 | Core Infrastructure

```bash
.template/
├── scripts/          # ✅ 保留：實用工具腳本
│   ├── bump-version.sh
│   ├── install-hooks.sh
│   ├── smart-cleanup.sh
│   └── wl (worklog)
├── hooks/            # ✅ 保留：Git hooks
│   └── pre-push
└── VERSION           # ✅ 保留：記錄鷹架版本
```

### 配置檔案 | Config Files

```bash
✅ AGENTS.md          # AI agent 指令
✅ config.toml        # 專案配置
✅ VERSION            # 專案版本
```

---

## 📋 清理檢查清單 | Cleanup Checklist

安裝完成後，執行這個檢查：

```bash
# 1. 刪除鷹架素材
[ -d ".template/assets/images" ] && echo "⚠️ 可刪除：.template/assets/images/"

# 2. 檢查語言配置
echo "📝 檢查 .template/languages/ 目錄："
ls -1 .template/languages/ 2>/dev/null || echo "（無此目錄）"
echo "   只保留專案用的語言"

# 3. 檢查說明書
[ -f ".template/docs/README_GUIDE.md" ] && echo "⚠️ 讀完可刪：.template/docs/README_GUIDE.md"
[ -f ".template/docs/TEMPLATE_SYNC.md" ] && echo "⚠️ 讀完可刪：.template/docs/TEMPLATE_SYNC.md"

# 4. 檢查 AI 工具配置
[ -d ".claude" ] && echo "⚠️ 如不用 Claude：刪除 .claude/"
[ -d ".roo" ] && echo "⚠️ 如不用 Roo：刪除 .roo/"
[ -d ".opencode" ] && echo "⚠️ 如不用 OpenCode：刪除 .opencode/"

# 5. 檢查根目錄
echo "📂 根目錄檔案數量：$(ls -1 | wc -l)"
echo "   建議：<20 個檔案"
```

---

## 🎓 值得學習/參考的內容 | Worth Learning From

### 1. ADR 範例 | ADR Examples

**保留** `.template/docs/adr/` 作為參考：
- 如何寫好的 ADR
- 決策記錄的結構
- Alternatives Considered 的寫法

### 2. 根目錄政策 | Root Directory Policy

參考專案的根目錄管理方式：

**允許的檔案 | Allowed in Root:**
- 核心文件（README, LICENSE, CHANGELOG）
- AI 配置（AGENTS.md）
- 技術配置（package.json, tsconfig.json）
- 容器化（Containerfile, docker-compose.yml）

**不允許的檔案 | NOT Allowed in Root:**
- ❌ 臨時文件（TODO.md, NOTES.md）
- ❌ AI 生成的摘要（AI_SUMMARY.md）
- ❌ 中間文件

**建議加入你的 AGENTS.md:**
```markdown
## Root Directory Policy

Keep root clean and purposeful:

**Allowed:**
- Essential docs (README, LICENSE, CHANGELOG)
- Config files (package.json, tsconfig.json)
- AI configuration (AGENTS.md)

**NOT Allowed:**
- Temporary notes (TODO.md, NOTES.md)
- AI-generated summaries
```

---

## ❌ 不值得學習的 | Not Worth Learning

### 1. 雙語註解 | Bilingual Comments

**不建議**在程式碼或配置中寫雙語註解：
```toml
# ❌ 不建議
primary_locale = "zh-TW"  # 你的偏好語言 | Your preferred language

# ✅ 建議
primary_locale = "zh-TW"  # Your preferred natural language
```

**原因 | Why:**
- 增加維護成本
- 程式碼註解只需要英文
- 文件可以雙語，但註解不需要

---

## 📝 自動化清理腳本 | Automated Cleanup Script

建立 `.template/scripts/post-install-cleanup.sh`:

```bash
#!/bin/bash
# Post-installation cleanup script

echo "🧹 Scaffolding Post-Installation Cleanup"
echo ""

# 1. Remove marketing assets
if [ -d ".template/assets/images" ]; then
    echo "Removing scaffolding marketing assets..."
    rm -rf .template/assets/images/
    echo "✅ Removed .template/assets/images/"
fi

# 2. Language configs
echo ""
echo "Language configurations in .template/languages/:"
ls -1 .template/languages/ 2>/dev/null | while read lang; do
    echo "  - $lang"
done
echo ""
read -p "Keep which language? (e.g., typescript): " KEEP_LANG

if [ -n "$KEEP_LANG" ]; then
    for lang in .template/languages/*/; do
        lang_name=$(basename "$lang")
        if [ "$lang_name" != "$KEEP_LANG" ]; then
            rm -rf "$lang"
            echo "✅ Removed .template/languages/$lang_name/"
        fi
    done
fi

# 3. AI tool configs
echo ""
echo "AI tool configurations:"
[ -d ".claude" ] && echo "  - .claude/"
[ -d ".roo" ] && echo "  - .roo/"
[ -d ".opencode" ] && echo "  - .opencode/"
echo ""
read -p "Which AI tool do you use? (opencode/claude/roo): " AI_TOOL

case "$AI_TOOL" in
    opencode)
        [ -d ".claude" ] && rm -rf .claude/ && echo "✅ Removed .claude/"
        [ -d ".roo" ] && rm -rf .roo/ && echo "✅ Removed .roo/"
        ;;
    claude)
        [ -d ".opencode" ] && rm -rf .opencode/ && echo "✅ Removed .opencode/"
        [ -d ".roo" ] && rm -rf .roo/ && echo "✅ Removed .roo/"
        ;;
    roo)
        [ -d ".opencode" ] && rm -rf .opencode/ && echo "✅ Removed .opencode/"
        [ -d ".claude" ] && rm -rf .claude/ && echo "✅ Removed .claude/"
        ;;
esac

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Review root directory and move intermediate files to docs/"
echo "2. Consider adopting Root Directory Policy in AGENTS.md"
echo "3. Review .template/docs/adr/ for ADR examples"
```

---

## 🎯 總結 | Summary

**清理後你應該保留** | What to keep after cleanup:
- ✅ `.template/scripts/` - 實用工具
- ✅ `.template/hooks/` - Git hooks
- ✅ `.template/VERSION` - 鷹架版本記錄
- ✅ 你專案用的語言配置
- ✅ 你用的 AI 工具配置
- ✅ ADR 範例（參考用）

**可以刪除** | Safe to delete:
- ❌ `.template/assets/images/` - 鷹架宣傳素材
- ❌ 不用的語言配置
- ❌ 不用的 AI 工具配置
- ❌ 鷹架說明書（讀完後）

**節省空間** | Space saved: ~6-7 MB

**原則** | Principle:
> Scaffolding 是鷹架，幫助你建立專案結構。建好後，拆除不需要的部分。

> Scaffolding is temporary support. After setup, remove what you don't need.
