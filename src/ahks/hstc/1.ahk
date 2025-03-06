#Requires AutoHotkey v2.0
#Include ../common/find-text.ahk
#Include ../common/sign.ahk
#Include ../common/find.ahk
#Include ../common/float-esc.ahk

Esc:: ExitApp
FloatEscButton()
BlockInput "MouseMove"

PASS := A_Args[1]
IMAGE_PATH := A_Args[2]
DATE_FROM := A_Args[3]
DATE_TO := A_Args[4]

if WinExist("FPT") {
    WinActivate
    Sleep 300
    Send("^r")
    Sleep 6000
    FindImageAndMoveMouse(IMAGE_PATH . "so-benh-an.png", 140, -10)
    Sleep 300
    MouseClick "Left"
    Sleep 300
    CheckKy()
    Send("{Tab}")
    Sleep 300
    Send("{{Tab}}")
    Sleep 300
    loop {
        IsSmallerDate := 0

        Send("{Space}")
        Sleep 500

        if (!FindImage(IMAGE_PATH . "lua-chon-vtyt.png")) {
            if (FindImage(IMAGE_PATH . "loi-ky-lap.png", 80)) {
                MsgBox "Lỗi ký lặp, vui lòng thử lại!"
                ExitApp
            }
            FindImageAndMoveMouse(IMAGE_PATH . "edit.png", 10, 0)
            Sleep 300
            MouseClick "Left"
            Sleep 500
            MouseMove(0, 0, 100)
            Sleep 500

            ; check sign in range
            CheckDateValue := CheckDate(DATE_FROM, DATE_TO)

            if (CheckDateValue = -1) {
                IsSmallerDate := 1
            }

            if (!FindImage(IMAGE_PATH . "khong-xoa-duoc.png")) {
                if (!FindImageAndMoveMouse(IMAGE_PATH . "skip.png", 10, 0)) {
                    MsgBox "Lỗi tự động ký, vui lòng thử lại!"
                    ExitApp
                }
                Sleep 500
                MouseClick 'Left'
                Sleep 300
                Send('{Tab}')
                Sleep 500
                if (FindImageAndMoveMouse(IMAGE_PATH . "xem-ky-so.png", 20, -10)) {
                    Sleep 500
                    MouseClick "Left"
                    Sleep 300
                    SelectSign()
                    Send("{Enter}")
                    Sleep 300
                    loop {
                        if (WinExist("Management System") || WinExist("Thông tin")) {
                            break
                        }
                    }
                    if WinExist("Management System") {
                        Send("{Enter}")
                        Sleep 300
                        if (CheckDateValue = 1) {
                            HasYLenh := false
                            if (!FindImage(IMAGE_PATH . "check-y-lenh.png") || FindImage(IMAGE_PATH . "co-thuoc.png",
                                50)) {
                                HasYLenh := true
                            }
                            Sleep 300
                            FindImageAndMoveMouse(IMAGE_PATH . "ky-so.png", 20, -10)
                            Sleep 300
                            MouseClick "Left"
                            Sleep 300
                            SelectSign()
                            Sleep 300
                            Send("{Enter}")
                            Sleep 300
                            loop {
                                if (WinExist("Nghiệp vụ ký số")) {
                                    break
                                }
                            }
                            Send("{Enter}")
                            Sleep 300
                            loop {
                                if WinExist("Thông tin văn bản") {
                                    WinActivate
                                    Sleep 200
                                    Send("#{Up}")
                                    Sleep 1000
                                    loop {
                                        if (FindImageAndMoveMouse(IMAGE_PATH . "goc-phieu-dieu-tri.png", 0, 0, 150) ||
                                        FindImageAndMoveMouse(IMAGE_PATH . "goc-phieu-dieu-tri-1.png", 0, 0, 150)) {
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
                                                    if (FindImageAndMoveMouse(IMAGE_PATH . "goc-phieu-dieu-tri.png", 0,
                                                        0,
                                                        150) || FindImageAndMoveMouse(IMAGE_PATH .
                                                            "goc-phieu-dieu-tri-1.png", 0, 0, 150)) {
                                                        Sleep 300
                                                        MouseMove(980, -10, 50, "R")
                                                        Sleep 200
                                                        SignAtPos(PASS)
                                                        Sleep 500
                                                        break
                                                    }
                                                    Sleep 300
                                                    Send("{WheelDown 3}")
                                                    Sleep 500
                                                }
                                            } else {
                                                SignAtPos(PASS)
                                            }
                                            break
                                        }
                                        Sleep 300
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
                            Sleep 500
                            Send("!{F4}")
                            Sleep 500
                        }
                    }
                }
            } else {
                Send("{Enter}")
                Sleep 600
            }
        }

        if (FindImage(IMAGE_PATH . "phieu-dieu-tri-last.png", 50) || FindImage(IMAGE_PATH . "phieu-dieu-tri-last-1.png",
            50) || IsSmallerDate) {
            Sleep 300
            FindImageAndMoveMouse(IMAGE_PATH . "so-benh-an.png", 175, -10)
            Sleep 300
            MouseClick "Left"
            Sleep 500
            if (FindImage(IMAGE_PATH . "het-benh-nhan.png", 80)) {
                MsgBox "Đã ký số toàn bộ phiếu điều trị!"
                ExitApp
                break
            }
            Send("{Down}")
            Sleep 300
            Send("{Enter}")
            Sleep 10000
            CheckKy()
            Send("{Tab}")
            Sleep 500
            Send("{{Tab}}")
            Sleep 500
        } else {
            Sleep 500
            Send("{Space}")
            Sleep 800
            Send("{Down}")
            Sleep 800
            if (FindImage(IMAGE_PATH . "chuyen-khoa.png", 30)) {
                Send("{Down}")
                Sleep 500
            }
        }
    }
}

SelectSign() {
    Send("{Tab}")
    Sleep 400
    Send("{Tab}")
    Sleep 400
    Send("{Space}")
    Sleep 400
    Send("{Enter}")
    Sleep 400
    Send("{Enter}")
    Sleep 400
}

CheckDate(DATE_FROM, DATE_TO) {
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
    IS_DATE_SMALLER := DateDiff(CheckDate, DATE_FROM, "Days") < 0
    if (IS_IN_DATE_RANGE) {
        return 1
    }
    if (IS_DATE_SMALLER) {
        return -1
    }
    return 0
}

FoundError() {
    MsgBox 'Quá trình tự động ký lỗi, vui lòng thực hiện lại!'
    ExitApp
}

CheckKy() {
    if (!FindImage(IMAGE_PATH . "check-dieu-kien-ky.png", 80)) {
        MsgBox "Thực hiện sai thao tác, vui lòng thực hiện lại!"
        ExitApp
    }
}
