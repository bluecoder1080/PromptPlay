param([string]$Path, [string]$Label = "IMG")
Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap($Path)
$w = $bmp.Width; $h = $bmp.Height
Write-Output "=== $Label : $w x $h ($Path)"

# Collect ink per row
$ink = @()
for ($y = 0; $y -lt $h; $y++) {
    $minX = -1; $maxX = -1; $count = 0
    for ($x = 0; $x -lt $w; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.A -gt 128) { if ($minX -lt 0) { $minX = $x }; $maxX = $x; $count++ }
    }
    $ink += [pscustomobject]@{ y = $y; minX = $minX; maxX = $maxX; count = $count }
}

# Content bands (rows with ink), merging gaps smaller than 3px
$bands = @()
$inBand = $false; $start = 0; $gap = 0; $last = -1
foreach ($r in $ink) {
    if ($r.count -gt 0) { if (-not $inBand) { $inBand = $true; $start = $r.y }; $last = $r.y; $gap = 0 }
    else { if ($inBand) { $gap++; if ($gap -ge 3) { $bands += , @($start, $last); $inBand = $false } } }
}
if ($inBand) { $bands += , @($start, $last) }

Write-Output "CONTENT BANDS (top..bottom, height):"
foreach ($b in $bands) {
    $y0 = $b[0]; $y1 = $b[1]
    $minX = 9999; $maxX = -1
    for ($y = $y0; $y -le $y1; $y++) {
        if ($ink[$y].count -gt 0) {
            if ($ink[$y].minX -lt $minX) { $minX = $ink[$y].minX }
            if ($ink[$y].maxX -gt $maxX) { $maxX = $ink[$y].maxX }
        }
    }
    $cx = [math]::Round(($minX + $maxX) / 2, 1)
    Write-Output ("  y[$y0..$y1] h=" + ($y1 - $y0 + 1) + "  x[$minX..$maxX] w=" + ($maxX - $minX + 1) + "  centerX=$cx")
}

# Gaps between consecutive bands
if ($bands.Count -gt 1) {
    Write-Output "GAPS (ink-to-ink):"
    for ($i = 1; $i -lt $bands.Count; $i++) {
        Write-Output ("  band$i bottom=" + $bands[$i-1][1] + " -> band" + $i + " top=" + $bands[$i][0] + " gap=" + ($bands[$i][0] - $bands[$i-1][1] - 1))
    }
}

# Overall content bbox
$allTop = ($bands | ForEach-Object { $_[0] } | Measure-Object -Minimum).Minimum
$allBot = ($bands | ForEach-Object { $_[1] } | Measure-Object -Maximum).Maximum
Write-Output "CONTENT BBOX y[$allTop..$allBot] h=$($allBot - $allTop + 1)"
$bmp.Dispose()
