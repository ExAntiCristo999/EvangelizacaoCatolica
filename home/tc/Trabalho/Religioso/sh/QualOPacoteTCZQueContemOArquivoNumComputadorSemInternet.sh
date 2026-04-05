#!/bin/busybox ash
. /etc/init.d/tc-functions
useBusybox

TARGET="$1"
[ -z "$TARGET" ] && exit 1

TCEDIR="/etc/sysconfig/tcedir"
DB="provides.db"


awk 'BEGIN {FS="\n";RS=""} /'${TARGET}'/{print $1}' "$TCEDIR"/"$DB"
