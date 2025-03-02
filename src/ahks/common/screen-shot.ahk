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

SaveScreenShotNew(x1, y1, x2, y2, outfile, imageformat, scaleFactor := 2) {
    ; valid imageformats: see
    ;      https://learn.microsoft.com/en-us/dotnet/api/system.drawing.imaging.imageformat?view=dotnet-plat-ext-8.0
    powercmd := "PowerShell.exe -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -Command " .
        "[Reflection.Assembly]::LoadWithPartialName('System.Drawing') `; " .
        "$bounds = [Drawing.Rectangle]::FromLTRB( " . x1 . ", " . y1 . ", " . x2 . ", " . y2 . " ) `; " .
        "$bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height `; " .
        "$graphics = [Drawing.Graphics]::FromImage($bmp) `; " .
        "$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size) `; " .
        "$upscaledWidth = [int]($bounds.width * " . scaleFactor . ") `; " .
        "$upscaledHeight = [int]($bounds.height * " . scaleFactor . ") `; " .
        "$upscaledBmp = New-Object Drawing.Bitmap $upscaledWidth, $upscaledHeight `; " .
        "$upscaledGraphics = [Drawing.Graphics]::FromImage($upscaledBmp) `; " .
        "$upscaledGraphics.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic `; " .
        "$upscaledGraphics.DrawImage($bmp, 0, 0, $upscaledWidth, $upscaledHeight) `; " .
        "$upscaledBmp.Save('" . outfile . "', '" . imageformat . "' ) `; " .
        "$graphics.Dispose() `; " .
        "$bmp.Dispose() `; " .
        "$upscaledGraphics.Dispose() `; " .
        "$upscaledBmp.Dispose()"
    RunWait(powercmd, , 'Hide')
    return
}

SaveScreenShotGrayScale(x1, y1, x2, y2, outfile, imageformat, scaleFactor := 2) {
    powercmd := "PowerShell.exe -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -Command " .
        "[Reflection.Assembly]::LoadWithPartialName('System.Drawing') `; " .
        "$bounds = [Drawing.Rectangle]::FromLTRB( " . x1 . ", " . y1 . ", " . x2 . ", " . y2 . " ) `; " .
        "$bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height `; " .
        "$graphics = [Drawing.Graphics]::FromImage($bmp) `; " .
        "$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size) `; " .
        "$upscaledWidth = [int]($bounds.width * " . scaleFactor . ") `; " .
        "$upscaledHeight = [int]($bounds.height * " . scaleFactor . ") `; " .
        "$upscaledBmp = New-Object Drawing.Bitmap $upscaledWidth, $upscaledHeight `; " .
        "$upscaledGraphics = [Drawing.Graphics]::FromImage($upscaledBmp) `; " .
        "$upscaledGraphics.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic `; " .
        "$upscaledGraphics.DrawImage($bmp, 0, 0, $upscaledWidth, $upscaledHeight) `; " .
        ; --- Contrast Adjustment Code Start ---
        "$imageAttributes = New-Object Drawing.Imaging.ImageAttributes `; " .
        "$colorMatrix = New-Object Drawing.Imaging.ColorMatrix `; " .
        "$contrast = 1.5 `; " . ; 1.5 = 150% contrast (adjust this value)
        "$colorMatrix.Matrix00 = $colorMatrix.Matrix11 = $colorMatrix.Matrix22 = $contrast `; " .
        "$colorMatrix.Matrix40 = $colorMatrix.Matrix41 = $colorMatrix.Matrix42 = (1 - $contrast) * 0.5 `; " .
        "$imageAttributes.SetColorMatrix($colorMatrix) `; " .
        "$adjustedBmp = New-Object Drawing.Bitmap $upscaledWidth, $upscaledHeight `; " .
        "$adjustedGraphics = [Drawing.Graphics]::FromImage($adjustedBmp) `; " .
        "$adjustedGraphics.DrawImage($upscaledBmp, [Drawing.Rectangle]::new(0,0,$upscaledWidth,$upscaledHeight), 0, 0, $upscaledWidth, $upscaledHeight, [Drawing.GraphicsUnit]::Pixel, $imageAttributes) `; " .
        "$adjustedGraphics.Dispose() `; " .
        "$upscaledBmp.Dispose() `; " .
        "$upscaledBmp = $adjustedBmp `; " .
        ; --- Contrast Adjustment Code End ---
        "$upscaledBmp.Save('" . outfile . "', '" . imageformat . "' ) `; " .
        "$graphics.Dispose() `; " .
        "$bmp.Dispose() `; " .
        "$upscaledGraphics.Dispose() `; " .
        "$upscaledBmp.Dispose()"
    RunWait(powercmd, , 'Hide')
    return
}
