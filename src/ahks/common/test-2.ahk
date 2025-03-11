#Requires AutoHotkey v2.0

if WinExist("FPT") {
    WinActivate
    Sleep 300
    RemoveFocusFirstItem()
}

RemoveFocusFirstItem() {
    MouseMove(210, 135)
    Sleep 300
    MouseClick "Left"
    Sleep 300
}
