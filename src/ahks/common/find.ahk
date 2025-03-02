#Requires AutoHotkey v2.0

CoordMode "Pixel", "Screen"

FindImageAndMoveMouse(ImagePath, AddX := 0, AddY := 0) {
    ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, ImagePath)
    if (X) {
        Sleep 200
        MouseMove(X + AddX, Y + AddY)
        return 1
    }
    return 0
}

FindImage(ImagePath) {
    return ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, ImagePath)
}
