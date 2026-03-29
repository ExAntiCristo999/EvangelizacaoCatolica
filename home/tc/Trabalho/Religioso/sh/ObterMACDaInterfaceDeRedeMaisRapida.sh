sudo ifconfig eth0 up
sudo ifconfig usb0 up
sudo ifconfig wlan0 up
Ifconfig=`ifconfig`
Ethernet=`echo "$Ifconfig" | grep "eth0" | sed -r 's/(.*ddr[ ])([^ ]{17})([ ].*)$/\2/g;s/://g'`
if [ -z "$Ethernet" ]; then
	Wifi=`echo "$Ifconfig" | grep "wlan0" | sed -r 's/(.*ddr[ ])([^ ]{17})([ ].*)$/\2/g;s/://g'`
	if [ -n "$Wifi" ]; then
		echo "$Wifi"
	else
		USB=`echo "$Ifconfig" | grep "usb0" | sed -r 's/(.*ddr[ ])([^ ]{17})([ ].*)$/\2/g;s/://g'`
		if [ -z "$USB" ]; then
			echo "Peço perdão, pois não consigo conectar na web."
			exit 1
		else
			echo "$USB"
		fi
	fi
else
	echo "$Ethernet"
fi
