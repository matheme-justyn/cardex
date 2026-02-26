#!/bin/bash
# OpenCode Daily Workflow Helper
# Automates best practices for stable OpenCode usage

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo "🚀 OpenCode Daily Workflow Helper"
echo "================================="
echo ""

# Function to check if OpenCode is running
check_opencode_running() {
    OPENCODE_COUNT=$(ps aux | grep -i "opencode --port" | grep -v grep | wc -l)
    if [ "$OPENCODE_COUNT" -gt 1 ]; then
        echo -e "${RED}⚠️  WARNING: Multiple OpenCode instances detected ($OPENCODE_COUNT)${NC}"
        echo "   Running multiple instances increases crash risk!"
        echo "   Consider closing all but one."
        echo ""
        ps aux | grep -i "opencode --port" | grep -v grep | awk '{print "   PID:", $2, "Port:", $12}'
        echo ""
    elif [ "$OPENCODE_COUNT" -eq 1 ]; then
        echo -e "${GREEN}✓ One OpenCode instance running${NC}"
    else
        echo -e "${YELLOW}ℹ No OpenCode instances running${NC}"
    fi
}

# Function to check memory usage
check_memory_usage() {
    echo "💾 Memory Status:"
    OPENCODE_PIDS=$(ps aux | grep -i "opencode --port" | grep -v grep | awk '{print $2}')
    
    if [ -z "$OPENCODE_PIDS" ]; then
        echo "   No OpenCode process found"
    else
        for PID in $OPENCODE_PIDS; do
            MEM_MB=$(ps -o rss= -p $PID 2>/dev/null | awk '{print int($1/1024)}')
            if [ ! -z "$MEM_MB" ]; then
                if [ "$MEM_MB" -gt 4096 ]; then
                    echo -e "   ${RED}⚠️  PID $PID: ${MEM_MB}MB (HIGH - consider /clear)${NC}"
                elif [ "$MEM_MB" -gt 2048 ]; then
                    echo -e "   ${YELLOW}⚠️  PID $PID: ${MEM_MB}MB (moderate)${NC}"
                else
                    echo -e "   ${GREEN}✓ PID $PID: ${MEM_MB}MB (normal)${NC}"
                fi
            fi
        done
    fi
    echo ""
}

# Function to check last commit time
check_last_commit() {
    if [ -d .git ]; then
        LAST_COMMIT=$(git log -1 --format="%ar" 2>/dev/null)
        MINUTES_AGO=$(git log -1 --format="%ct" 2>/dev/null)
        CURRENT_TIME=$(date +%s)
        DIFF_MINUTES=$(( ($CURRENT_TIME - $MINUTES_AGO) / 60 ))
        
        echo "📝 Last Commit: $LAST_COMMIT"
        
        if [ "$DIFF_MINUTES" -gt 60 ]; then
            echo -e "   ${YELLOW}⚠️  It's been $DIFF_MINUTES minutes since last commit${NC}"
            echo "   💡 Consider committing your work (checkpoint)"
        else
            echo -e "   ${GREEN}✓ Recent commit (${DIFF_MINUTES} minutes ago)${NC}"
        fi
    else
        echo -e "${YELLOW}ℹ Not a git repository${NC}"
    fi
    echo ""
}

# Function to check if backup needed
check_backup_status() {
    BACKUP_DIR="$HOME/.local/share/opencode-backups"
    if [ -d "$BACKUP_DIR" ]; then
        LAST_BACKUP=$(ls -t "$BACKUP_DIR"/opencode.db.* 2>/dev/null | head -1)
        if [ ! -z "$LAST_BACKUP" ]; then
            BACKUP_TIME=$(stat -f %m "$LAST_BACKUP" 2>/dev/null || stat -c %Y "$LAST_BACKUP" 2>/dev/null)
            CURRENT_TIME=$(date +%s)
            HOURS_AGO=$(( ($CURRENT_TIME - $BACKUP_TIME) / 3600 ))
            
            echo "💾 Last Backup: $(ls -lh "$LAST_BACKUP" | awk '{print $9}' | xargs basename)"
            
            if [ "$HOURS_AGO" -gt 24 ]; then
                echo -e "   ${YELLOW}⚠️  Last backup was $HOURS_AGO hours ago${NC}"
                echo "   💡 Run: ./scripts/backup-opencode-sessions.sh"
            else
                echo -e "   ${GREEN}✓ Recent backup ($HOURS_AGO hours ago)${NC}"
            fi
        else
            echo -e "   ${YELLOW}⚠️  No backups found${NC}"
            echo "   💡 Run: ./scripts/backup-opencode-sessions.sh"
        fi
    else
        echo -e "   ${YELLOW}ℹ No backup directory (run backup script to create)${NC}"
    fi
    echo ""
}

# Function to show daily checklist
show_checklist() {
    echo "✅ Daily Checklist:"
    echo "   [ ] Only ONE OpenCode instance running"
    echo "   [ ] Memory usage < 4GB"
    echo "   [ ] Committed work in last hour"
    echo "   [ ] Backup created today"
    echo "   [ ] No ConfigInvalidError in logs"
    echo ""
}

