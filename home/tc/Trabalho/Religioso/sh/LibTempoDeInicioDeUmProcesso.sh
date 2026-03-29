#!/bin/sh

if [ -n "$1" ]; then
	awk -v ticks="$(getconf CLK_TCK)" -v epoch="$(date +%s)" 'NR==1 { now=$1; next }  END { printf "%9.0f\n", epoch - (now-($20/ticks)) }' /proc/uptime RS=')' /proc/${1}/stat | xargs -i date -d @{} +%s
else
	echo "$0 \"Número do processo à ser descoberto o tempo de início dele.\""
fi
