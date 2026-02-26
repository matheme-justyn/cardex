#!/bin/bash
# OpenCode 7-Day Stability Monitor
# Tracks crash frequency and session recovery success

MONITOR_FILE="$HOME/.opencode-stability-monitor.json"
TODAY=$(date +%Y-%m-%d)

# Initialize monitor file if it doesn't exist
if [ ! -f "$MONITOR_FILE" ]; then
    cat > "$MONITOR_FILE" << EOF
{
  "start_date": "$TODAY",
  "days": []
}
EOF
fi

# Function to add today's report
add_daily_report() {
    echo "📊 OpenCode Stability - Daily Report"
    echo "===================================="
    echo ""
    echo "Date: $TODAY"
    echo ""
    
    # Count crashes
    CRASH_COUNT=$(grep -i "error.*crash\|ConfigInvalidError\|failed" \
      ~/.local/share/opencode/log/*.log 2>/dev/null | \
      grep $(date +%Y-%m-%d) | wc -l)
    
    echo "1. Did OpenCode crash today? (y/n)"
    read -r CRASHED
    
    if [[ "$CRASHED" =~ ^[Yy]$ ]]; then
        echo "   How many times?"
        read -r CRASH_TIMES
        
        echo "   Could you recover your sessions? (y/n)"
        read -r RECOVERED
        
        echo "   What were you doing when it crashed?"
        read -r ACTIVITY
    else
        CRASH_TIMES=0
        RECOVERED="y"
        ACTIVITY="N/A"
    fi
    
    echo ""
    echo "2. Longest continuous work session (hours):"
    read -r MAX_SESSION
    
    echo ""
    echo "3. Did you follow best practices?"
    echo "   - One OpenCode instance only? (y/n)"
    read -r ONE_INSTANCE
    
    echo "   - Committed every 30-60 min? (y/n)"
    read -r FREQUENT_COMMIT
    
    echo "   - Memory stayed under 4GB? (y/n)"
    read -r LOW_MEMORY
    
    echo ""
    echo "4. Any issues or notes?"
    read -r NOTES
    
    # Calculate score
    SCORE=0
    [[ "$CRASH_TIMES" -eq 0 ]] && SCORE=$((SCORE + 25))
    [[ "$RECOVERED" =~ ^[Yy]$ ]] && SCORE=$((SCORE + 25))
    [[ "$ONE_INSTANCE" =~ ^[Yy]$ ]] && SCORE=$((SCORE + 15))
    [[ "$FREQUENT_COMMIT" =~ ^[Yy]$ ]] && SCORE=$((SCORE + 15))
    [[ "$LOW_MEMORY" =~ ^[Yy]$ ]] && SCORE=$((SCORE + 20))
    
    # Save to JSON (append to days array)
    python3 << PYTHON_SCRIPT
import json
import sys
from datetime import datetime

try:
    with open("$MONITOR_FILE", "r") as f:
        data = json.load(f)
except:
    data = {"start_date": "$TODAY", "days": []}

# Remove today if it already exists (updating)
data["days"] = [d for d in data.get("days", []) if d.get("date") != "$TODAY"]

# Add today's report
report = {
    "date": "$TODAY",
    "crashed": "$CRASHED" == "y",
    "crash_times": int("$CRASH_TIMES" or 0),
    "recovered": "$RECOVERED" == "y",
    "activity": "$ACTIVITY",
    "max_session_hours": float("$MAX_SESSION" or 0),
    "one_instance": "$ONE_INSTANCE" == "y",
    "frequent_commit": "$FREQUENT_COMMIT" == "y",
    "low_memory": "$LOW_MEMORY" == "y",
    "notes": "$NOTES",
    "score": $SCORE
}

data["days"].append(report)

with open("$MONITOR_FILE", "w") as f:
    json.dump(data, f, indent=2)

print(f"\n✅ Report saved. Score: $SCORE/100")
PYTHON_SCRIPT
    
    echo ""
    echo "💡 Run 'monitor-stability.sh summary' to see 7-day summary"
}

# Function to show summary
show_summary() {
    if [ ! -f "$MONITOR_FILE" ]; then
        echo "❌ No monitoring data found. Run 'monitor-stability.sh report' first."
        exit 1
    fi
    
    python3 << PYTHON_SCRIPT
import json
from datetime import datetime, timedelta
from collections import Counter

with open("$MONITOR_FILE", "r") as f:
    data = json.load(f)

days = data.get("days", [])

if not days:
    print("❌ No reports yet. Run 'monitor-stability.sh report' to add daily reports.")
    exit(0)

print("📊 OpenCode Stability - 7 Day Summary")
print("=" * 50)
print()

# Calculate metrics
total_days = len(days)
crash_days = sum(1 for d in days if d.get("crashed", False))
total_crashes = sum(d.get("crash_times", 0) for d in days)
recovery_success = sum(1 for d in days if d.get("crashed") and d.get("recovered"))
crash_days_actual = sum(1 for d in days if d.get("crash_times", 0) > 0)

print(f"📅 Monitoring Period: {total_days} days")
print(f"   Start: {days[0]['date']}")
print(f"   Latest: {days[-1]['date']}")
print()

print("🚨 Crash Statistics:")
print(f"   Days with crashes: {crash_days_actual}/{total_days}")
print(f"   Total crashes: {total_crashes}")
if crash_days_actual > 0:
    print(f"   Recovery success: {recovery_success}/{crash_days_actual} ({recovery_success*100//crash_days_actual if crash_days_actual else 0}%)")
print()

print("⏱️  Session Duration:")
max_sessions = [d.get("max_session_hours", 0) for d in days if d.get("max_session_hours")]
if max_sessions:
    print(f"   Average: {sum(max_sessions)/len(max_sessions):.1f} hours")
    print(f"   Longest: {max(max_sessions):.1f} hours")
print()

print("✅ Best Practices Adherence:")
one_instance_days = sum(1 for d in days if d.get("one_instance"))
frequent_commit_days = sum(1 for d in days if d.get("frequent_commit"))
low_memory_days = sum(1 for d in days if d.get("low_memory"))

print(f"   One instance only: {one_instance_days}/{total_days} days ({one_instance_days*100//total_days}%)")
print(f"   Frequent commits: {frequent_commit_days}/{total_days} days ({frequent_commit_days*100//total_days}%)")
print(f"   Memory under 4GB: {low_memory_days}/{total_days} days ({low_memory_days*100//total_days}%)")
print()

print("📈 Daily Scores:")
for day in days:
    status = "✅" if day.get("score", 0) >= 80 else "⚠️" if day.get("score", 0) >= 60 else "❌"
    crashes = f"({day.get('crash_times', 0)} crashes)" if day.get("crashed") else ""
    print(f"   {day['date']}: {status} {day.get('score', 0)}/100 {crashes}")
print()

avg_score = sum(d.get("score", 0) for d in days) / len(days)
print(f"📊 Average Score: {avg_score:.1f}/100")
print()

# Recommendations
print("💡 Recommendations:")
if crash_days_actual > 0:
    print(f"   ⚠️  Experienced {crash_days_actual} crash day(s)")
    if recovery_success < crash_days_actual:
        print("   🔴 Session recovery needs improvement - ensure backups are working")
    
if one_instance_days < total_days:
    print("   ⚠️  Multiple instances detected - stick to ONE instance per session")

if frequent_commit_days < total_days * 0.8:
    print("   ⚠️  Commit more frequently - aim for every 30-60 minutes")

if low_memory_days < total_days * 0.8:
    print("   ⚠️  Memory usage high - use /clear more often")

if crash_days_actual == 0 and avg_score >= 80:
    print("   ✅ Excellent! Keep up the good work!")
    print("   ✅ Your workflow changes are working well")

print()
print("📝 Next Steps:")
if total_days < 7:
    print(f"   Continue monitoring for {7 - total_days} more day(s)")
else:
    print("   ✅ 7-day monitoring complete!")
    if crash_days_actual == 0:
        print("   🎉 Success! No crashes in 7 days - stability achieved!")
    elif crash_days_actual <= 1:
        print("   👍 Good progress! Much more stable than before")
    else:
        print("   📋 Review crash patterns and adjust workflow")

PYTHON_SCRIPT
}

# Function to show individual day
show_day() {
    DATE=$1
    if [ -z "$DATE" ]; then
        DATE=$TODAY
    fi
    
    python3 << PYTHON_SCRIPT
import json

with open("$MONITOR_FILE", "r") as f:
    data = json.load(f)

days = [d for d in data.get("days", []) if d.get("date") == "$DATE"]

if not days:
    print(f"❌ No report found for $DATE")
    exit(1)

day = days[0]

print(f"📊 Report for {day['date']}")
print("=" * 40)
print()
print(f"Crashed: {'Yes' if day.get('crashed') else 'No'}")
if day.get('crashed'):
    print(f"  Times: {day.get('crash_times', 0)}")
    print(f"  Recovered: {'Yes' if day.get('recovered') else 'No'}")
    print(f"  Activity: {day.get('activity', 'N/A')}")

print(f"\nLongest session: {day.get('max_session_hours', 0)} hours")
print(f"\nBest Practices:")
print(f"  One instance: {'✅' if day.get('one_instance') else '❌'}")
print(f"  Frequent commits: {'✅' if day.get('frequent_commit') else '❌'}")
print(f"  Memory <4GB: {'✅' if day.get('low_memory') else '❌'}")

if day.get('notes'):
    print(f"\nNotes: {day['notes']}")

print(f"\nScore: {day.get('score', 0)}/100")
PYTHON_SCRIPT
}

# Main
case "${1:-help}" in
    report)
        add_daily_report
        ;;
    summary)
        show_summary
        ;;
    day)
        show_day "${2:-}"
        ;;
    *)
        echo "OpenCode Stability Monitor"
        echo "=========================="
        echo ""
        echo "Usage: monitor-stability.sh [command]"
        echo ""
        echo "Commands:"
        echo "  report   - Add today's stability report (interactive)"
        echo "  summary  - Show 7-day summary with recommendations"
        echo "  day      - Show specific day report (defaults to today)"
        echo ""
        echo "Examples:"
        echo "  monitor-stability.sh report              # Add today's report"
        echo "  monitor-stability.sh summary             # View 7-day summary"
        echo "  monitor-stability.sh day 2026-02-26      # View specific day"
        echo ""
        echo "💡 Run 'report' daily to track stability improvements"
        ;;
esac
