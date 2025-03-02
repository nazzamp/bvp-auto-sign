#Requires AutoHotkey v2.0
#Include ../common/find-text.ahk
#Include ../common/sign.ahk
#Include ../common/find.ahk

Esc:: ExitApp

PASS := A_Args[1]
IMAGE_PATH := A_Args[2]
DATE_FROM := A_Args[3]
DATE_TO := A_Args[4]

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
        ; FindImageAndMoveMouse(IMAGE_PATH . "delete.png")
        ImageSearch(&X, &Y, 0, 0, A_ScreenWidth, A_ScreenHeight, IMAGE_PATH . "delete.png")
        Sleep 300
        MouseMove(X, Y)
        Sleep 300
        MouseClick "Left"
        Sleep 300
        MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2)
        Sleep 800
        if (!ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, IMAGE_PATH . "khong-xoa-duoc.png")) {
            Send('{Right}')
            Sleep 600
            Send("{Enter}")
            Sleep 600
            if (ImageSearch(&FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, IMAGE_PATH . "xem-ky-so.png")) {
                MouseMove(FoundX + 20, FoundY - 10)
                Sleep 500
                MouseClick "Left"
                Sleep 300
                SelectSign()
                Send("{Enter}")
                Sleep 300
                if WinExist("Management System") {
                    Send("{Enter}")
                    Sleep 300

                    ; check sign in range
                    if (CheckDateInRange(DATE_FROM, DATE_TO)) {
                        HasYLenh := false
                        if (!FindImage(IMAGE_PATH . "check-y-lenh.png")) {
                            HasYLenh := true
                        }
                        FindImageAndMoveMouse(IMAGE_PATH . "ky-so.png", 10, 10)
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
                                    if (FindImageAndMoveMouse(IMAGE_PATH . "goc-phieu-dieu-tri.png")) {
                                        Sleep 300
                                        MouseMove(240, -10, 50, "R")
                                        Sleep 200
                                        if (HasYLenh) {
                                            SignAtPosNotExit(PASS)
                                            Sleep 1000
                                            if WinExist("Thông tin văn bản") {
                                                WinActivate
                                            }
                                            loop {
                                                if (FindImageAndMoveMouse(IMAGE_PATH . "goc-phieu-dieu-tri.png")) {
                                                    Sleep 300
                                                    MouseMove(980, -10, 50, "R")
                                                    Sleep 200
                                                    SignAtPos(PASS)
                                                    Sleep 500
                                                    break
                                                }
                                                Sleep 200
                                                Send("{WheelDown 3}")
                                                Sleep 500
                                            }
                                        } else {
                                            SignAtPos(PASS)
                                        }
                                        break
                                    }
                                    Sleep 200
                                    Send("{WheelDown 3}")
                                    Sleep 500
                                }
                                break
                            }
                            Sleep(1000)
                        }
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
        } else {
            Send("{Enter}")
            Sleep 600
        }

        if (FindImage(IMAGE_PATH . "phieu-dieu-tri-last.png")) {
            Sleep 300
            ; FindImageAndMoveMouse(IMAGE_PATH . "so-benh-an.png")
            ImageSearch(&G, &H, 0, 0, A_ScreenWidth, A_ScreenHeight, IMAGE_PATH . "so-benh-an.png")
            Sleep 300
            MouseMove(G, H)
            Sleep 300
            MouseMove(175, 0, 52, "R")
            Sleep 200
            MouseClick "Left"
            Sleep 200
            if (FindImage(IMAGE_PATH . "het-benh-nhan.png")) {
                MsgBox "Đã ký số toàn bộ phiếu điều trị!"
                break
            }
            Send("{Down}")
            Sleep 300
            Send("{Enter}")
            Sleep 3000
            Send("{Tab}")
            Sleep 100
            Send("{{Tab}}")
            Sleep 300
        } else {
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

CheckDateInRange(DATE_FROM, DATE_TO) {
    Day := FindTextInRegion(355, 130, 355 + 23, 130 + 20)
    Month := FindTextInRegion(355 + 31, 130, 355 + 52, 130 + 20)
    Year := FindTextInRegion(355 + 61, 130, 355 + 93, 130 + 20)

    CheckDate := ""
    if (Day = "") {
        CheckDate := "20001010000000"
    } else {
        CheckDate := Year . Month . Day . "000000"
    }

    IS_IN_DATE_RANGE := DateDiff(CheckDate, DATE_FROM, "Days") >= 0 && DateDiff(DATE_TO, CheckDate, "Days") >= 0

    return IS_IN_DATE_RANGE
}
