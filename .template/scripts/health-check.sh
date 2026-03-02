#!/usr/bin/env bash
# Project Health Check Script
# 檢查專案配置、MCP 設定、作業系統偵測等核心功能是否正常
#
# Usage:
#   ./.template/scripts/health-check.sh

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 測試計數
PASS=0
FAIL=0
WARN=0

echo ""
echo "🏥 Project Health Check - MCP & OS Detection"
echo "════════════════════════════════════════════════════════════"
echo ""

# 測試函數
test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

test_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARN++))
}

test_section() {
    echo ""
    echo -e "${BLUE}▶${NC} $1"
    echo "────────────────────────────────────────────────────────────"
}

# ============================================================================
# Test 1: 檢查新增的檔案
# ============================================================================
test_section "Test 1: 檢查新增檔案是否存在"

if [ -f ".template/scripts/start-opencode.sh" ]; then
    test_pass "start-opencode.sh 存在"
    if [ -x ".template/scripts/start-opencode.sh" ]; then
        test_pass "start-opencode.sh 有執行權限"
    else
        test_fail "start-opencode.sh 沒有執行權限"
    fi
else
    test_fail "start-opencode.sh 不存在"
fi

if [ -f ".template/scripts/detect-os.sh" ]; then
    test_pass "detect-os.sh 存在"
    if [ -x ".template/scripts/detect-os.sh" ]; then
        test_pass "detect-os.sh 有執行權限"
    else
        test_fail "detect-os.sh 沒有執行權限"
    fi
else
    test_fail "detect-os.sh 不存在"
fi

# ============================================================================
# Test 2: 測試 opencode.json 配置
# ============================================================================
test_section "Test 2: 驗證 opencode.json 配置"

if [ -f "opencode.json" ]; then
    test_pass "opencode.json 存在"
    
    # JSON 語法驗證
    if command -v python3 &>/dev/null; then
        if python3 -m json.tool opencode.json > /dev/null 2>&1; then
            test_pass "JSON 語法正確"
        else
            test_fail "JSON 語法錯誤"
        fi
    fi
    
    # 檢查 mcp 配置
    if grep -q '"mcp"' opencode.json; then
        test_pass "mcp 配置存在"
        
        # 檢查 GitHub MCP
        if grep -q '"github"' opencode.json; then
            test_pass "GitHub MCP 已配置"
            
            # 確認沒有 environment 區塊（應該由系統環境變數提供）
            if grep -A 5 '"github"' opencode.json | grep -q '"environment"'; then
                test_warn "GitHub MCP 包含 environment 區塊（應該移除，改用啟動腳本）"
            else
                test_pass "GitHub MCP 正確配置（無 environment 區塊）"
            fi
        else
            test_warn "GitHub MCP 未配置（可選）"
        fi
    else
        test_fail "mcp 配置不存在"
    fi
else
    test_fail "opencode.json 不存在"
fi

# ============================================================================
# Test 3: 測試作業系統偵測功能
# ============================================================================
test_section "Test 3: 作業系統偵測功能"

# 執行偵測腳本
if ./.template/scripts/detect-os.sh > /tmp/detect-os-output.log 2>&1; then
    test_pass "detect-os.sh 執行成功"
    
    # 檢查 config.toml 是否有 [system] 區塊
    if grep -q "^\[system\]" config.toml; then
        test_pass "config.toml 包含 [system] 區塊"
        
        # 檢查必要欄位
        if grep -q "os_type = " config.toml; then
            OS_TYPE=$(grep "os_type = " config.toml | cut -d'"' -f2)
            test_pass "os_type 已偵測: $OS_TYPE"
        else
            test_fail "os_type 未偵測"
        fi
        
        if grep -q "timeout_command = " config.toml; then
            TIMEOUT_CMD=$(grep "timeout_command = " config.toml | cut -d'"' -f2)
            test_pass "timeout_command 已偵測: $TIMEOUT_CMD"
        else
            test_fail "timeout_command 未偵測"
        fi
        
        if grep -q "sed_inplace = " config.toml; then
            test_pass "sed_inplace 已偵測"
        else
            test_fail "sed_inplace 未偵測"
        fi
    else
        test_fail "config.toml 缺少 [system] 區塊"
    fi
else
    test_fail "detect-os.sh 執行失敗"
    cat /tmp/detect-os-output.log
fi

# ============================================================================
# Test 4: 測試啟動腳本語法
# ============================================================================
test_section "Test 4: 啟動腳本語法檢查"

if bash -n .template/scripts/start-opencode.sh 2>/dev/null; then
    test_pass "start-opencode.sh 語法正確"
else
    test_fail "start-opencode.sh 語法錯誤"
fi

# 檢查腳本是否正確載入 .env
if grep -q "source.*\.env" .template/scripts/start-opencode.sh; then
    test_pass "start-opencode.sh 包含載入 .env 的邏輯"
else
    test_fail "start-opencode.sh 缺少載入 .env 的邏輯"
fi

# ============================================================================
# Test 5: 執行 MCP 配置測試腳本
# ============================================================================
test_section "Test 5: MCP 配置驗證 (test-mcp-setup.sh)"

