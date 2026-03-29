if [ "$ArquiteturaDoProcessadorDesteComputador" = "i686" ]; then
	ArquiteturaDaDistroNoSite="x86"
elif [ "$ArquiteturaDoProcessadorDesteComputador" = "x86_64" ]; then
	ArquiteturaDaDistroNoSite="x86_64"
fi
SiteInicialDoCoreLinux=`while read l ; do echo "$l" ; done < /opt/tcemirror`
UltimaVersaoDoCoreLinuxExistente=`wget -c $SiteInicialDoCoreLinux -O - 2>&1 | sed -r '/latest/!d;s/(.*[<]b[>])([^<]{1,10})([<].*)/\2/g'`
VersaoAtualInstalada=`sed -r '/VERSION_ID/!d;s/(VERSION[_]ID[=])(.*)/\2/g' /etc/os-release`
if [ "$UltimaVersaoDoCoreLinuxExistente" = "$VersaoAtualInstalada" ]; then
	echo "A Versão do Core Linux instalada já é a mais atual."
	exit 0
fi
UltimaVersaoDoCoreLinuxNoFormatoNumerosPontoXMinusculo="${UltimaVersaoDoCoreLinuxExistente%.*}.x"
until [ -n "$ListaDePacotesTCZDaVersaoMaisNova" ]; do ListaDePacotesTCZDaVersaoMaisNova=`wget -c $SiteInicialDoCoreLinux/$UltimaVersaoDoCoreLinuxNoFormatoNumerosPontoXMinusculo/$ArquiteturaDaDistroNoSite/tcz/ -O - 2>&1 | sed -r '/tcz/!d'` ; echo "$ListaDePacotesTCZDaVersaoMaisNova" | less ; if [ "$?" -ne "0" ]; then sleep 5 ; tcemirror.sh ; fi ; done
NomeDoProgramaSemOSufixoPontoSh="${0%.sh}"
NomeDoPrograma="${NomeDoProgramaSemOSufixoPontoSh##*/}"
PastaDosArquivosTemporarios="$PastaComArquivosTemporariosDosProgramasQueCrio/$NomeDoPrograma"
if [ ! -d "$PastaDosArquivosTemporarios" ]; then
	mkdir -p $PastaDosArquivosTemporarios
fi
EscolhaUmaOuMaisDeUmaDasSeguintesOpcoes.sh "$ListaDePacotesTCZDaVersaoMaisNova" "Tecle os números correspondente aos pacotes TCZ, e depos enter." "" "$PastaDosArquivosTemporarios/tcz.txt"
exit 2



PontoDeMontagemSemONumeroDaParticao=`while read l ; do echo "/mnt/${l%%/*}" ; done < /etc/sysconfig/backup_device`
mkdir -p $PontoDeMontagemSemONumeroDaParticao/ParaUso/x86_64/tce $PontoDeMontagemSemONumeroDaParticao/ParaUso/x86_64/boot $PontoDeMontagemSemONumeroDaParticao/ParaUso/i686/boot $PontoDeMontagemSemONumeroDaParticao/ParaUso/i686/tce $PontoDeMontagemSemONumeroDaParticao/ParaTeste/x86_64/tce $PontoDeMontagemSemONumeroDaParticao/ParaTeste/x86_64/boot $PontoDeMontagemSemONumeroDaParticao/ParaTeste/i686/boot $PontoDeMontagemSemONumeroDaParticao/ParaTeste/i686/tce

