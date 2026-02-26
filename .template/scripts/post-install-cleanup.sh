#!/bin/bash
# Post-installation cleanup script
# 安裝後清理腳本

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}🧹 Scaffolding 安裝後清理${NC}"
echo -e "${CYAN}   Post-Installation Cleanup${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}這個腳本會幫你清理不需要的鷹架內容${NC}"
echo -e "${YELLOW}This script removes unnecessary scaffolding content${NC}"
echo ""

# 統計
DELETED_SIZE=0

# 1. 移除鷹架宣傳素材
echo -e "${BLUE}📸 Step 1: 鷹架宣傳素材 | Marketing Assets${NC}"
if [ -d ".template/assets/images" ]; then
    SIZE=$(du -sh .template/assets/images | cut -f1)
    echo -e "   發現：.template/assets/images/ (${SIZE})"
    echo -e "   內容：鷹架的 logo 和插圖"
    read -p "   刪除？ (Y/n): " remove_assets
    if [[ ! $remove_assets =~ ^[Nn]$ ]]; then
        rm -rf .template/assets/images/
        echo -e "   ${GREEN}✅ 已刪除${NC}"
        DELETED_SIZE=$((DELETED_SIZE + 6))
    else
        echo -e "   ${YELLOW}⏭️  保留${NC}"
    fi
else
    echo -e "   ${GREEN}✅ 無此目錄（已刪除或不存在）${NC}"
fi
echo ""

# 2. 語言配置
echo -e "${BLUE}🌐 Step 2: 語言配置 | Language Configs${NC}"
if [ -d ".template/languages" ]; then
    echo -e "   當前語言配置："
    for lang in .template/languages/*/; do
        if [ -d "$lang" ]; then
            lang_name=$(basename "$lang")
            echo -e "   - ${lang_name}"
        fi
    done
    echo ""
    echo -e "   ${YELLOW}提示：只保留你專案用的語言${NC}"
    read -p "   保留哪個語言？(typescript/go/python/rust/all): " KEEP_LANG
    
    if [ "$KEEP_LANG" != "all" ] && [ -n "$KEEP_LANG" ]; then
        for lang in .template/languages/*/; do
            if [ -d "$lang" ]; then
                lang_name=$(basename "$lang")
                if [ "$lang_name" != "$KEEP_LANG" ]; then
                    rm -rf "$lang"
                    echo -e "   ${GREEN}✅ 已刪除 .template/languages/${lang_name}/${NC}"
                fi
            fi
        done
    else
        echo -e "   ${YELLOW}⏭️  保留所有語言${NC}"
    fi
else
    echo -e "   ${GREEN}✅ 無此目錄${NC}"
fi
echo ""

# 3. 鷹架說明書
echo -e "${BLUE}📚 Step 3: 鷹架說明書 | Scaffolding Guides${NC}"
echo -e "   這些是「如何使用鷹架」的指南，讀完可以刪除："
GUIDES=(
    ".template/docs/README_GUIDE.md"
    ".template/docs/TEMPLATE_SYNC.md"
    ".template/docs/README_BILINGUAL_FORMAT.md"
)

FOUND_GUIDES=()
for guide in "${GUIDES[@]}"; do
    if [ -f "$guide" ]; then
        echo -e "   - $(basename $guide)"
        FOUND_GUIDES+=("$guide")
    fi
done

if [ ${#FOUND_GUIDES[@]} -gt 0 ]; then
    echo ""
    read -p "   刪除這些指南？ (y/N): " remove_guides
    if [[ $remove_guides =~ ^[Yy]$ ]]; then
        for guide in "${FOUND_GUIDES[@]}"; do
            rm "$guide"
            echo -e "   ${GREEN}✅ 已刪除 $(basename $guide)${NC}"
        done
    else
        echo -e "   ${YELLOW}⏭️  保留（建議讀完後再刪）${NC}"
    fi
else
    echo -e "   ${GREEN}✅ 無說明書檔案${NC}"
fi
echo ""

# 4. AI 工具配置
echo -e "${BLUE}🤖 Step 4: AI 工具配置 | AI Tool Configs${NC}"
AI_TOOLS=()
[ -d ".claude" ] && AI_TOOLS+=("claude:.claude/")
[ -d ".roo" ] && AI_TOOLS+=("roo:.roo/")
[ -d ".opencode" ] && AI_TOOLS+=("opencode:.opencode/")

if [ ${#AI_TOOLS[@]} -gt 0 ]; then
    echo -e "   發現的 AI 工具配置："
    for tool in "${AI_TOOLS[@]}"; do
        tool_name=$(echo $tool | cut -d: -f1)
        echo -e "   - ${tool_name}"
    done
    echo ""
    echo -e "   ${YELLOW}提示：大部分團隊只用一種 AI 工具${NC}"
    read -p "   你用哪個？(opencode/claude/roo/all): " USE_AI_TOOL
    
    if [ "$USE_AI_TOOL" != "all" ]; then
        for tool in "${AI_TOOLS[@]}"; do
            tool_name=$(echo $tool | cut -d: -f1)
            tool_path=$(echo $tool | cut -d: -f2)
            
            if [ "$tool_name" != "$USE_AI_TOOL" ]; then
                rm -rf "$tool_path"
                echo -e "   ${GREEN}✅ 已刪除 ${tool_path}${NC}"
            fi
        done
    else
        echo -e "   ${YELLOW}⏭️  保留所有 AI 工具配置${NC}"
    fi
else
    echo -e "   ${GREEN}✅ 無 AI 工具配置目錄${NC}"
fi
echo ""

# 5. 根目錄檢查
echo -e "${BLUE}📂 Step 5: 根目錄檢查 | Root Directory Check${NC}"
ROOT_FILE_COUNT=$(ls -1 | wc -l | xargs)
echo -e "   根目錄檔案數量：${ROOT_FILE_COUNT}"

if [ $ROOT_FILE_COUNT -gt 20 ]; then
    echo -e "   ${YELLOW}⚠️  建議：根目錄檔案應 <20 個${NC}"
    echo -e "   考慮將中間檔案移到 docs/ 或刪除"
else
    echo -e "   ${GREEN}✅ 根目錄很乾淨${NC}"
fi
echo ""

# 完成
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}✅ 清理完成！${NC}"
if [ $DELETED_SIZE -gt 0 ]; then
    echo -e "${GREEN}節省空間：約 ${DELETED_SIZE}MB${NC}"
fi
echo -e "${CYAN}========================================${NC}"
echo ""

echo -e "${YELLOW}📝 接下來的步驟 | Next Steps:${NC}"
echo -e "1. 檢查根目錄，移動中間檔案到 docs/"
echo -e "2. 考慮採用「根目錄政策」到 AGENTS.md"
echo -e "3. 參考 .template/docs/adr/ 的 ADR 範例"
echo ""
echo -e "${CYAN}詳細說明：.template/docs/POST_INSTALL_CLEANUP.md${NC}"
