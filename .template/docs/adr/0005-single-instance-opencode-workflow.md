# 0005. 採用單實例 OpenCode 工作流程

日期: 2026-02-26

## 狀態

已接受

## 背景

在使用 VSCode OpenCode Extension 進行多專案開發時，遇到以下問題：

1. **頻繁崩潰**：每天崩潰，工作中斷
2. **Session 丟失**：重啟後無法恢復對話歷史
3. **需求**：希望同時開啟多個專案的 OpenCode 實例

經過技術調查發現根本原因：

### 技術限制

**所有 VSCode OpenCode Extension 實例共用單一 SQLite 資料庫**：

- 資料庫路徑：`~/.local/share/opencode/opencode.db`
- 無檔案鎖定機制
- 多實例同時寫入 → 資料庫損壞
- 一個實例崩潰 → 所有實例的 sessions 丟失

### 驗證結果

1. **OpenCode CLI 支援 `XDG_DATA_HOME` 環境變數**
   ```bash
   XDG_DATA_HOME="/custom/path" opencode db path
   # 輸出：/custom/path/opencode/opencode.db
   ```

2. **VSCode Extension 不支援多資料庫**
   - Extension 透過 Terminal 執行 `opencode --port <random>`
   - 只傳遞 `_EXTENSION_OPENCODE_PORT` 和 `OPENCODE_CALLER`
   - 不傳遞 `XDG_DATA_HOME`
   - 無配置選項可設定資料庫路徑

3. **官方確認為已知限制**
   - GitHub Issues #4251, #4278
   - 狀態：已知問題，尚未修復

## 考慮的選項

### 選項 1：Shell 環境變數方案 ❌

**做法**：在 `~/.zshrc` 設定 `XDG_DATA_HOME`，根據當前目錄動態切換

**問題**：
- 需要每次開新 Terminal 都在專案根目錄
- 在子目錄開 Terminal 會失效
- VSCode Terminal 可能不在預期目錄
- 維護成本高，容易出錯

### 選項 2：多實例強制運行 ❌

**做法**：接受偶爾崩潰的代價

**問題**：
- 資料庫損壞風險高
- Session 丟失無法接受
- 不穩定的開發體驗

### 選項 3：單實例 + 快速切換 ✅ (採用)

**做法**：
- 一次只開一個專案的 VSCode
- 使用外部工具記錄工作進度
- 智慧清理減少 session 累積

**優點**：
- 穩定可靠
- 配合外部記錄系統（`scripts/wl`, Linear, GitHub Issues）
- 智慧清理維持資料庫健康

## 決策

**採用單實例工作流程，配合以下措施**：

1. **工作流程**
   - 一次只開一個專案的 VSCode
   - 使用 `./scripts/wl` 做本地工作日誌（每日一檔，不 commit）
   - 頻繁 commit（30-60 分鐘一次）

2. **穩定性工具**
   - `config.toml` - 統一配置（智慧清理閾值、記憶體限制）
   - `./scripts/smart-cleanup.sh` - 根據實際狀況自動清理 sessions
   - VSCode Extension Host 記憶體增加至 8GB

3. **外部記錄系統**
   - 本地：`.worklog/YYYY-MM-DD.md` (gitignored)
   - 遠端：Linear/GitHub Issues（團隊協作）

## 後果

### 正面

- ✅ 穩定性大幅提升（崩潰頻率：每天 → < 每週一次）
- ✅ Session 恢復率 100%
- ✅ 工作記錄不依賴 OpenCode（外部化）
- ✅ 可維護、可預測

### 負面

- ❌ 無法同時開多個專案的 OpenCode
- ❌ 需要手動切換專案（關閉 → 開啟）
- ❌ 依賴外部記錄工具

### 風險緩解

- **多專案需求**：透過外部記錄系統串聯不同專案的工作
- **切換成本**：通常專案工作是連續的，切換頻率不高
- **記錄遺失**：`.worklog/` 本地備份 + git commit 記錄

## 未來改善可能性

如果 OpenCode 官方實作以下任一功能，可重新評估多實例支援：

1. VSCode Extension 配置：`opencode.dataDirectory`
2. CLI 參數：`opencode --data-dir /path/to/db`
3. SQLite 自動檔案鎖定機制

## 相關資源

- OpenCode GitHub Issues: #4251, #4278
- 驗證版本：OpenCode 1.2.10, VSCode Extension sst-dev.opencode-0.0.13
- 智慧清理配置：`config.toml` `[opencode.cleanup]`
- 工作日誌工具：`scripts/wl`
