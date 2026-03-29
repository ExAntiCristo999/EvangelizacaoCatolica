#!/bin/sh

cat > $1 << EOF
#!/bin/sh -e
UnameM=$(uname -m)
ProgramSVersion="$2"
ProgramSName="$3"
CoreLinuxSVersion=`sed -r '/^VERSION="/!d;s/(.*=")([^"]{1,5})(".*)/\2/g' /etc/os-release`
BuildSDirectory="/$UnameM/$CoreLinuxSVersion/src/$3"
ProgramWhatToBeMkSquashfsedSDirectory="/$UnameM/$CoreLinuxSVersion/tcz/$3"
if [ ! -d "$DestinySDirectory" ]; then
	        mkdir -p "$DestinySDirectory"
fi
if [ ! -d "$DirectoryOfProgramWhatToBeMkSquashfsed" ]; then
	        mkdir -p "$DirectoryOfProgramWhatToBeMkSquashfsed"
fi
cd $BuildSDirectory
tce-load -ilw $4
rm -f $5
WgetSExitCodet="2"
until [ "$ExitCodeOfWget" -eq "0" ]; do
	wget $6/$5
	ExitCodeOfWget="$?"
done
cd *
#for i in $(find -name six.py); do
#	ln -sfv /usr/local/lib/python3.9/site-packages/six.py $i;
#done
#mkdir obj
#cd obj
if [ "$7" = "f" ]; then
	ConfigureCommandSPrefix=`sed -r "/$UnameM/!d;s/^([^;]{1,13}[;][^;]{1,13}[;])([^;]{1,90})([;])(.*)/CFLAGS=\"\2\" CXXFLAGS=\"\4\"/g" /home/tc/.local/bin/BancoDeDados/BuildSOptions.db`
else
	ConfigureCommandSPrefix=`sed -r "/$UnameM/!d;s/^([^;]{1,13}[;][^;]{1,13}[;])([^;]{1,90})([;])(.*)/CC=\"gcc \2\" CXX=\"g++ \4\"/g" /home/tc/.local/bin/BancoDeDados/BuildSOptions.db`
fi
ConfigureCommandSLocation="$8"
ConfigureCommandSSufix="$9"
$ConfigureCommandSPrefix $ConfigureCommandSLocation $ConfigureCommandSSufix
#find . -name autoconf.mk -type f -exec sed -i 's/-O3//g' {} \;
#find . -name backend.mk -type f -exec sed -i 's/-O3//g' {} \;
#find . -name autoconf.mk -type f -exec sed -i 's/FLAGS = -g/FLAGS = /g' {} \;
#find . -name autoconf.mk -type f -exec sed -i 's/ -g//g' {} \;
#find . -name Makefile -type f -exec sed -i 's/-g -O2//g' {} \;
make $ConfigureCommandSPrefix
mkdir -p "$ProgramWhatToBeMkSquashfsedSDirectory"
make DESTDIR=$ProgramWhatToBeMkSquashfsedSDirectory install $ConfigureCommandSPrefix
#(sed -n 2p /home/tc/Trabalho/Profissional/db/senhas.db | cut -d ":" -f 2) | su root -c rm -v /usr/local/lib/libjs_static.ajs
#(sed -n 2p /home/tc/Trabalho/Profissional/db/senhas.db | cut -d ":" -f 2) | su root -c sed -i '/@NSPR_CFLAGS@/d' /usr/local/bin/js125-config
cd /$UnameM/$CoreLinuxSVersion/tcz
for Package in bin dev lib doc ; do
	mkdir -p $3-$Package/usr/local
	if [ "$Package" = "lib" ]; then
		cp -pRf $3/usr/local/lib $3-lib/usr/local/
		cp -pRf $3/usr/local/share $3-lib/usr/local/
		rm -Rf $3-lib/usr/local/share/doc $3-lib/usr/local/lib/pkgconfig
	elif [ "$Package" = "dev" ]; then
		cp -pRf $3/usr/local/include $3-dev/usr/local/
		mkdir -p $3-dev/usr/local/lib
		cp -pRf $3/usr/local/lib/pkgconfig $3-dev/usr/local/lib/
	elif [ "$Package" = "bin" ]; then
		cp -pRf $3/usr/local/bin $3-bin/usr/local/
	else
		mkdir -p $3-doc/usr/local/share
		cp -pRf $3/usr/local/share/doc $3-doc/usr/local/share/
	fi
	mksquashfs $3-$Package $3-$Package.tcz
	md5sum $3-$Package.tcz > $3-$Package.tcz.md5.txt
	/usr/bin/find $3-$Package/ -exec file {} + | sed -r '/ELF/!d;s/([^:]{1,300})([:])(.*)/ldd \1/g' | sh | sed -r 's/[ \t]+/ /g;/ld-linux-x86-64.so.2/d;/linux-vdso.so.1/d' | sed -r '/\/usr\/local\/lib/!d;s/(.*[=][>] )([^ ]{1,90})( [(].*)/provides.sh \2/g;s/\//\\\\\//g' | sh | sort | uniq > $3-$Package.tcz.dep
done
EOF
Exit="1"
until [ "$Exit" -eq "0" ]; do
	chmod 777 "$1"
	sh -e "$1"
	if [ "$?" -ne "0" ]; then
		vim "$1"
	else
		echo "Package $3 created with success."
		Exit="0"
	fi
done
