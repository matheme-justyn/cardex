#!/bin/bash
# OpenCode Stability Fix Script
# Fixes memory limits, creates recovery tools, and sets up best practices
# 
# Usage: ./scripts/fix-opencode-stability.sh

set -e

echo "🔧 OpenCode Stability Fix Script"
echo "================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Check system RAM
echo "📊 Step 1: Checking system RAM..."
TOTAL_RAM_GB=$(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024)}')
echo "   Total RAM: ${TOTAL_RAM_GB}GB"

# Recommend memory allocation based on available RAM
if [ "$TOTAL_RAM_GB" -ge 32 ]; then
    RECOMMENDED_MB=8192
    echo -e "   ${GREEN}✓ Excellent! Recommending 8GB for Extension Host${NC}"
elif [ "$TOTAL_RAM_GB" -ge 16 ]; then
    RECOMMENDED_MB=6144
    echo -e "   ${GREEN}✓ Good! Recommending 6GB for Extension Host${NC}"
elif [ "$TOTAL_RAM_GB" -ge 8 ]; then
    RECOMMENDED_MB=4096
    echo -e "   ${YELLOW}⚠ OK. Recommending 4GB for Extension Host${NC}"
else
    RECOMMENDED_MB=2048
    echo -e "   ${RED}⚠ Low RAM! Recommending 2GB for Extension Host${NC}"
    echo -e "   ${RED}  Consider upgrading RAM or limiting OpenCode usage${NC}"
fi

echo ""

# 2. Configure VSCode argv.json
echo "🛠️  Step 2: Configuring VSCode Extension Host memory..."
VSCODE_ARGV_PATH="$HOME/Library/Application Support/Code/User/argv.json"
VSCODE_ARGV_DIR=$(dirname "$VSCODE_ARGV_PATH")

# Create directory if it doesn't exist
mkdir -p "$VSCODE_ARGV_DIR"

# Check if argv.json exists
if [ -f "$VSCODE_ARGV_PATH" ]; then
    echo "   Found existing argv.json"
    # Backup
    cp "$VSCODE_ARGV_PATH" "$VSCODE_ARGV_PATH.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "   ${GREEN}✓ Backed up to argv.json.backup${NC}"
fi

# Create new argv.json with increased memory
cat > "$VSCODE_ARGV_PATH" << EOF
{
    "disable-hardware-acceleration": false,
    "enable-crash-reporter": true,
    "crash-reporter-id": "$(uuidgen)",
    "js-flags": "--max-old-space-size=${RECOMMENDED_MB}"
}
EOF

echo -e "   ${GREEN}✓ VSCode configured with ${RECOMMENDED_MB}MB heap size${NC}"
echo "   Location: $VSCODE_ARGV_PATH"
echo ""

# 3. Create .opencodeignore
echo "📝 Step 3: Creating .opencodeignore to reduce context..."
IGNORE_FILE="$(pwd)/.opencodeignore"

cat > "$IGNORE_FILE" << 'EOF'
# OpenCode Ignore File
# Reduces memory footprint by excluding large/unnecessary files

# Dependencies (CRITICAL - these can be 100MB+)
node_modules/
.pnpm-store/
vendor/
bower_components/
jspm_packages/

# Lock Files (SILENT KILLERS - 50k+ lines in monorepos)
package-lock.json
pnpm-lock.yaml
yarn.lock
bun.lockb
Cargo.lock
Gemfile.lock
Pipfile.lock
poetry.lock
composer.lock

# Build Outputs
dist/
build/
out/
.next/
.nuxt/
target/
*.min.js
*.min.css

# Coverage & Test Reports
coverage/
.nyc_output/
__snapshots__/
test-results/

# Documentation & Static Assets
docs/
documentation/
public/
assets/
static/
*.pdf
*.svg
*.png
*.jpg
*.jpeg
*.gif
*.ico
*.woff
*.woff2
*.ttf
*.eot

# System & IDE
.DS_Store
.vscode/
.idea/
.git/
.svn/
.hg/

# Logs
*.log
logs/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Temporary
tmp/
temp/
*.tmp
*.swp
*.swo
*~

# i18n (if project has many locales)
# locales/
# i18n/messages/
EOF

echo -e "   ${GREEN}✓ Created .opencodeignore${NC}"
echo "   Location: $IGNORE_FILE"
echo ""

# 4. Verify opencode.json is valid
echo "🔍 Step 4: Verifying opencode.json..."
OPENCODE_JSON="$(pwd)/opencode.json"

if [ ! -f "$OPENCODE_JSON" ]; then
    echo -e "   ${YELLOW}⚠ No opencode.json found${NC}"
else
    if python3 -m json.tool "$OPENCODE_JSON" > /dev/null 2>&1; then
        echo -e "   ${GREEN}✓ opencode.json is valid JSON${NC}"
        
        # Check for required stability configs
        if grep -q '"share"' "$OPENCODE_JSON"; then
            echo -e "   ${GREEN}✓ Share enabled for recovery${NC}"
        else
            echo -e "   ${YELLOW}⚠ Consider adding: \"share\": \"auto\"${NC}"
        fi
        
        if grep -q '"compaction"' "$OPENCODE_JSON"; then
            echo -e "   ${GREEN}✓ Compaction configured${NC}"
        else
            echo -e "   ${YELLOW}⚠ Consider adding compaction settings${NC}"
        fi
    else
        echo -e "   ${RED}✗ opencode.json has syntax errors!${NC}"
        python3 -m json.tool "$OPENCODE_JSON" 2>&1 | head -5
        exit 1
    fi
