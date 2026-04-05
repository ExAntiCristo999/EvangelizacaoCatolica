if [ "$USER" = "tc" ]; then
	tce-load -ilw Xfbdev flwm_topside Xlibs Xprogs pcre
	if [ -d "/tmp/tcloop/flwm_topside" ]; then
		startx	
	fi
fi
