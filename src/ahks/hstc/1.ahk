#Requires AutoHotkey v2.0
#Include ../common/find-text.ahk
#Include ../common/sign.ahk

Esc:: ExitApp

PASS := A_Args[1]
DocName := A_Args[2]
CoordMode "Pixel", "Screen"

if WinExist("FPT") {
    WinActivate
    Sleep 200
    Send("{Tab}")
    Sleep 100
    Send("{{Tab}}")
    Sleep 100
    loop {
        Send("{Space}")
        Sleep 200

        ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "last.png")
        if (FoundX) {
            FindTextAndMoveMouse("Sốbệnhán")
            Sleep 200
            MouseMove(120, 0, 50, "R")
            Sleep 200
            MouseClick "Left"
            Sleep 200
            Send("{Down}")
            Sleep 3000
            Send("{Tab}")
            Sleep 100
            Send("{{Tab}}")
            Sleep 100
        } else {
            if (FindTextArrayAndMoveMouse(StrSplit(DocName, " "))) {
                if (FindTextArrayAndMoveMouse(["Xem", "Ký"])) {
                    Sleep 500
                    MouseClick "Left"
                    Sleep 300
                    Send("{Tab}")
                    Sleep 300
                    Send("{Tab}")
                    Sleep 300
                    Send("{Space}")
                    Sleep 300
                    Send("{Enter}")
                    Sleep 300
                    Send("{Enter}")
                    Sleep 300
                    Send("{Enter}")
                    Sleep 300
                    if WinExist("Management System") {
                        Send("{Enter}")
                        Sleep 300
                        MouseMove(-100, 0, 50, "R")
                        Sleep 300
                        MouseClick "Left"
                        Sleep 500
                        SelectSign()
                        Sleep 300
                        Send("{Enter}")
                        Sleep 300
                        Send("{Enter}")
                        Sleep 300
                        loop {
                            if WinExist("Thông tin văn bản") {
                                WinActivate
                                Sleep 200
                                Send("#{Up}")
                                Sleep 1000
                                loop {
                                    CoorArr := FindDoctorSignTreatment("Vũ Văn")
                                    if (CoorArr.Length = 0) {
                                        MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2)
                                        Sleep 200
                                        Send("{WheelDown 3}")
                                        Sleep 1000
                                    }
                                    if (CoorArr.Length = 1) {
                                        MouseMove(CoorArr[1].X - 240, CoorArr[1].Y)
                                        Sleep 200
                                        SignAtPos(PASS)
                                        break
                                    }
                                    if (CoorArr.Length = 2) {
                                        MouseMove(CoorArr[1].X - 240, CoorArr[1].Y)
                                        Sleep 200
                                        SignAtPosNotExit(PASS)
                                        Sleep 2000
                                        loop A_Index - 1 {
                                            Sleep 200
                                            Send("{WheelDown 3}")
                                            Sleep 1000
                                        }
                                        Sleep 300
                                        MouseMove(CoorArr[2].X - 240, CoorArr[2].Y)
                                        SignAtPos(PASS)
                                        Sleep 300
                                        break
                                    }
                                }
                                break
                            }
                            Sleep(1000)
                        }
                    } else {
                        if (WinExist("Thông tin")) {
                            WinActivate
                            Sleep 300
                            Send("!{F4}")
                            Sleep 300
                        }
                    }
                }
            }

            Sleep 300
            Send("{Space}")
            Sleep 500
            Send("{Down}")
            Sleep 300
        }
    }
}

SelectSign() {
    Send("{Tab}")
    Sleep 300
    Send("{Tab}")
    Sleep 300
    Send("{Space}")
    Sleep 300
    Send("{Enter}")
    Sleep 300
    Send("{Enter}")
    Sleep 300
}
