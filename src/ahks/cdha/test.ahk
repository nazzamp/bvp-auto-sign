#Requires AutoHotkey v2.0
#Include ../common/find-text.ahk
#Include ../common/sign.ahk

MsgBox StrCompare("Abc", "abc", false)

; CoordMode "Pixel", "Screen"
; PASS := 12345678

; ; if WinExist("Thông tin văn bản")
; ;     WinActivate

; if WinExist("FPT")
;     WinActivate

; ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "last.png")
; MsgBox FoundX FoundY

; Sleep 200
; Send("#{Up}")
; Sleep 1000

; loop {
;     CoorArr := FindDoctorSignTreatment("Vũ Văn")
;     if (CoorArr.Length = 0) {
;         MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2)
;         Sleep 200
;         Send("{WheelDown 3}")
;         Sleep 1000
;     }
;     if (CoorArr.Length = 1) {
;         MouseMove(CoorArr[1].X - 240, CoorArr[1].Y)
;         Sleep 200
;         SignAtPos(PASS)
;         break
;     }
;     if (CoorArr.Length = 2) {
;         MouseMove(CoorArr[1].X - 240, CoorArr[1].Y)
;         Sleep 200
;         SignAtPosNotExit(PASS)
;         Sleep 2000
;         loop A_Index - 1 {
;             Sleep 200
;             Send("{WheelDown 3}")
;             Sleep 1000
;         }
;         Sleep 300
;         MouseMove(CoorArr[2].X - 240, CoorArr[2].Y)
;         SignAtPos(PASS)
;         Sleep 300
;         break
;     }
; }

; if WinExist("FPT")
;     WinActivate

; FindTextAndMoveMouse("Sốbệnhán")
; MouseMove(120, 0, 50, "R")

; Send("{Down}")

; if (WinExist("Thông tin")) {
;     WinActivate
;     Sleep 300
;     Send("!{F4}")
;     Sleep 300
; }

; DocName := FindDoctorName()
; MsgBox DocName

; MsgBox FindDoctorSignTreatment("Vũ Văn").Length
; a := StrSplit("Vũ Văn", " ")
