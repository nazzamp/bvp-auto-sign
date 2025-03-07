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
DOC_NAME := A_Args[3]
DATE_FROM := A_Args[4]
DATE_TO := A_Args[5]

if WinExist("FPT") {
    WinActivate
    Sleep 300
    Send("^r")
    Sleep 5000
    FindImageAndMoveMouse(IMAGE_PATH . "empty-checkbox.png", 10, -10)
    Sleep 500
    MouseClick "Left"
    Sleep 500
    MouseClick "Left"
    Sleep 500
    loop {
        IsSmallerDate := 0

        Send("{Space}")
        Sleep 500

        if (FindImage(IMAGE_PATH . "loi-ky-lap.png", 80)) {
            MsgBox "Lỗi ký lặp, vui lòng thử lại!"
            ExitApp
        }

        if (FindNameInRegion(310, 148, 470, 165) = DOC_NAME) {
            CheckDateValue := CheckDate(DATE_FROM, DATE_TO)
            if (CheckDateValue = -1) {
                IsSmallerDate := 1
            }
            KySo()
        }

        if (IsSmallerDate || FindImage(IMAGE_PATH . "het-phieu-cham-soc.png", 50)) {
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
            Send("{Up}")
            Sleep 800
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

KySo() {
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
                        if (FindImageAndMoveMouse(IMAGE_PATH . "goc-phieu-cham-soc.png", 0, 0, 150)) {
                            Sleep 300
                            MouseMove(-540, 140, 50, "R")
                            Sleep 200
                            SignAtPos(PASS)
                        }
                        Sleep 300
                        Send("{WheelDown 3}")
                        Sleep 500
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
}
