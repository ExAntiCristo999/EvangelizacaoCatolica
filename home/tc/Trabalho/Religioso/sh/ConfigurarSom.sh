#!/bin/sh

if [ "$USER" = "tc" ]; then
	tce-load -iwl alsa alsa-config
	if [ -d "/tmp/tcloop/alsa-config" ]; then
		amixer sset 'Headphone' on
		amixer sset 'Headphone' 50%
		amixer sset 'Headphone+LO' on
		amixer sset 'Headphone+LO' 50%
		amixer sset 'Master' on
		amixer sset 'Master' 100%
	else
		echo "Alsa não foi baixado e instalado."
	fi
fi
