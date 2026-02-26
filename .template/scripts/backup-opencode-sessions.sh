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