# Main workflow
case "${1:-status}" in
    start)
        echo "🏁 Starting OpenCode Work Session"
        echo ""
        
        # Check prerequisites
        check_opencode_running
        check_backup_status
        
        # Offer to create backup
        read -p "Create backup before starting? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ./scripts/backup-opencode-sessions.sh
        fi
        
        echo ""
        echo -e "${GREEN}✓ Ready to start work!${NC}"
        echo ""
        echo "💡 Remember:"
        echo "   • Commit every 30-60 minutes"
        echo "   • Run 'workflow status' to check health"
        echo "   • Close all other OpenCode instances"
        ;;
        
    status)
        echo "📊 Current Status Check"
        echo ""
        check_opencode_running
        check_memory_usage
        check_last_commit
        check_backup_status
        show_checklist
        ;;
        
    commit)
        echo "📝 Smart Commit Helper"
        echo ""
        
        if [ ! -d .git ]; then
            echo -e "${RED}❌ Not a git repository${NC}"
            exit 1
        fi
        
        # Check if there are changes
        if git diff --quiet && git diff --cached --quiet; then
            echo -e "${YELLOW}ℹ No changes to commit${NC}"
            exit 0
        fi
        
        # Show status
        echo "Changed files:"
        git status --short
        echo ""
        
        # Interactive commit
        read -p "Commit message: " -r COMMIT_MSG
        
        if [ -z "$COMMIT_MSG" ]; then
            echo -e "${RED}❌ Commit message required${NC}"
            exit 1
        fi
        
        git add -A
        git commit -m "$COMMIT_MSG"
        
        echo -e "${GREEN}✓ Committed successfully${NC}"
        echo "💡 Last commit: $(git log -1 --oneline)"
        ;;
        
    backup)
        ./scripts/backup-opencode-sessions.sh
        ;;
        
    health)
        echo "🏥 Health Check"
        echo ""
        
        ISSUES=0
        
        # Check multiple instances
        OPENCODE_COUNT=$(ps aux | grep -i "opencode --port" | grep -v grep | wc -l)
        if [ "$OPENCODE_COUNT" -gt 1 ]; then
            echo -e "${RED}❌ Multiple OpenCode instances running${NC}"
            ISSUES=$((ISSUES + 1))
        else
            echo -e "${GREEN}✓ Instance count OK${NC}"
        fi
        
        # Check memory
        MAX_MEM=0
        OPENCODE_PIDS=$(ps aux | grep -i "opencode --port" | grep -v grep | awk '{print $2}')
        for PID in $OPENCODE_PIDS; do
            MEM_MB=$(ps -o rss= -p $PID 2>/dev/null | awk '{print int($1/1024)}')
            if [ "$MEM_MB" -gt "$MAX_MEM" ]; then
                MAX_MEM=$MEM_MB
            fi
        done
        
        if [ "$MAX_MEM" -gt 4096 ]; then
            echo -e "${RED}❌ Memory usage high: ${MAX_MEM}MB${NC}"
            ISSUES=$((ISSUES + 1))
        else
            echo -e "${GREEN}✓ Memory usage OK: ${MAX_MEM}MB${NC}"
        fi
        
        # Check last commit
        if [ -d .git ]; then
            MINUTES_AGO=$(git log -1 --format="%ct" 2>/dev/null)
            CURRENT_TIME=$(date +%s)
            DIFF_MINUTES=$(( ($CURRENT_TIME - $MINUTES_AGO) / 60 ))
            
            if [ "$DIFF_MINUTES" -gt 60 ]; then
                echo -e "${YELLOW}⚠️  No commit in last hour${NC}"
                ISSUES=$((ISSUES + 1))
            else
                echo -e "${GREEN}✓ Recent commit${NC}"
            fi
        fi
        
        # Check VSCode config
        ARGV_FILE="$HOME/Library/Application Support/Code/User/argv.json"
        if [ -f "$ARGV_FILE" ]; then
            if grep -q "max-old-space-size" "$ARGV_FILE"; then
                echo -e "${GREEN}✓ VSCode memory configured${NC}"
            else
                echo -e "${YELLOW}⚠️  VSCode memory not configured${NC}"
                ISSUES=$((ISSUES + 1))
            fi
        else
            echo -e "${YELLOW}⚠️  VSCode argv.json not found${NC}"
            ISSUES=$((ISSUES + 1))
        fi
        
        echo ""
        if [ "$ISSUES" -eq 0 ]; then
            echo -e "${GREEN}✅ All checks passed!${NC}"
        else
            echo -e "${YELLOW}⚠️  Found $ISSUES issues${NC}"
            echo "   Run: workflow status (for details)"
        fi
        ;;
        
    *)
        echo "Usage: workflow [command]"
        echo ""
        echo "Commands:"
        echo "  start   - Start work session (with backup prompt)"
        echo "  status  - Show detailed status and checklist"
        echo "  commit  - Smart commit helper"
        echo "  backup  - Create backup"
        echo "  health  - Quick health check"
        echo ""
        echo "Examples:"
        echo "  workflow start     # Begin work session"
        echo "  workflow status    # Check current state"
        echo "  workflow commit    # Interactive commit"
        echo "  workflow health    # Quick diagnostic"
        ;;
esac
