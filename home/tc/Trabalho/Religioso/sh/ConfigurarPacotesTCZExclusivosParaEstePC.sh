#!/bin/sh

Resposta="a"
until [ "$Resposta" = "s" ] || [ "$Resposta" = "n" ]; do
	echo "Deseja adicionar os pacotes que estão atualmente carregados (s/n)?"
	read Resposta
	Resposta=`echo "$Resposta" | /bin/sed -r 'y/SN/sn/;/^[sn]$/!d'`
done
if [ -z "$1" ]; then
	VersaoDoKernel=`uname -r`
else
	VersaoDoKernel="$1"
fi
if [ "$Resposta" = "s" ]; then
	PacotesTCZCarregadosAtualmenteNaoFormatado=`/bin/ls /tmp/tcloop/ | /bin/sed ':a;$!N;s/\n/\ /;ta' | /bin/sed "s/\///g;s/${VersaoDoKernel}/KERNEL/g"`
fi
PacotesTCZCompleto=`/bin/ls /etc/sysconfig/tcedir/optional/*.tcz | /bin/sed -r "s/${VersaoDoKernel}/KERNEL/g;s/.tcz//g;s/(([^/]*)\/){5}(.*)/\3/"`
Opcoes=`echo "$PacotesTCZCompleto" | nl -b a`
until [ -n "$OpcoesEscolhidas" ]; do
	echo -e "Anote num papel as opções correspondentes aos pacotes TCZs:\n\n${Opcoes}" | /usr/bin/less
	read OpcoesEscolhidas
	OpcoesEscolhidas=`echo "$OpcoesEscolhidas" | sed -r '/^([0-9]{1,4})([,][0-9]{1,4}){0,200}$/!d'`
	if [ -n "$OpcoesEscolhidas" ]; then
		PacotesTCZEscolhidos=`echo "$PacotesTCZCompleto" | /bin/sed ':a;$!N;s/\n/\ /;ta' | cut -d " " -f ${OpcoesEscolhidas}`
	fi
done
ArquivoDeDestino=`while read l ; do echo "$l" ; done < /tmp/TemPacotesTCZExclusivosParaEstePC.tmp`

PastaDeDestino="${ArquivoDeDestino%/*}"
if [ ! -d "$PastaDeDestino" ]; then
	mkdir -p "$PastaDeDestino"
fi
PacotesFinal=`echo "$PacotesTCZCarregadosAtualmente $PacotesTCZEscolhidos" | /bin/sed ':a;$!N;s/\n/\ /;ta' | /bin/sed -r 's/ +/ /g;s/\ $//g'`
echo -e "#!/bin/sh\necho \"${PacotesFinal}\""> "$ArquivoDeDestino"
