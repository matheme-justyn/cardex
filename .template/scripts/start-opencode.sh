#!/usr/bin/env bash
# Start OpenCode with environment variables from .env
#
# Usage:
#   ./.template/scripts/start-opencode.sh [port]
#
# Examples:
#   ./.template/scripts/start-opencode.sh           # Default port
#   ./.template/scripts/start-opencode.sh 61179     # Custom port
#
# This script:
# 1. Loads environment variables from .env (if exists)
# 2. Starts OpenCode with MCP servers configured
# 3. MCP servers will inherit environment variables

set -e

# Get the project root directory (2 levels up from this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Default port
PORT="${1:-42991}"

# Load .env if exists
if [ -f "$PROJECT_ROOT/.env" ]; then
  echo "📦 Loading environment variables from .env..."
  # Export variables from .env (skip comments and empty lines)
  set -a
  source "$PROJECT_ROOT/.env"
  set +a
  echo "✓ Environment variables loaded"
else
  echo "⚠️  Warning: .env file not found at $PROJECT_ROOT/.env"
  echo "   GitHub MCP server may not work without GITHUB_PERSONAL_ACCESS_TOKEN"
fi

# Verify critical environment variables
if [ -z "$GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
  echo "⚠️  Warning: GITHUB_PERSONAL_ACCESS_TOKEN not set"
  echo "   GitHub MCP server will not work"
fi

# Start OpenCode
echo "🚀 Starting OpenCode on port $PORT..."
cd "$PROJECT_ROOT"
opencode --port "$PORT"
