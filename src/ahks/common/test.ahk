#Requires AutoHotkey v2.0
#Include find-text.ahk

; F9:: {
;     MsgBox 'abc'
; }

CoordMode "Pixel", "Screen"

if WinExist("Thông tin")
    WinActivate

; MsgBox FindTextAndMoveMouse('TIN')
MsgBox ImageSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
    "*100 ../images/acer-1920-1080/check-y-lenh.png",)
; Sleep 200
; MouseMove(x + 20, y - 10)
; Sleep 200
; Day := FindTextInRegion(355, 130, 355 + 23, 130 + 20)

; MsgBox Day
; Month := FindTextInRegion(355 + 31, 130, 355 + 52, 130 + 20)
; Year := FindTextInRegion(355 + 61, 130, 355 + 93, 130 + 20)

; MsgBox Day . " " . Month . " " . Year