if ./.template/scripts/test-mcp-setup.sh > /tmp/mcp-setup-test.log 2>&1; then
    test_pass "test-mcp-setup.sh 執行成功（所有檢查通過）"
    echo ""
    echo "   📋 詳細報告："
    tail -15 /tmp/mcp-setup-test.log | sed 's/^/   /'
else
    test_warn "test-mcp-setup.sh 發現問題（查看詳細報告）"
    echo ""
    echo "   📋 詳細報告："
    tail -20 /tmp/mcp-setup-test.log | sed 's/^/   /'
fi

# ============================================================================
# Test 6: 檢查 .env 和 token
# ============================================================================
test_section "Test 6: GitHub Token 配置"

if [ -f ".env" ]; then
    test_pass ".env 檔案存在"
    
    if grep -q "GITHUB_PERSONAL_ACCESS_TOKEN=" .env; then
        TOKEN_VALUE=$(grep "GITHUB_PERSONAL_ACCESS_TOKEN=" .env | cut -d= -f2)
        
        if [ -n "$TOKEN_VALUE" ] && [ "$TOKEN_VALUE" != "your_token_here" ]; then
            if [[ $TOKEN_VALUE == github_pat_* ]] || [[ $TOKEN_VALUE == ghp_* ]]; then
                test_pass "GitHub token 已設置且格式正確"
                
                # 測試 token 有效性
                source .env
                HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
                    -H "Authorization: Bearer $GITHUB_PERSONAL_ACCESS_TOKEN" \
                    https://api.github.com/user)
                
                if [ "$HTTP_CODE" = "200" ]; then
                    test_pass "GitHub token 有效（API 返回 200）"
                else
                    test_fail "GitHub token 無效（API 返回 $HTTP_CODE）"
                fi
            else
                test_warn "GitHub token 格式可能不正確"
            fi
        else
            test_fail "GitHub token 未設置或為預設值"
        fi
    else
        test_fail ".env 中缺少 GITHUB_PERSONAL_ACCESS_TOKEN"
    fi
    
    # 檢查 .gitignore
    if grep -q "^\.env$" .gitignore; then
        test_pass ".env 已加入 .gitignore（安全）"
    else
        test_fail ".env 未在 .gitignore 中（安全風險！）"
    fi
else
    test_fail ".env 檔案不存在"
fi

# ============================================================================
# Test 7: AGENTS.md 更新檢查
# ============================================================================
test_section "Test 7: AGENTS.md 包含系統環境說明"

if grep -q "## System Environment" AGENTS.md; then
    test_pass "AGENTS.md 包含 System Environment 段落"
    
    if grep -q "config.toml" AGENTS.md && grep -q "\[system\]" AGENTS.md; then
        test_pass "AGENTS.md 說明如何讀取 config.toml [system]"
    else
        test_warn "AGENTS.md 可能缺少詳細說明"
    fi
else
    test_fail "AGENTS.md 缺少 System Environment 段落"
fi

# ============================================================================
# Test 8: 文件更新檢查
# ============================================================================
test_section "Test 8: 文件更新完整性"

# 檢查 MCP_SETUP_GUIDE.md
if grep -q "start-opencode.sh" .template/docs/MCP_SETUP_GUIDE.md; then
    test_pass "MCP_SETUP_GUIDE.md 包含啟動腳本說明"
else
    test_fail "MCP_SETUP_GUIDE.md 缺少啟動腳本說明"
fi

# 檢查 INSTALL.md
if grep -q "start-opencode.sh" .opencode/INSTALL.md; then
    test_pass "INSTALL.md 包含啟動腳本說明"
else
    test_fail "INSTALL.md 缺少啟動腳本說明"
fi

# ============================================================================
# 總結
# ============================================================================
echo ""
echo "════════════════════════════════════════════════════════════"
echo "📊 測試結果統計"
echo "════════════════════════════════════════════════════════════"
echo -e "${GREEN}通過：$PASS${NC}"
echo -e "${RED}失敗：$FAIL${NC}"
echo -e "${YELLOW}警告：$WARN${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✅ 所有檢查項目通過！${NC}"
    echo ""
    echo "📝 建議手動驗證項目（可選）："
    echo ""
    echo "  1. 使用啟動腳本啟動 OpenCode："
    echo "     ./.template/scripts/start-opencode.sh 61180"
    echo ""
    echo "  2. 在 OpenCode UI 中測試 GitHub MCP："
    echo "     \"請使用 GitHub MCP 列出這個 repository 的 open issues\""
    echo ""
    echo "  3. 確認 AI 使用 MCP 工具（不是 gh CLI）"
    echo ""
    echo -e "${GREEN}✅ 專案健康狀況良好！${NC}"
    echo ""
    echo "💡 如果需要發版，執行："
    echo "   ./.template/scripts/bump-version.sh patch|minor|major"
    echo ""
    exit 0
else
    echo -e "${RED}❌ 發現 $FAIL 個問題，請修復後再檢查${NC}"
    echo ""
    echo "💡 查看詳細日誌："
    echo "  - cat /tmp/detect-os-output.log"
    echo "  - cat /tmp/mcp-setup-test.log"
    echo ""
    exit 1
fi
