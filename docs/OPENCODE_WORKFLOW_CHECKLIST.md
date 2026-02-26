# OpenCode Best Practices Checklist

## 🌅 開始工作前 (Before Starting Work)

```bash
# Run the workflow helper
./scripts/opencode-workflow.sh start
```

**Manual Checklist:**
- [ ] 確認只有一個 OpenCode 實例在運行
- [ ] 確認 VSCode 已經重啟（第一次設定後）
- [ ] 檢查 `opencode.json` 沒有語法錯誤
- [ ] 如果要做複雜工作，先執行備份

---

## 💼 工作中 (During Work)

### 每 30-60 分鐘

```bash
# Quick health check
./scripts/opencode-workflow.sh health

# Commit your work
./scripts/opencode-workflow.sh commit
```

**Manual Checklist:**
- [ ] 記憶體使用 < 4GB（Activity Monitor / `top`）
- [ ] 定期 commit（30-60 分鐘）
- [ ] 注意 OpenCode 反應速度（變慢 = 記憶體不足）
- [ ] 使用 `/share` 建立重要 session 的恢復 URL

### 記憶體管理

如果記憶體 > 4GB：
```
# In OpenCode chat
/clear
```

如果記憶體 > 6GB：
- 考慮結束當前 session
- Commit 所有工作
- 重啟 OpenCode

---

## 🌙 結束工作時 (End of Work Session)

```bash
# Final commit
git add -A
git commit -m "chore: end of work session"

# Status check
./scripts/opencode-workflow.sh status

# Optional: backup if you did complex work
./scripts/backup-opencode-sessions.sh
```

**Manual Checklist:**
- [ ] 所有工作已 commit
- [ ] 檢查沒有未保存的檔案
- [ ] 如果做了重要工作，建立備份
- [ ] 記錄任何遇到的問題

---

## 🚨 發生崩潰時 (After a Crash)

### 立即行動

1. **不要慌張** - 資料庫可能完好
2. **檢查 session 狀態**:
   ```bash
   ./scripts/recover-opencode-sessions.sh
   ```

3. **查看崩潰日誌**:
   ```bash
   tail -100 ~/.local/share/opencode/log/*.log | grep -i error
   ```

4. **如果 sessions 消失**:
   ```bash
   # List available backups
   ls -lht ~/.local/share/opencode-backups/
   
   # Restore from backup
   cp ~/.local/share/opencode-backups/opencode.db.<timestamp> \
      ~/.local/share/opencode/opencode.db
   ```

### 崩潰後恢復

- [ ] 確認資料庫完整性（recovery script 會檢查）
- [ ] 檢查最後一次 git commit 的時間
- [ ] 如果有未 commit 的工作，檢查 git status
- [ ] 記錄崩潰時間和正在做的事情（幫助診斷）
- [ ] 如果頻繁崩潰，檢查 VSCode 記憶體配置

---

## 📊 每週檢查 (Weekly Review)

### 穩定性指標

```bash
# Check crash frequency
grep -i "error.*crash\|ConfigInvalidError" \
  ~/.local/share/opencode/log/*.log | wc -l

# Check session count growth
sqlite3 ~/.local/share/opencode/opencode.db \
  "SELECT COUNT(*) FROM session WHERE time_archived IS NULL;"

# Check backup count
ls ~/.local/share/opencode-backups/ | wc -l
```

**Review Questions:**
- [ ] 本週崩潰次數？（目標：< 1 次）
- [ ] Session 恢復成功率？（目標：100%）
- [ ] 平均連續工作時間？（目標：> 4 小時）
- [ ] 是否遵守「一次一個實例」？
- [ ] Commit 頻率是否足夠？

### 優化建議

如果本週：
- **沒有崩潰** → ✅ 繼續保持！
- **崩潰 1-2 次** → 檢查是否在記憶體高峰時
- **崩潰 > 3 次** → 需要進一步診斷

---

## 🛠️ 快速命令參考

```bash
# Start work session
./scripts/opencode-workflow.sh start

# Check status
./scripts/opencode-workflow.sh status

# Quick health check
./scripts/opencode-workflow.sh health

# Smart commit
./scripts/opencode-workflow.sh commit

# Create backup
./scripts/backup-opencode-sessions.sh

# Recover sessions
./scripts/recover-opencode-sessions.sh

# Check memory
ps aux | grep opencode | awk '{print $3, $4, $11}'

# Check running instances
ps aux | grep -i "opencode --port" | grep -v grep
```

---

## 📝 建議的 Commit Message 格式

遵循 AGENTS.md 規範：

```
type: brief description

Examples:
feat: add new API endpoint
fix: resolve memory leak in parser
docs: update installation guide
refactor: simplify error handling
test: add unit tests for auth
chore: update dependencies
```

---

## 🎯 成功的一天看起來像這樣

```
09:00 - workflow start (備份)
09:00-10:00 - 工作 + 記憶體檢查
10:00 - commit checkpoint 1
10:00-11:30 - 工作
11:30 - commit checkpoint 2
12:00-13:00 - 午餐（關閉 OpenCode）
13:00 - workflow start (重新開啟)
13:00-15:00 - 工作
15:00 - commit checkpoint 3
15:00-17:00 - 工作
17:00 - final commit + backup
```

**關鍵特徵：**
- ✅ 定期 commit（2小時內）
- ✅ 記憶體監控
- ✅ 休息時關閉 OpenCode
- ✅ 只有一個實例
- ✅ 重要工作前/後備份

---

## ❓ 疑難排解 (Troubleshooting)

### Q: 執行 workflow script 時出現 "command not found"
A: 確保在專案根目錄執行，或使用完整路徑

### Q: Git hook 沒有執行
A: 檢查 `.git/hooks/post-commit` 是否有執行權限
   ```bash
   chmod +x .git/hooks/post-commit
   ```

### Q: 備份失敗
A: 確認 `~/.local/share/opencode/` 存在且有讀取權限

### Q: 記憶體檢查顯示 "No OpenCode process found"
A: 正常，表示目前沒有 OpenCode 在運行

---

## 📚 相關文件

- 完整穩定性指南: `docs/OPENCODE_STABILITY.md`
- 編碼規範: `AGENTS.md`
- 腳本說明:
  - `scripts/fix-opencode-stability.sh` - 初始設定
  - `scripts/opencode-workflow.sh` - 日常工作流程
  - `scripts/backup-opencode-sessions.sh` - 備份工具
  - `scripts/recover-opencode-sessions.sh` - 恢復工具
