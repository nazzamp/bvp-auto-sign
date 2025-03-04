#Requires AutoHotkey v2.0

FindImageAndMoveMouse(ImagePath, AddX := 0, AddY := 0) {
    CoordMode "Pixel", "Screen"
    ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, ImagePath)
    Sleep 100
    if (X) {
        Sleep 200
        MouseMove(X + AddX, Y + AddY)
        return 1
    }
    return 0
}

FindImage(ImagePath) {
    CoordMode "Pixel", "Screen"
    return ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, ImagePath)
}
