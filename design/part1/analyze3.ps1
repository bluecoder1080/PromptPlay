Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap('E:\custom-game\design\part1\image.png')
$w = $bmp.Width; $h = $bmp.Height

# Return ink bbox within a sub-rectangle
function InkBox($x0, $x1, $y0, $y1, $label) {
    $minX = 9999; $maxX = -1; $minY = 9999; $maxY = -1
    for ($y = $y0; $y -le $y1 -and $y -lt $h; $y++) {
        for ($x = $x0; $x -le $x1 -and $x -lt $w; $x++) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.A -gt 128) {
                if ($x -lt $minX) { $minX = $x }; if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }; if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }
    Write-Output "$label bbox x[$minX..$maxX] y[$minY..$maxY] -> w=$($maxX-$minX+1) h=$($maxY-$minY+1)"
}

# Heading first glyph 'W' : heading starts x=77, y 143..185
InkBox 77 135 140 190 "HEAD 'W'"
# Description line1 first glyph 'B' : starts x=14
InkBox 14 40 210 255 "DESC 'B' (cap)"
$bmp.Dispose()
