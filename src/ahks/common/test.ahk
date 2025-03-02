#Requires AutoHotkey v2.0
#Include find-text.ahk

if WinExist("FPT")
    WinActivate

Day := FindTextInRegion(355, 130, 355 + 23, 130 + 20)

MsgBox Day
; Month := FindTextInRegion(355 + 31, 130, 355 + 52, 130 + 20)
; Year := FindTextInRegion(355 + 61, 130, 355 + 93, 130 + 20)

; MsgBox Day . " " . Month . " " . Year
