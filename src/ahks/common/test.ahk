#Requires AutoHotkey v2.0
#Include find-text.ahk
#Include find.ahk
#Include sign.ahk

CoordMode "Pixel", "Screen"

if WinExist("FPT")
    WinActivate

MsgBox CheckDate("20250306000000", "20250307000000")

; if (FindImageAndMoveMouse('../images/acer-1920-1080/' . "goc-phieu-cham-soc.png", 0, 0, 150)) {
;     Sleep 300
;     MouseMove(-540, 140, 50, "R")
;     Sleep 200
;     ; SignAtPos(1234556)
; }

; Day := FindTextInRegion(355, 130, 355 + 23, 130 + 20)
; Month := FindTextInRegion(355 + 31, 130, 355 + 52, 130 + 20)
; Year := FindTextInRegion(355 + 61, 130, 355 + 93, 130 + 20)

; A := StrSplit(FindNameInRegion(310, 148, 470, 165), '')
; MsgBox StrLen(FindNameInRegion(310, 148, 470, 165))

; FindTextInRegion(653, 151, 670, 164)
; FindTextInRegion(680, 151, 699, 164)
; FindTextInRegion(710, 151, 742, 164)

CheckDate(DATE_FROM, DATE_TO) {
    Day := FindTextInRegion(653, 151, 670, 164)
    Month := FindTextInRegion(680, 151, 699, 164)
    Year := FindTextInRegion(710, 151, 742, 164)

    CheckDate := ""
    if (Day = "") {
        CheckDate := "20001010000000"
    } else {
        CheckDate := Year . Month . Day . "000000"
    }

    IS_IN_DATE_RANGE := DateDiff(CheckDate, DATE_FROM, "Days") >= 0 && DateDiff(DATE_TO, CheckDate, "Days") >= 0
    IS_DATE_SMALLER := DateDiff(CheckDate, DATE_FROM, "Days") < 0
    if (IS_IN_DATE_RANGE) {
        return 1
    }
    if (IS_DATE_SMALLER) {
        return -1
    }
    return 0
}
