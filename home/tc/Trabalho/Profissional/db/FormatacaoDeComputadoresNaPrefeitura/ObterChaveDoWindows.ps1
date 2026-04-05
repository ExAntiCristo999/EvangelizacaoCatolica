function Get-WindowsKey {
    $map = "BCDFGHJKMPQRTVWXY2346789"
    $value = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DigitalProductId
    $productKey = ""
    for ($i = 52; $i -le 66; $i++) {
        $current = $value[$i]
        for ($j = 24; $j -ge 0; $j--) {
            $current = ($current -bxor ($value[$j] -band 1)) -bor ($current -band 1)
            $value[$j] = [byte]($value[$j] -shr 1)
            $current = [byte]($current -shr 1)
        }
        $productKey = $map[$current] + $productKey
    }
    $productKey = $productKey -replace '(.{5})(?!$)', '$1-'
    return $productKey
}
Get-WindowsKey
