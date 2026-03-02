#!/bin/bash
# Version Sync Check Script
# 檢查 scaffolding mode 下 VERSION 與 .template/VERSION 是否同步

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 檢查工作模式
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
CONFIG_FILE="${PROJECT_ROOT}/config.toml"

MODE="project"  # 預設為 project mode
if [ -f "$CONFIG_FILE" ]; then
  MODE=$(grep '^mode = ' "$CONFIG_FILE" | sed 's/mode = "\(.*\)"/\1/')
fi

# 如果不是 scaffolding mode，跳過檢查
if [ "$MODE" != "scaffolding" ]; then
  echo -e "${GREEN}✓ Project mode - 版本檢查跳過${NC}"
  exit 0
fi

# Scaffolding mode - 必須檢查同步
if [ ! -f "VERSION" ]; then
  echo -e "${RED}✗ 找不到 VERSION 檔案${NC}"
  exit 1
fi

if [ ! -f ".template/VERSION" ]; then
  echo -e "${RED}✗ 找不到 .template/VERSION 檔案${NC}"
  exit 1
fi

VERSION=$(cat VERSION)
TEMPLATE_VERSION=$(cat .template/VERSION)

if [ "$VERSION" != "$TEMPLATE_VERSION" ]; then
  echo -e "${RED}✗ 版本不同步！${NC}"
  echo ""
  echo "  VERSION:           ${VERSION}"
  echo "  .template/VERSION: ${TEMPLATE_VERSION}"
  echo ""
  echo -e "${YELLOW}在 scaffolding mode 下，兩個檔案必須一致。${NC}"
  echo ""
  echo "修正方式："
  echo "  1. 使用 bump-version.sh 更新版本（會自動同步）"
  echo "  2. 或手動同步："
  echo "     cp VERSION .template/VERSION"
  echo ""
  exit 1
fi

echo -e "${GREEN}✓ 版本同步正確 (${VERSION})${NC}"
exit 0
