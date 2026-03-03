#!/bin/bash
# 智能衝突分析報告
# 分析現有專案與 scaffolding 的差異，並給出導入建議

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}🔍 Scaffolding 衝突分析報告${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# 檢查是否為 git repo
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ 錯誤：當前目錄不是 git repository${NC}"
    exit 1
fi

# 檢查是否已經加入 scaffolding remote
if ! git remote | grep -q "^scaffolding$"; then
    echo -e "${YELLOW}⚠️  尚未加入 scaffolding remote${NC}"
    read -p "是否現在加入？ (y/N): " add_remote
    if [[ $add_remote =~ ^[Yy]$ ]]; then
        git remote add scaffolding https://github.com/matheme-justyn/my-vibe-scaffolding.git
        git fetch scaffolding
        echo -e "${GREEN}✅ 已加入 scaffolding remote${NC}"
    else
        echo -e "${RED}❌ 無法進行分析${NC}"
        exit 1
    fi
fi

# Fetch latest scaffolding
echo -e "${BLUE}📡 Fetching latest scaffolding...${NC}"
git fetch scaffolding --quiet

# 建立臨時分析報告目錄
REPORT_DIR=".scaffolding-analysis"
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/conflict-report.md"

# 開始生成報告
cat > "$REPORT_FILE" << 'EOF'
# Scaffolding 整合衝突分析報告

**生成時間**: $(date '+%Y-%m-%d %H:%M:%S')
**當前分支**: $(git branch --show-current)
**Scaffolding 版本**: $(git show scaffolding/main:.template/VERSION 2>/dev/null || echo "未知")

---

## 📊 分析摘要

EOF

# 分析檔案差異
echo -e "${BLUE}📋 分析檔案差異...${NC}"

# 取得雙方所有檔案清單
CURRENT_FILES=$(git ls-files)
SCAFFOLDING_FILES=$(git ls-tree -r scaffolding/main --name-only)

# 建立分類清單
CATEGORY_1_REWRITE=()      # 必須重寫（遵循編寫指南）
CATEGORY_2_IMPORT=()        # 直接導入/覆蓋
CATEGORY_3_CONVERT=()       # 能改寫成新版
CATEGORY_4_KEEP_YOURS=()    # 專案更好，保留你的
CATEGORY_5_NEW_FILES=()     # Scaffolding 有但專案沒有的新檔案

# 定義規則
# Category 1: 必須重寫
REWRITE_FILES=(
    "CONTRIBUTING.md"
    "SECURITY.md"
)

# Category 2: 直接導入/覆蓋
IMPORT_FILES=(
    "AGENTS.md"
    "config.toml.example"
    ".template/*"
)

# Category 3: 能改寫成新版
CONVERT_FILES=(
    ".gitignore"
    ".editorconfig"
    "VERSION"
)

# Category 4: 專案更好，保留你的
KEEP_PROJECT_FILES=(
    "README.md"
    "LICENSE"
)

# 檢查每個檔案
echo "" >> "$REPORT_FILE"
echo "### 檔案分類統計" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 分類邏輯
for file in $CURRENT_FILES; do
    # Skip .git directory
    [[ "$file" =~ ^\.git/ ]] && continue
    
    # Check if file exists in scaffolding
    if echo "$SCAFFOLDING_FILES" | grep -q "^$file$"; then
        # File exists in both
        
        # Check category
        if [[ " ${REWRITE_FILES[@]} " =~ " ${file} " ]]; then
            CATEGORY_1_REWRITE+=("$file")
        elif [[ " ${KEEP_PROJECT_FILES[@]} " =~ " ${file} " ]]; then
            CATEGORY_4_KEEP_YOURS+=("$file")
        elif [[ " ${CONVERT_FILES[@]} " =~ " ${file} " ]]; then
            CATEGORY_3_CONVERT+=("$file")
        elif [[ "$file" == "CLAUDE.md" ]] || [[ "$file" =~ ^\.cursor/ ]]; then
            CATEGORY_2_IMPORT+=("$file")  # 特殊處理：CLAUDE.md → AGENTS.md
        fi
    fi
done

# 找出 scaffolding 有但專案沒有的檔案
for file in $SCAFFOLDING_FILES; do
    [[ "$file" =~ ^\.git/ ]] && continue
    if ! echo "$CURRENT_FILES" | grep -q "^$file$"; then
        CATEGORY_5_NEW_FILES+=("$file")
    fi
done

# 寫入統計
echo "| 分類 | 檔案數量 |" >> "$REPORT_FILE"
echo "|------|---------|" >> "$REPORT_FILE"
echo "| 🔄 必須重寫 | ${#CATEGORY_1_REWRITE[@]} |" >> "$REPORT_FILE"
echo "| ⬇️ 直接導入/覆蓋 | ${#CATEGORY_2_IMPORT[@]} |" >> "$REPORT_FILE"
echo "| 🔧 能改寫成新版 | ${#CATEGORY_3_CONVERT[@]} |" >> "$REPORT_FILE"
echo "| ✅ 專案更好，保留你的 | ${#CATEGORY_4_KEEP_YOURS[@]} |" >> "$REPORT_FILE"
echo "| ➕ 新增檔案 | ${#CATEGORY_5_NEW_FILES[@]} |" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 詳細分類
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## 🔍 詳細分析" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Category 1
if [ ${#CATEGORY_1_REWRITE[@]} -gt 0 ]; then
    echo "### 🔄 Category 1: 必須重寫（遵循編寫指南）" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "這些檔案應該按照 scaffolding 的編寫指南重新撰寫。" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    for file in "${CATEGORY_1_REWRITE[@]}"; do
        echo "- \`$file\`" >> "$REPORT_FILE"
        
        # 找到對應的指南
        case "$file" in
            "CONTRIBUTING.md")
                echo "  - 📖 參考：\`.template/docs/PROJECT_CONTRIBUTING_GUIDE.md\`" >> "$REPORT_FILE"
                ;;
            "SECURITY.md")
                echo "  - 📖 參考：\`.template/docs/PROJECT_SECURITY_GUIDE.md\`" >> "$REPORT_FILE"
                ;;
        esac
    done
    echo "" >> "$REPORT_FILE"
fi

# Category 2
if [ ${#CATEGORY_2_IMPORT[@]} -gt 0 ]; then
    echo "### ⬇️ Category 2: 直接導入/覆蓋" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "這些檔案/目錄應該直接使用 scaffolding 的版本。" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    for file in "${CATEGORY_2_IMPORT[@]}"; do
        echo "- \`$file\`" >> "$REPORT_FILE"
        
        # 特殊說明
        if [[ "$file" == "CLAUDE.md" ]]; then
            echo "  - ⚠️ **刪除此檔案**，改用 \`AGENTS.md\`" >> "$REPORT_FILE"
        elif [[ "$file" =~ ^\.cursor/ ]]; then
            echo "  - ⚠️ **可選**：刪除或保留作為參考" >> "$REPORT_FILE"
        fi
    done
    echo "" >> "$REPORT_FILE"
    
    # 檢查特殊情況
    if echo "$CURRENT_FILES" | grep -q "^CLAUDE.md$"; then
        echo "**⚠️ 偵測到 CLAUDE.md**" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        echo "導入 scaffolding 後將使用 \`AGENTS.md\`。建議：" >> "$REPORT_FILE"
        echo "1. 備份 \`CLAUDE.md\` 內容（如有客製化設定）" >> "$REPORT_FILE"
        echo "2. 刪除 \`CLAUDE.md\`" >> "$REPORT_FILE"
        echo "3. 採用 \`AGENTS.md\` 並根據需求調整" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
    fi
fi

# Category 3
if [ ${#CATEGORY_3_CONVERT[@]} -gt 0 ]; then
    echo "### 🔧 Category 3: 能改寫成新版" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "這些檔案可以合併或轉換成 scaffolding 格式。" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    for file in "${CATEGORY_3_CONVERT[@]}"; do
        echo "- \`$file\`" >> "$REPORT_FILE"
        
        case "$file" in
            ".gitignore")
                echo "  - 建議：合併雙方的規則" >> "$REPORT_FILE"
                echo "  - 工具：\`cat .gitignore <(echo) <(git show scaffolding/main:.gitignore) | sort -u > .gitignore.merged\`" >> "$REPORT_FILE"
                ;;
            "VERSION")
                echo "  - 建議：保留專案版本，scaffolding 版本記錄在 \`.template-version\`" >> "$REPORT_FILE"
                ;;
        esac
    done
    echo "" >> "$REPORT_FILE"
fi

# Category 4
if [ ${#CATEGORY_4_KEEP_YOURS[@]} -gt 0 ]; then
    echo "### ✅ Category 4: 專案更好，保留你的" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "這些是專案的身份檔案，應該保留。" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    for file in "${CATEGORY_4_KEEP_YOURS[@]}"; do
        echo "- \`$file\`" >> "$REPORT_FILE"
        
        case "$file" in
            "README.md")
                echo "  - 📖 如需改善：參考 \`.template/docs/README_GUIDE.md\`" >> "$REPORT_FILE"
                ;;
            "LICENSE")
                echo "  - 📖 參考：\`.template/docs/PROJECT_LICENSE_GUIDE.md\`" >> "$REPORT_FILE"
                ;;
        esac
    done
    echo "" >> "$REPORT_FILE"
fi

# Category 5
if [ ${#CATEGORY_5_NEW_FILES[@]} -gt 0 ]; then
    echo "### ➕ Category 5: Scaffolding 新增檔案" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    echo "這些是 scaffolding 有但你的專案沒有的檔案。" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # 只列出重要的新檔案（排除 .template/ 內的）
    IMPORTANT_NEW_FILES=()
    for file in "${CATEGORY_5_NEW_FILES[@]}"; do
        if [[ ! "$file" =~ ^\.template/ ]]; then
            IMPORTANT_NEW_FILES+=("$file")
        fi
    done
    
    if [ ${#IMPORTANT_NEW_FILES[@]} -gt 0 ]; then
        echo "**根目錄新檔案：**" >> "$REPORT_FILE"
        for file in "${IMPORTANT_NEW_FILES[@]}"; do
            echo "- \`$file\`" >> "$REPORT_FILE"
        done
        echo "" >> "$REPORT_FILE"
    fi
    
    echo "**\`.template/\` 目錄（scaffolding 基礎設施）：**" >> "$REPORT_FILE"
    echo "- 完整的 scaffolding 基礎設施將被導入" >> "$REPORT_FILE"
    echo "- 包含：scripts, docs, hooks, i18n, assets" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
fi

# 生成執行建議
echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## 🚀 執行建議" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "### Step 1: 備份重要檔案" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "\`\`\`bash" >> "$REPORT_FILE"
echo "# 備份可能被覆蓋的檔案" >> "$REPORT_FILE"
echo "mkdir -p .backup-before-scaffolding" >> "$REPORT_FILE"
if [ ${#CATEGORY_1_REWRITE[@]} -gt 0 ]; then
    for file in "${CATEGORY_1_REWRITE[@]}"; do
        echo "cp $file .backup-before-scaffolding/ 2>/dev/null || true" >> "$REPORT_FILE"
    done
fi
echo "\`\`\`" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "### Step 2: 執行整合" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "\`\`\`bash" >> "$REPORT_FILE"
echo "# 建立整合分支" >> "$REPORT_FILE"
echo "git checkout -b integrate-scaffolding" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "# 執行 merge" >> "$REPORT_FILE"
echo "git merge scaffolding/main --allow-unrelated-histories --no-commit" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "### Step 3: 解決衝突（根據分析報告）" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "根據上述分類，逐一處理衝突檔案。" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "### Step 4: 配置與驗證" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "\`\`\`bash" >> "$REPORT_FILE"
echo "# 設定為 project mode" >> "$REPORT_FILE"
echo "cp config.toml.example config.toml" >> "$REPORT_FILE"
echo "# 編輯 config.toml: 設定 mode = \"project\"" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "# 安裝 git hooks" >> "$REPORT_FILE"
echo "./.template/scripts/install-hooks.sh" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "# 驗證整合結果" >> "$REPORT_FILE"
echo "git status" >> "$REPORT_FILE"
echo "\`\`\`" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "---" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "**📝 注意事項：**" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "1. 此報告僅供參考，最終決定權在你" >> "$REPORT_FILE"
echo "2. 建議在新分支進行整合，測試無誤後再合併到 main" >> "$REPORT_FILE"
echo "3. 整合後請更新專案的 README 和文件" >> "$REPORT_FILE"
echo "4. 如有問題，參考 \`.template/docs/\` 中的指南" >> "$REPORT_FILE"

# 完成報告生成
echo -e "${GREEN}✅ 分析完成！${NC}"
echo ""
echo -e "${CYAN}📄 報告已生成：${REPORT_FILE}${NC}"
echo ""
echo -e "${YELLOW}建議：${NC}"
echo "1. 仔細閱讀報告"
echo "2. 根據分類處理衝突"
echo "3. 測試整合結果"
echo ""
read -p "是否現在查看報告？ (Y/n): " view_report
if [[ ! $view_report =~ ^[Nn]$ ]]; then
    if command -v bat &> /dev/null; then
        bat "$REPORT_FILE"
    elif command -v less &> /dev/null; then
        less "$REPORT_FILE"
    else
        cat "$REPORT_FILE"
    fi
fi
