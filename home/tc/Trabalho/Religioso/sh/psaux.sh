#!/bin/sh

echo "content-type: text/plain"
echo ""

principal(){
	if [ -z "$1" ]; then
		clear
	fi
	busybox ps aux -o ppid,pid,tty,args | sed -r 's/^([ ]{0,5})([0-9]{1,15})([ ]{1,5})([0-9]{1,15})/\2 \4/g'
}

principal "$1"
exit 0
