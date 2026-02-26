#!/usr/bin/env bash
# 智慧清理 OpenCode sessions - 精簡版
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 載入配置解析函數
source "$SCRIPT_DIR/lib-config.sh"

# 載入 config.toml
if ! load_config "$PROJECT_ROOT/config.toml"; then
    echo "⚠️  使用預設配置" >&2
    OPENCODE_CLEANUP_MAX_SESSIONS=20
    OPENCODE_CLEANUP_KEEP_SESSIONS=15
    OPENCODE_CLEANUP_MAX_DB_SIZE_MB=50
    OPENCODE_CLEANUP_MIN_DAYS_BEFORE_ARCHIVE=7
    OPENCODE_CLEANUP_AGGRESSIVE_MODE=false
    OPENCODE_CLEANUP_AGGRESSIVE_KEEP=10
    OPENCODE_CLEANUP_AGGRESSIVE_MIN_DAYS=3
fi

OPENCODE_DB="$HOME/.local/share/opencode/opencode.db"
ARCHIVE_DIR="$HOME/.opencode-archive"

# 檢查是否需要清理
check_needed() {
    local count=$(sqlite3 "$OPENCODE_DB" "SELECT COUNT(*) FROM sessions" 2>/dev/null || echo 0)
    local size=$(du -m "$OPENCODE_DB" 2>/dev/null | cut -f1)
    
    [ "$count" -gt "${OPENCODE_CLEANUP_MAX_SESSIONS:-20}" ] && echo "sessions" && return 0
    [ "$size" -gt "${OPENCODE_CLEANUP_MAX_DB_SIZE_MB:-50}" ] && echo "size" && return 0
    
    echo "ok"
    return 1
}

# 執行清理
do_cleanup() {
    local reason=$1
    local keep=$CLEANUP_KEEP_SESSIONS
    local min_days=$CLEANUP_MIN_DAYS
    
    # 激進模式
    if [ "$CLEANUP_AGGRESSIVE" = "true" ]; then
        keep=$CLEANUP_AGGRESSIVE_KEEP
        min_days=$CLEANUP_AGGRESSIVE_DAYS
    fi
    
    mkdir -p "$ARCHIVE_DIR"
    
    echo "🧹 清理觸發: $reason"
    echo "   保留: $keep sessions | 歸檔: ${min_days}天未訪問"
    
    # 備份資料庫
    cp "$OPENCODE_DB" "$ARCHIVE_DIR/opencode-$(date +%Y%m%d-%H%M%S).db.backup"
    
    # TODO: 實際清理邏輯（需要了解 OpenCode SQLite schema）
    # sqlite3 "$OPENCODE_DB" "DELETE FROM sessions WHERE ..."
    
    echo "✅ 完成"
}

# 主流程
main() {
    if [ "${1:-}" = "--force" ]; then
        do_cleanup "manual"
        exit 0
    fi
    
    reason=$(check_needed) || {
        exit 0  # 無需清理，靜默退出
    }
    
    do_cleanup "$reason"
}

main "$@"