fi

echo ""

# 5. Create session recovery tool
echo "🔧 Step 5: Creating session recovery tool..."
RECOVERY_SCRIPT="$(pwd)/scripts/recover-opencode-sessions.sh"

cat > "$RECOVERY_SCRIPT" << 'EOF'
#!/bin/bash
# OpenCode Session Recovery Tool

OPENCODE_DIR="$HOME/.local/share/opencode"
DB_FILE="$OPENCODE_DIR/opencode.db"

echo "🔍 OpenCode Session Recovery"
echo "============================"
echo ""

# Check if database exists
if [ ! -f "$DB_FILE" ]; then
    echo "❌ Database not found: $DB_FILE"
    exit 1
fi

# Check database integrity
echo "Checking database integrity..."
INTEGRITY=$(sqlite3 "$DB_FILE" "PRAGMA integrity_check;" 2>&1)
if [ "$INTEGRITY" = "ok" ]; then
    echo "✅ Database integrity: OK"
else
    echo "❌ Database corrupted!"
    echo "$INTEGRITY"
    echo ""
    echo "💡 Recovery options:"
    echo "   1. Restore from backup: ~/.local/share/opencode/opencode.db.backup"
    echo "   2. Contact support with log files"
    exit 1
fi

echo ""

# List sessions
echo "📋 Available Sessions:"
sqlite3 "$DB_FILE" "
SELECT 
    id,
    title,
    datetime(time_created/1000, 'unixepoch', 'localtime') as created,
    datetime(time_updated/1000, 'unixepoch', 'localtime') as updated,
    CASE WHEN time_archived IS NULL THEN 'Active' ELSE 'Archived' END as status
FROM session 
WHERE time_archived IS NULL
ORDER BY time_updated DESC 
LIMIT 20;
" 2>&1

echo ""
echo "💡 Total sessions: $(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM session WHERE time_archived IS NULL;")"
echo ""
echo "🔍 Check logs for crash details:"
echo "   ls -lht ~/.local/share/opencode/log/ | head -5"
EOF

chmod +x "$RECOVERY_SCRIPT"
echo -e "   ${GREEN}✓ Created recovery tool${NC}"
echo "   Location: $RECOVERY_SCRIPT"
echo "   Usage: $RECOVERY_SCRIPT"
echo ""

# 6. Create pre-crash backup script
echo "💾 Step 6: Creating automatic backup script..."
BACKUP_SCRIPT="$(pwd)/scripts/backup-opencode-sessions.sh"

cat > "$BACKUP_SCRIPT" << 'EOF'
#!/bin/bash
# OpenCode Session Backup
# Run this before starting complex work

OPENCODE_DIR="$HOME/.local/share/opencode"
BACKUP_DIR="$HOME/.local/share/opencode-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

echo "💾 Backing up OpenCode sessions..."

# Backup database
if [ -f "$OPENCODE_DIR/opencode.db" ]; then
    cp "$OPENCODE_DIR/opencode.db" "$BACKUP_DIR/opencode.db.$TIMESTAMP"
    echo "✅ Database backed up"
fi

# Backup storage
if [ -d "$OPENCODE_DIR/storage" ]; then
    tar -czf "$BACKUP_DIR/storage.$TIMESTAMP.tar.gz" -C "$OPENCODE_DIR" storage
    echo "✅ Storage backed up"
fi

# Keep only last 5 backups
cd "$BACKUP_DIR"
ls -t opencode.db.* | tail -n +6 | xargs rm -f 2>/dev/null || true
ls -t storage.*.tar.gz | tail -n +6 | xargs rm -f 2>/dev/null || true

echo "✅ Backup complete: $BACKUP_DIR"
echo "💡 To restore: cp $BACKUP_DIR/opencode.db.$TIMESTAMP ~/.local/share/opencode/opencode.db"
EOF

chmod +x "$BACKUP_SCRIPT"
echo -e "   ${GREEN}✓ Created backup script${NC}"
echo "   Location: $BACKUP_SCRIPT"
echo "   Usage: Run before complex work: $BACKUP_SCRIPT"
echo ""

# 7. Summary and next steps
echo "✅ Installation Complete!"
echo "======================="
echo ""
echo -e "${GREEN}What was fixed:${NC}"
echo "  ✓ VSCode memory limit increased to ${RECOMMENDED_MB}MB"
echo "  ✓ .opencodeignore created (reduces memory usage)"
echo "  ✓ opencode.json verified"
echo "  ✓ Recovery tools installed"
echo ""
echo -e "${YELLOW}⚠ REQUIRED: Restart VSCode for memory changes to take effect${NC}"
echo ""
echo -e "${BLUE}🔧 New Tools Available:${NC}"
echo "  • Recovery: $RECOVERY_SCRIPT"
echo "  • Backup: $BACKUP_SCRIPT"
echo ""
echo -e "${BLUE}📖 Best Practices:${NC}"
echo "  1. Close all VSCode windows"
echo "  2. Reopen VSCode (new memory limit will apply)"
echo "  3. Run ONE OpenCode instance per VSCode workspace"
echo "  4. Before complex work: run backup script"
echo "  5. Commit frequently (git commits = checkpoints)"
echo ""
echo -e "${YELLOW}⚠ Multi-Instance Warning:${NC}"
echo "  Running multiple OpenCode instances simultaneously is risky due to"
echo "  shared database architecture. Consider working on one project at a time."
echo ""
echo "For more info, see: docs/OPENCODE_STABILITY.md"
