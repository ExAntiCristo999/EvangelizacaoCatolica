for pci in /sys/bus/pci/devices/*; do
	if [ -f "$pci/class" ] && [ -f "$pci/vendor" ]; then
		class=$(cat "$pci/class" 2>/dev/null)
		vendor=$(cat "$pci/vendor" 2>/dev/null)
		if [ "$class" = "0x030000" ] && [ "$vendor" = "0x10de" ]; then
   			tce-load -iwl nouveau-KERNEL
		elif [ "$class" = "0x030000" ] && [ "$vendor" != "0x10de" ]; then
			tce-load -iwl graphics-KERNEL
		fi
	fi
done
