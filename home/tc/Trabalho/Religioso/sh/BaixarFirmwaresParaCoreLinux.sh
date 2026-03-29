if [ "$USER" = "tc" ]; then
	Pasta="$PastaDeArquitetura/home/tc/Downloads"
	if [ ! -d "$Pasta" ]; then
		mkdir -p "$Pasta"
	fi
	cd "$Pasta"
	git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
fi
