#!/bin/sh

echo "$1" | tr 'a-z' 'A-Z' | sed 's/ /%20/g' | sed 's/á/Á/g' | sed 's/é/É/g' | sed 's/í/Í/g' | sed 's/ó/Ó/g' | sed 's/ú/Ú/g' | sed 's/â/Â/g' | sed 's/ê/Ê/g' | sed 's/ô/Ô/g' | sed 's/ã/Ã/g' | sed 's/õ/Õ/g' | sed 's/à/À/g' | sed 's/ç/Ç/g'
