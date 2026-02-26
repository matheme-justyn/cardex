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
