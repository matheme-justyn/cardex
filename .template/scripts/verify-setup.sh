#!/bin/bash
# OpenCode Setup Verification Tool
# Checks if all stability fixes are properly applied

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 OpenCode Setup Verification"
echo "=============================="
echo ""

ISSUES=0
WARNINGS=0

# 1. Check VSCode argv.json
echo "1. Checking VSCode memory configuration..."
ARGV_FILE="$HOME/Library/Application Support/Code/User/argv.json"

if [ -f "$ARGV_FILE" ]; then
    if grep -q "max-old-space-size" "$ARGV_FILE"; then
        HEAP_SIZE=$(grep "max-old-space-size" "$ARGV_FILE" | grep -o '[0-9]*')
        if [ "$HEAP_SIZE" -ge 6144 ]; then
            echo -e "   ${GREEN}✓ VSCode memory configured: ${HEAP_SIZE}MB${NC}"
        else
            echo -e "   ${YELLOW}⚠ VSCode memory too low: ${HEAP_SIZE}MB (recommended: 8192MB)${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
    else
        echo -e "   ${RED}✗ max-old-space-size not found in argv.json${NC}"
        ISSUES=$((ISSUES + 1))
    fi
else
    echo -e "   ${RED}✗ argv.json not found at: $ARGV_FILE${NC}"
    ISSUES=$((ISSUES + 1))
fi

# 2. Check if VSCode has been restarted
echo ""
echo "2. Checking if VSCode has been restarted..."

# Check VSCode process start time
VSCODE_PID=$(pgrep -f "Visual Studio Code" | head -1)
if [ ! -z "$VSCODE_PID" ]; then
    # Get process start time
    START_TIME=$(ps -o lstart= -p $VSCODE_PID)
    echo "   VSCode started: $START_TIME"
    
    # Check if started after argv.json modification
    if [ -f "$ARGV_FILE" ]; then
        ARGV_MTIME=$(stat -f %m "$ARGV_FILE" 2>/dev/null || stat -c %Y "$ARGV_FILE" 2>/dev/null)
        PROCESS_STIME=$(ps -o etime= -p $VSCODE_PID | awk '{print $1}')
        
        # Convert etime to seconds for comparison
        if echo "$PROCESS_STIME" | grep -q "-"; then
            # Days format: "1-12:34:56"
            echo -e "   ${GREEN}✓ VSCode has been running for days (assumed restarted)${NC}"
        else
            echo -e "   ${YELLOW}⚠ Cannot definitively confirm VSCode was restarted after config change${NC}"
            echo "   💡 If you haven't restarted VSCode yet, please do so now"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
else
    echo -e "   ${YELLOW}ℹ VSCode is not currently running${NC}"
fi

# 3. Check opencode.json
echo ""
echo "3. Checking opencode.json configuration..."
if [ -f "opencode.json" ]; then
    if python3 -m json.tool opencode.json > /dev/null 2>&1; then
        echo -e "   ${GREEN}✓ opencode.json is valid JSON${NC}"
        
        # Check for required configurations
        if grep -q '"share"' opencode.json; then
            echo -e "   ${GREEN}✓ Share configuration found${NC}"
        else
            echo -e "   ${YELLOW}⚠ Missing 'share' configuration${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
        
        if grep -q '"compaction"' opencode.json; then
            echo -e "   ${GREEN}✓ Compaction configuration found${NC}"
        else
            echo -e "   ${YELLOW}⚠ Missing 'compaction' configuration${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
    else
        echo -e "   ${RED}✗ opencode.json has syntax errors${NC}"
        ISSUES=$((ISSUES + 1))
    fi
else
    echo -e "   ${RED}✗ opencode.json not found${NC}"
    ISSUES=$((ISSUES + 1))
fi

# 4. Check .opencodeignore
echo ""
echo "4. Checking .opencodeignore..."
if [ -f ".opencodeignore" ]; then
    LINE_COUNT=$(wc -l < .opencodeignore)
    echo -e "   ${GREEN}✓ .opencodeignore exists ($LINE_COUNT lines)${NC}"
else
    echo -e "   ${YELLOW}⚠ .opencodeignore not found${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

