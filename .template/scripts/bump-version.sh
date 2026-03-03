#!/bin/bash
# Version Bump Script
# 用於自動更新版本號並建立 Git tag

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 讀取當前版本
CURRENT_VERSION=$(cat VERSION)
echo -e "${GREEN}當前版本: ${CURRENT_VERSION}${NC}"

# 解析版本號
IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR="${VERSION_PARTS[0]}"
MINOR="${VERSION_PARTS[1]}"
PATCH="${VERSION_PARTS[2]}"

# 顯示選單
echo ""
echo "請選擇版本升級類型："
echo "  1) Patch (${MAJOR}.${MINOR}.$((PATCH+1))) - 錯誤修正、文件更新"
echo "  2) Minor (${MAJOR}.$((MINOR+1)).0) - 新增功能（向下相容）"
echo "  3) Major ($((MAJOR+1)).0.0) - 重大變更（不相容）"
echo "  4) 自訂版本號"
echo "  5) 取消"
echo ""

read -p "請輸入選項 (1-5): " choice

case $choice in
  1)
    NEW_VERSION="${MAJOR}.${MINOR}.$((PATCH+1))"
    TYPE="patch"
    ;;
  2)
    NEW_VERSION="${MAJOR}.$((MINOR+1)).0"
    TYPE="minor"
    ;;
  3)
    NEW_VERSION="$((MAJOR+1)).0.0"
    TYPE="major"
    ;;
  4)
    read -p "請輸入新版本號 (格式: X.Y.Z): " NEW_VERSION
    TYPE="custom"
    ;;
  5)
    echo "已取消"
    exit 0
    ;;
  *)
    echo -e "${RED}無效的選項${NC}"
    exit 1
    ;;
esac

echo ""
echo -e "${YELLOW}版本將從 ${CURRENT_VERSION} 升級到 ${NEW_VERSION}${NC}"
read -p "確定要繼續嗎？ (y/N): " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
  echo "已取消"
  exit 0
fi

# 🚨 Pre-1.0 version constraint check
# Project must stay in 0.X until official release
IFS='.' read -r -a NEW_VERSION_PARTS <<< "$NEW_VERSION"
NEW_MAJOR="${NEW_VERSION_PARTS[0]}"

if [ "$NEW_MAJOR" -ge 1 ]; then
  echo -e "${RED}❌ ERROR: Version bump to 1.0.0 or higher is BLOCKED${NC}"
  echo ""
  echo "This project uses 0.X versioning until official release."
  echo "All versions must stay below 1.0.0 until the project owner announces release."
  echo ""
  echo "See AGENTS.md for version policy details."
  exit 1
fi


# 檢查工作模式（scaffolding 或 project）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CONFIG_FILE="${PROJECT_ROOT}/config.toml"

MODE="project"  # 預設為 project mode
if [ -f "$CONFIG_FILE" ]; then
  MODE=$(grep '^mode = ' "$CONFIG_FILE" | sed 's/mode = "\(.*\)"/\1/')
fi

# 更新 VERSION 檔案
echo "$NEW_VERSION" > VERSION
echo -e "${GREEN}✓ 已更新 VERSION 檔案${NC}"

# 如果是 scaffolding mode，同步更新 .template/VERSION
if [ "$MODE" = "scaffolding" ]; then
  echo "$NEW_VERSION" > .template/VERSION
  echo -e "${GREEN}✓ 已同步更新 .template/VERSION（scaffolding mode）${NC}"
fi

# 提示更新 CHANGELOG.md
echo ""
echo -e "${YELLOW}請手動更新 .template/CHANGELOG.md，加入以下區塊：${NC}"
echo ""
echo "## [$NEW_VERSION] - $(date +%Y-%m-%d)"
echo ""
echo "### Added"
echo "- 新增的功能"
echo ""
echo "### Changed"
echo "- 變更的功能"
echo ""
echo "### Fixed"
echo "- 修正的問題"
echo ""
echo "### Removed"
echo "- 移除的功能"
echo ""

read -p "按 Enter 繼續，或按 Ctrl+C 取消..."

# Git commit
read -p "請輸入 commit message (留空使用預設): " commit_msg
if [ -z "$commit_msg" ]; then
  commit_msg="chore: bump version to ${NEW_VERSION}"
fi

# Git add（scaffolding mode 需包含 .template/VERSION）
if [ "$MODE" = "scaffolding" ]; then
  # 檢查 sync_readme 是否啟用
  SYNC_README=$(grep "sync_readme.*=.*true" config.toml || echo "")
  
  if [ -n "$SYNC_README" ]; then
    echo -e "${YELLOW}正在同步 README.md 到 .template/...${NC}"
    ./.template/scripts/sync-readme.sh || true  # 不阻塞版本升級
    git add VERSION .template/VERSION .template/CHANGELOG.md .template/README.md README.md
  else
    git add VERSION .template/VERSION .template/CHANGELOG.md README.md
  fi
else
  git add VERSION CHANGELOG.md
fi
git commit -m "$commit_msg"
echo -e "${GREEN}✓ 已建立 commit${NC}"

# 建立 Git tag
read -p "請輸入 tag 說明 (留空使用預設): " tag_msg
if [ -z "$tag_msg" ]; then
  tag_msg="Release v${NEW_VERSION}"
fi

git tag -a "v${NEW_VERSION}" -m "$tag_msg"
echo -e "${GREEN}✓ 已建立 tag v${NEW_VERSION}${NC}"

echo ""
echo -e "${GREEN}版本升級完成！${NC}"
echo ""
echo "下一步："
echo "  1. 推送 commit: git push origin main"
echo "  2. 推送 tag: git push origin v${NEW_VERSION}"
  echo "  3. 在 GitHub 建立 Release: gh release create v${NEW_VERSION} --notes-file .template/CHANGELOG.md"
echo ""

read -p "要立即推送嗎？ (y/N): " push_confirm
if [[ $push_confirm =~ ^[Yy]$ ]]; then
  git push origin main
  git push origin "v${NEW_VERSION}"
  echo -e "${GREEN}✓ 已推送到 GitHub${NC}"
  
  read -p "要建立 GitHub Release 嗎？ (y/N): " release_confirm
  if [[ $release_confirm =~ ^[Yy]$ ]]; then
    gh release create "v${NEW_VERSION}" --title "Release v${NEW_VERSION}" --notes "請參考 .template/CHANGELOG.md"
    echo -e "${GREEN}✓ 已建立 GitHub Release${NC}"
  fi
fi

echo ""
echo -e "${GREEN}完成！${NC}"
