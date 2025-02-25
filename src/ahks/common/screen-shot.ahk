SaveScreenShot(x1, y1, x2, y2, outfile, imageformat) {
    ; valid imageformats: see
    ;      https://learn.microsoft.com/en-us/dotnet/api/system.drawing.imaging.imageformat?view=dotnet-plat-ext-8.0
    powercmd := "PowerShell.exe -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -Command " .
        "[Reflection.Assembly]::LoadWithPartialName('System.Drawing') `; " .
        "$bounds = [Drawing.Rectangle]::FromLTRB( " . x1 . ", " . y1 . ", " . x2 . ", " . y2 . " ) `; " .
        "$bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height `; " .
        "$graphics = [Drawing.Graphics]::FromImage($bmp) `; " .
        "$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size) `; " .
        "$bmp.Save('" . outfile . "', '" . imageformat . "' ) `; " .
        "$graphics.Dispose() `; " .
        "$bmp.Dispose()"
    RunWait(powercmd, , 'Hide')
    return
}