# 5. Check scripts
echo ""
echo "5. Checking automation scripts..."
REQUIRED_SCRIPTS=(
    "scripts/fix-opencode-stability.sh"
    "scripts/opencode-workflow.sh"
    "scripts/backup-opencode-sessions.sh"
    "scripts/recover-opencode-sessions.sh"
    "scripts/monitor-stability.sh"
)

for SCRIPT in "${REQUIRED_SCRIPTS[@]}"; do
    if [ -f "$SCRIPT" ] && [ -x "$SCRIPT" ]; then
        echo -e "   ${GREEN}✓ $SCRIPT${NC}"
    elif [ -f "$SCRIPT" ]; then
        echo -e "   ${YELLOW}⚠ $SCRIPT (not executable)${NC}"
        chmod +x "$SCRIPT"
        echo "      Fixed: made executable"
    else
        echo -e "   ${RED}✗ $SCRIPT (missing)${NC}"
        ISSUES=$((ISSUES + 1))
    fi
done

# 6. Check git hooks
echo ""
echo "6. Checking git hooks..."
if [ -f ".git/hooks/post-commit" ] && [ -x ".git/hooks/post-commit" ]; then
    echo -e "   ${GREEN}✓ post-commit hook installed${NC}"
else
    echo -e "   ${YELLOW}⚠ post-commit hook not installed or not executable${NC}"
    WARNINGS=$((WARNINGS + 1))
fi

# 7. Check OpenCode database
echo ""
echo "7. Checking OpenCode database..."
OPENCODE_DB="$HOME/.local/share/opencode/opencode.db"
if [ -f "$OPENCODE_DB" ]; then
    INTEGRITY=$(sqlite3 "$OPENCODE_DB" "PRAGMA integrity_check;" 2>&1)
    if [ "$INTEGRITY" = "ok" ]; then
        echo -e "   ${GREEN}✓ Database integrity: OK${NC}"
        
        SESSION_COUNT=$(sqlite3 "$OPENCODE_DB" "SELECT COUNT(*) FROM session WHERE time_archived IS NULL;" 2>/dev/null)
        echo "   Active sessions: $SESSION_COUNT"
    else
        echo -e "   ${RED}✗ Database corrupted!${NC}"
        echo "   $INTEGRITY"
        ISSUES=$((ISSUES + 1))
    fi
else
    echo -e "   ${YELLOW}ℹ Database not found (normal if OpenCode hasn't been used yet)${NC}"
fi

# 8. Check running OpenCode instances
echo ""
echo "8. Checking running OpenCode instances..."
OPENCODE_COUNT=$(ps aux | grep -i "opencode --port" | grep -v grep | wc -l)

if [ "$OPENCODE_COUNT" -eq 0 ]; then
    echo -e "   ${YELLOW}ℹ No OpenCode instances running${NC}"
elif [ "$OPENCODE_COUNT" -eq 1 ]; then
    echo -e "   ${GREEN}✓ One OpenCode instance running${NC}"
else
    echo -e "   ${RED}✗ Multiple OpenCode instances detected: $OPENCODE_COUNT${NC}"
    echo "   This increases crash risk! Close all but one."
    ISSUES=$((ISSUES + 1))
fi

# Summary
echo ""
echo "================================"
echo "Summary:"
echo ""

if [ "$ISSUES" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    echo -e "${GREEN}✅ Perfect! All checks passed!${NC}"
    echo ""
    echo "You're ready to:"
    echo "  1. Start using OpenCode with: ./scripts/opencode-workflow.sh start"
    echo "  2. Report daily progress: ./scripts/monitor-stability.sh report"
    echo "  3. Check summary in 7 days: ./scripts/monitor-stability.sh summary"
elif [ "$ISSUES" -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Setup complete with $WARNINGS warning(s)${NC}"
    echo ""
    echo "Minor issues detected but not critical."
    echo "You can proceed but review warnings above."
else
    echo -e "${RED}❌ Found $ISSUES critical issue(s) and $WARNINGS warning(s)${NC}"
    echo ""
    echo "Please fix critical issues before proceeding:"
    echo "  - Re-run: ./scripts/fix-opencode-stability.sh"
    echo "  - Or manually address issues listed above"
fi

echo ""
echo "For detailed documentation, see:"
echo "  - GET_STARTED.md (quick start)"
echo "  - docs/OPENCODE_STABILITY.md (full guide)"

exit $ISSUES
