#!/bin/bash
# SSH Log Parser - scans auth.log for failed SSH logins,
# counts attempts per IP, flags any IP with >= THRESHOLD failures.
# Author: Nicolas Hoyos | Runs on VM2

LOGFILE="/var/log/auth.log"                    # source log we read from
OUTPUTFILE="/var/log/ssh_parser_report.log"    # where we save the report
THRESHOLD=5                                     # failures before an IP is flagged
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')          # current date/time for the report

echo "============================="
echo "SSH Failed Login Report"
echo "Generated: $TIMESTAMP"
echo "============================="
echo "All failed login attempts by IP:"
grep "Failed password" "$LOGFILE" | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort | uniq -c | sort -nr
echo "Suspicious IPs (>= $THRESHOLD failed attempts):"
grep "Failed password" "$LOGFILE" | grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort | uniq -c | sort -nr | while read count ip; do
    if [ "$count" -ge "$THRESHOLD" ]; then
        echo "[SUSPICIOUS] IP $ip had $count failed attempts"
    fi
done
