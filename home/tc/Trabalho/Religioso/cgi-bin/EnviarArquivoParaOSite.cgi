


echo "content-type: text/html"
echo ""

ArquiteturaDoProcessador=`uname -m`
PastaPadraoDosProgramasQueCrio=`PastaPadraoDosProgramasQueCrio.sh`
PastaFinal="${PastaPadraoDosProgramasQueCrio%/home*}/${ArquiteturaDoProcessador}/uploads"
if [ ! -d "$PastaFinal" ]; then
	mkdir -p "$PastaFinal"
fi
file=$PastaComArquivosTemporariosDosProgramasQueCrio/$$-$RANDOM

# CGI output must start with at least empty line (or headers)
printf '\r\n'
  cat <<EOF
<!DOCTYPE html>
<html>
<head>

<title>Upload</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
EOF

cat <<EOF
<form action="http://192.168.42.129:8080/cgi-bin/ExtrairArquivoDaRequisicaoHttpDoTipoPOST.cgi" method="POST" enctype="multipart/form-data">
<input type="file" id="enviarArquivo" name="arquivo" accept=".zip" required>
<input type="submit" value="Enviar arquivo">
<form>
</body>
</html>
EOF

exit 0
