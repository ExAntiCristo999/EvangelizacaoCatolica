#!/bin/sh

dParcial=`while read l ; do echo "$l" ; done < /etc/sysconfig/backup_device`
echo "Porcentagem de Processador utilizado:"
grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}'
RAMTotal=`sed -r '/MemTotal/!d;s/ +/ /g;s/(([^ ]*) ){2}.*/\2/' /proc/meminfo`
RAMLivre=`sed -r '/MemFree/!d;s/ +/ /g;s/(([^ ]*) ){2}.*/\2/' /proc/meminfo`
PorcentagemDeRAMUsada=`expr 100 \* \( $RAMTotal - $RAMLivre \) / $RAMTotal`
echo -e "Porcentagem de RAM usada:\n$(( 100 * ( $RAMTotal - $RAMLivre ) / $RAMTotal ))%"
echo "Porcentagem de RAMDisk utilizada:"
df / | sed -r '/\//!d;s/(.* )([0-9]{1,3}[%])( .*)/\2/g'
echo "Porcentagem de Disco rígido utilizado:"
d="${dParcial%%/*}"
df /dev/${d} | sed -r '/\//!d;s/(.* )([0-9]{1,3}[%])( .*)/\2/g'
