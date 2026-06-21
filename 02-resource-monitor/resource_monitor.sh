#!/bin/bash
# Resource Monitor - logs CPU, memory, and disk usage with a timestamp.
# Author: Nicolas Hoyos | Runs on VM1

LOGFILE="/var/log/resource_usage.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
CPU_LOAD=$(cat /proc/loadavg | awk '{print $1}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $5}')

echo "$TIMESTAMP | CPU Load: $CPU_LOAD | Memory: ${MEM_USED}MB / ${MEM_TOTAL}MB | Disk: $DISK_USED" >> "$LOGFILE"
