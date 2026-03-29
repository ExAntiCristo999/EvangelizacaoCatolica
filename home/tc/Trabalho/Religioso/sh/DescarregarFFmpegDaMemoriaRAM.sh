#!/bin/sh

ajuda(){
	echo "$0 \"Pasta onde serão instalados os programas, ou vazio, caso seje o /tmp/tcloop \""
	exit 4
}

FuncaoFor(){
	for DependenciaASerRemovidaDaListaDeDescarga in $1 ; do
		DependenciasFfmpeg=`echo "$DependenciasFfmpeg" | grep -v "$DependenciaASerRemovidaDaListaDeDescarga"`
	done
}

if [ "$1" = "-h" ] || [ "$1" = "-help" ] || [ "$1" = "--help" ]; then
	ajuda
fi

vim=`ps aux | grep "vim" | grep -v "grep"`
if [ -n "$vim" ]; then
	DependenciasVim=`ArvoreDeDependencias.sh "/etc/sysconfig/tcedir/optional/vim.tcz"`
fi
firefox=`ps aux | grep "firefox" | grep -v "grep"`
DependenciasFfmpeg=`ArvoreDeDependencias.sh "/etc/sysconfig/tcedir/optional/ffmpeg4.tcz" | grep -v "libsndfile.tcz\|libxkbfile.tcz\|gmp.tcz\|libcap.tcz\|libpng.tcz\|libtiff.tcz\|bzip2-lib.tcz"`
if [ -n "$firefox" ]; then
	DependenciasFirefox1=`ArvoreDeDependencias.sh "/etc/sysconfig/tcedir/optional/gtk3.tcz"`
	DependenciasFirefox2=`ArvoreDeDependencias.sh "/etc/sysconfig/tcedir/optional/dbus-glib.tcz"`
	DependenciasFirefox3=`ArvoreDeDependencias.sh "/etc/sysconfig/tcedir/optional/pulseaudio.tcz"`
	DependenciasFirefox=`echo -e "${DependenciasFirefox1}\n${DependenciasFirefox2}\n${DependenciasFirefox3}" | sort | uniq`
	FuncaoFor "$DependenciasFirefox"
fi
FuncaoFor "$DependenciasVim"
DependenciasDoNmap=`ArvoreDeDependencias.sh "/etc/sysconfig/tcedir/optional/nmap.tcz"`
DependenciasLinks2=`ArvoreDeDependencias.sh "/etc/sysconfig/tcedir/optional/links.tcz"`
FuncaoFor "$DependenciasLinks2"
FuncaoFor "$DependenciasDoNmap"
ListaDeDependenciasDoFfmpegASeremDescarregadas=`echo "$DependenciasFfmpeg" | sed 's/.tcz//g' | sed ':a;$!N;s/\n/,/;ta;'`
FecharProcessosComExcessaoDoVim.sh "ffmpeg,ffplay,alsamixer,amixer,Xfbdev,Xorg"
DesativarOuRemoverPacotesTCZ.sh "-d" "$ListaDeDependenciasDoFfmpegASeremDescarregadas" "$1"
InstalarProgramasNoCoreLinux.sh "acl,ncursesw"
