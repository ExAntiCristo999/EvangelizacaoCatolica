function Get-FullWindowsKey {

    # tenta OEM primeiro
    $bios = (Get-CimInstance SoftwareLicensingService).OA3xOriginalProductKey
    if ($bios) { return $bios }

    # tenta registro
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    $value = (Get-ItemProperty -Path $regPath).DigitalProductId

    if ($value) {
        $key = ""
        $chars = "BCDFGHJKMPQRTVWXY2346789"
        $keyOffset = 52

        for ($i = 24; $i -ge 0; $i--) {
            $current = 0
            for ($j = 14; $j -ge 0; $j--) {
                $current = ($current * 256) -bxor $value[$j + $keyOffset]
                $value[$j + $keyOffset] = [math]::Floor($current / 24)
                $current = $current % 24
            }
            $key = $chars[$current] + $key
            if (($i % 5 -eq 0) -and ($i -ne 0)) {
                $key = "-" + $key
            }
        }

        return $key
    }

    return "Chave não encontrada"
}

Get-FullWindowsKey
