#Requires AutoHotkey v2.0
#Include ../common/find-text.ahk

if WinExist("FPT")
    WinActivate

if (FindTextAndMoveMouse("NhânSự")) {
    Sleep 200
    MouseMove(30, 40, 50, 'R')
    Sleep 100
    MouseClick "Left"
    Sleep 500
}
