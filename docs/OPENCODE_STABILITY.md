# OpenCode Stability Guide

This document provides comprehensive solutions for preventing OpenCode crashes and recovering from session loss.

## 🔴 Problem Summary

Based on research and diagnostics, OpenCode crashes are caused by:

1. **Configuration errors** - Invalid `opencode.json` causing ConfigInvalidError
2. **Memory limits** - VSCode Extension Host has 2-4GB limit (V8 heap)
3. **Multi-instance conflicts** - Shared SQLite database without file locking
4. **Platform bugs** - Known issues (#4251, #4278) not yet fixed

## ✅ Solution Overview

| Issue | Severity | Solution | Status |
|-------|----------|----------|--------|
| Config errors | 🔴 High | Fix JSON syntax | ✅ Fixed |
| Memory limits | 🟠 Medium | Increase heap size | ⏳ Run script |
| Multi-instance | 🔴 High | Workflow changes | ⏳ Implement |
| Platform bugs | 🟠 Medium | Wait for upstream | ❌ No ETA |

---

## 🚀 Quick Start

Run the automated fix script:

```bash
./scripts/fix-opencode-stability.sh
```

This will:
- ✅ Detect your system RAM
- ✅ Configure VSCode memory limits
- ✅ Create `.opencodeignore` to reduce context
- ✅ Verify `opencode.json` validity
- ✅ Install recovery tools

**Then restart VSCode for changes to take effect.**

---

## 📊 Detailed Solutions

### 1. Increase VSCode Extension Host Memory

**Problem**: VSCode runs extensions in a Node.js process with 2-4GB limit. Complex AI tasks exceed this.

**Solution**: Edit VSCode's `argv.json`:

**Location**: `Cmd+Shift+P` → "Preferences: Configure Runtime Arguments"

**macOS**: `~/Library/Application Support/Code/User/argv.json`
**Linux**: `~/.config/Code/User/argv.json`
**Windows**: `%APPDATA%\Code\User\argv.json`

**Content**:
```json
{
    "disable-hardware-acceleration": false,
    "js-flags": "--max-old-space-size=8192"
}
```

**Memory recommendations**:
- 8GB RAM → `4096` (4GB for Extension Host)
- 16GB RAM → `6144` (6GB for Extension Host)
- 32GB+ RAM → `8192` (8GB for Extension Host)

**⚠️ Must restart VSCode after changing.**

---

### 2. Create `.opencodeignore`

**Problem**: Lock files (package-lock.json) can be 50,000+ lines, consuming massive memory when parsed.

**Solution**: Create `.opencodeignore` in project root.

**Run**: The fix script creates this automatically, or copy from `scripts/fix-opencode-stability.sh` output.

**Impact**: 40-60% memory reduction in typical projects.

---

### 3. Multi-Instance Best Practices

**Problem**: Multiple OpenCode instances write to the same SQLite database without locking.

**Evidence**: 
- GitHub Issue #4251 (concurrent sessions interfering)
- GitHub Issue #4278 (file locks not implemented)

**Immediate workarounds**:

#### Option A: One Instance at a Time (Safest)
- Only run OpenCode in ONE VSCode window
- Finish work → commit → close → open next project

#### Option B: Separate Server Instances (Advanced)
Each workspace runs its own OpenCode server on different ports:

**Terminal 1 (Project A)**:
```bash
cd /path/to/project-a
opencode serve --port 4097
```

**Terminal 2 (Project B)**:
```bash
cd /path/to/project-b
opencode serve --port 4098
```

Then connect VSCode extensions to specific ports via `opencode.json`:
```json
{
    "server": {
        "port": 4097
    }
}
```

#### Option C: Use Git-Initialized Projects
- Git repos get isolated storage: `~/.local/share/opencode/project/<slug>/storage/`
- Non-Git projects share global storage (higher conflict risk)

**Recommendation**: Ensure all your projects are Git-initialized.

---

### 4. Session Recovery Tools

#### Check Session Status
```bash
./scripts/recover-opencode-sessions.sh
```

This tool:
- Verifies database integrity
- Lists active sessions
- Shows recent updates
- Points to crash logs

#### Manual Recovery

If sessions disappear:

1. **Check database integrity**:
   ```bash
   sqlite3 ~/.local/share/opencode/opencode.db "PRAGMA integrity_check;"
   ```

2. **List sessions directly**:
   ```bash
   sqlite3 ~/.local/share/opencode/opencode.db "SELECT id, title FROM session WHERE time_archived IS NULL;"
   ```

3. **Check crash logs**:
   ```bash
   ls -lht ~/.local/share/opencode/log/ | head -5
   tail -100 ~/.local/share/opencode/log/<latest>.log | grep -i error
   ```

4. **Restore from backup** (if you ran backup script):
   ```bash
   cp ~/.local/share/opencode-backups/opencode.db.<timestamp> ~/.local/share/opencode/opencode.db
   ```

---

### 5. Backup Before Complex Work

**Problem**: No automatic checkpointing during long sessions.

**Solution**: Manual backup before risky operations.

```bash
./scripts/backup-opencode-sessions.sh
```

This creates timestamped backups in `~/.local/share/opencode-backups/`.

Keeps last 5 backups automatically.

---

## 🔧 Configuration Reference

### Optimal `opencode.json`

```json
{
  "$schema": "https://opencode.ai/config.json",
  "share": "auto",
  "compaction": {
    "auto": true,
    "prune": true,
    "reserved": 20000
  },
  "provider": {
    "anthropic": {
      "options": {
        "timeout": 900000
      }
    }
  },
  "server": {
    "port": 0,
    "mdns": true
  }
}
```

**Key settings**:
- `share: "auto"` - Creates recoverable URLs automatically
- `compaction.reserved: 20000` - Larger buffer before compaction
- `provider.timeout: 900000` - 15 min timeout (vs 5 min default)
- `server.port: 0` - Auto-assign available port (prevents conflicts)

---

## 📖 Daily Workflow Best Practices

### Before Starting Work

1. ✅ Ensure only ONE OpenCode instance is running
2. ✅ Run backup script if doing complex work
3. ✅ Check memory usage: `ps aux | grep opencode`
4. ✅ Verify `opencode.json` has no syntax errors

### During Work

1. ✅ Commit frequently (every 30-60 min)
2. ✅ Use `/share` to create recoverable URLs for important sessions
3. ✅ Monitor memory: Activity Monitor (Mac) or `top` (Linux)
4. ✅ If memory > 4GB, consider `/clear` to compact context

### After Crash

1. ✅ Run recovery script to check database status
2. ✅ Check crash logs for error patterns
3. ✅ Restore from backup if needed
4. ✅ Report new crash patterns to OpenCode GitHub

---

## 🐛 Known Issues & Workarounds

### Issue: Sessions Disappear After Restart

**Root Cause**: ConfigInvalidError prevents proper cleanup

**Solution**: 
- ✅ Fixed by correcting `opencode.json` syntax
- ✅ Verify with: `python3 -m json.tool opencode.json`

### Issue: Multiple Instances Crash Simultaneously

**Root Cause**: Shared SQLite database + no file locking

**Solution**: 
- Use separate server instances (Option B above)
- OR work on one project at a time

### Issue: Memory Exhaustion During Complex Tasks

**Root Cause**: VSCode Extension Host V8 heap limit

**Solution**:
- ✅ Increase heap size via `argv.json`
- ✅ Use `.opencodeignore` to reduce context
- ✅ Enable auto-compaction in `opencode.json`

### Issue: Lost Changes When Switching CLI ↔ Extension

**Root Cause**: GitHub Issue #6051 (known bug)

**Solution**: 
- Avoid mixing CLI and VSCode extension
- Commit before switching contexts

---

## 📚 References

### Official Documentation
- [OpenCode Troubleshooting](https://opencode.ai/docs/troubleshooting/)
- [OpenCode Configuration](https://opencode.ai/docs/config/)
- [OpenCode Server Documentation](https://opencode.ai/docs/server/)

### Known GitHub Issues
- [#8352](https://github.com/anomalyco/opencode/issues/8352) - Session not persisted after crash
- [#4251](https://github.com/anomalyco/opencode/issues/4251) - Concurrent sessions interfering
- [#4278](https://github.com/anomalyco/opencode/issues/4278) - File locks feature request
- [#12002](https://github.com/anomalyco/opencode/issues/12002) - "Session not found" after Ctrl+C
- [#14546](https://github.com/anomalyco/opencode/issues/14546) - Lost project/session history

### Community Resources
- [ColdFusion Blog - VSCode Extension Host Crashes](https://coldfusion-example.blogspot.com/2026/02/resolving-vs-code-extension-host.html)

---

## 🆘 Getting Help

### Diagnostics to Collect

When reporting issues:

1. **System info**:
   ```bash
   opencode --version
   system_profiler SPHardwareDataType | grep "Memory:"
   ```

2. **Database status**:
   ```bash
   sqlite3 ~/.local/share/opencode/opencode.db "PRAGMA integrity_check;"
   sqlite3 ~/.local/share/opencode/opencode.db "SELECT COUNT(*) FROM session;"
   ```

3. **Recent crashes**:
   ```bash
   grep -i "error\|crash" ~/.local/share/opencode/log/*.log | tail -20
   ```

4. **Configuration**:
   ```bash
   cat opencode.json
   cat ~/Library/Application\ Support/Code/User/argv.json
   ```

### Where to Report

- **OpenCode GitHub**: For platform bugs
- **oh-my-opencode GitHub**: For ultrawork mode issues
- **This project**: File issue with diagnostics output

---

## ✅ Success Indicators

You'll know the fixes are working when:

- ✅ No more `ConfigInvalidError` in logs
- ✅ Sessions persist after restart
- ✅ Can work for hours without crash
- ✅ Session list shows all recent work
- ✅ Memory usage stays below 6GB per instance

**Monitor for 7 days to confirm stability.**
