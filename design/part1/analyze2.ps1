Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap('E:\custom-game\design\part1\image.png')
$w = $bmp.Width; $h = $bmp.Height

function Band($y0, $y1, $label) {
    $minX = 9999; $maxX = -1
    $colors = @{}
    for ($y = $y0; $y -le $y1 -and $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.A -gt 128) {
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                $key = "$($c.R),$($c.G),$($c.B)"
                if ($colors.ContainsKey($key)) { $colors[$key]++ } else { $colors[$key] = 1 }
            }
        }
    }
    $cx = ($minX + $maxX) / 2
    Write-Output "$label : x[$minX..$maxX] width=$($maxX-$minX+1) centerX=$cx"
    $colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 4 | ForEach-Object {
        Write-Output "    color $($_.Key) x$($_.Value)"
    }
}

Band 0 95 "LOGO"
Band 143 185 "HEADING"
Band 220 244 "DESC-L1"
Band 266 290 "DESC-L2"
$bmp.Dispose()
