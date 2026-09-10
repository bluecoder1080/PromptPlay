Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap('E:\custom-game\design\part1\image.png')
$w = $bmp.Width; $h = $bmp.Height

# Row-by-row: report first/last non-transparent pixel per row (sampled)
Write-Output "IMAGE: $w x $h"
$rows = @()
for ($y = 0; $y -lt $h; $y++) {
    $minX = -1; $maxX = -1; $count = 0
    for ($x = 0; $x -lt $w; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.A -gt 16) { if ($minX -lt 0) { $minX = $x }; $maxX = $x; $count++ }
    }
    $rows += [pscustomobject]@{ y = $y; minX = $minX; maxX = $maxX; count = $count }
}

# Find vertical bands of content
$inBand = $false; $start = 0
foreach ($r in $rows) {
    if ($r.count -gt 0 -and -not $inBand) { $inBand = $true; $start = $r.y }
    if ($r.count -eq 0 -and $inBand) { $inBand = $false; Write-Output "BAND rows $start..$($r.y - 1) (height $($r.y - $start))" }
}
if ($inBand) { Write-Output "BAND rows $start..$($h-1)" }

# Darkest pixel overall in each band region (first 120 rows = logo, etc.)
function Darkest($y0, $y1, $label) {
    $best = $null; $bestSum = 99999
    for ($y = $y0; $y -le $y1 -and $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.A -gt 128) { $s = $c.R + $c.G + $c.B; if ($s -lt $bestSum) { $bestSum = $s; $best = $c; $bx = $x; $by = $y } }
        }
    }
    Write-Output "$label darkest = R$($best.R) G$($best.G) B$($best.B) A$($best.A) at ($bx,$by)"
}
$bmp.Dispose()
