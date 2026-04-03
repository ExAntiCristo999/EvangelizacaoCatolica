#!/bin/sh


echo -ne "Content-Type: text/html\r\n\r\n"

cat << EOH
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <title></title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
</head>
<body>

<div class="container">
  <h2>Arquivos e/ou pastas</h2>
  <div id="list" class="list-group">
EOH

ls -a --group-directories-first -p "..${REQUEST_URI#${SCRIPT_NAME}}"|while read line
do
  echo "<a href=\"$line\" class='list-group-item'>$line</a>"
done

cat << EOF
  </div>
</div>

</body>
</html>
EOF
