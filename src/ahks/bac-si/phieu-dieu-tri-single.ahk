#Requires AutoHotkey v2.0
#Include ../common/screen-shot.ahk
#Include ../common/find.ahk
#Include ../common/sign.ahk
#Include ../common/float-esc.ahk

Esc:: ExitApp
FloatEscButton()
BlockInput "MouseMove"
CoordMode "Pixel", "Screen"

if WinExist("FPT")
    WinActivate
Sleep 1000

PASS := A_Args[1]
IMAGE_PATH := A_Args[2]
DATE := A_Args[4]

LAST_FIRST_DATE := ""

loop {
    if (FindImage("../images/acer-1920-1080/het-phieu.png")) {
        MsgBox "Hết phiếu!"
        break
    }

    MouseMove(30, 173)
    Sleep 500
    RESULT := TimPhieuDieuTri(65, 173, 246, 312, DATE)

    if (RESULT.foundList.Length > 0) {
        loop RESULT.foundList.Length {
            MouseMove(65 + RESULT.foundList[A_Index].x - 12, 173 + RESULT.foundList[A_Index].y - 20)
            Sleep 500
            MouseClick "Left"
            Sleep 500

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
                        HasYLenh := false
                        if (!FindImage(IMAGE_PATH . "check-y-lenh.png") || FindImage(IMAGE_PATH .
                            "co-thuoc.png",
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
                                    if (FindImageAndMoveMouse(IMAGE_PATH . "goc-phieu-dieu-tri.png", 0, 0,
                                        150) ||
                                    FindImageAndMoveMouse(IMAGE_PATH . "goc-phieu-dieu-tri-1.png", 0, 0,
                                        150)) {
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
                                                if (FindImageAndMoveMouse(IMAGE_PATH .
                                                    "goc-phieu-dieu-tri.png", 0,
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

            MouseMove(65 + RESULT.foundList[A_Index].x - 12, 173 + RESULT.foundList[A_Index].y - 20)
            Sleep 500
            MouseClick "Left"
            Sleep 500

            if (A_Index) = RESULT.foundList.Length {
                ; Scroll after check sign
                Send("{WheelDown 2}")
                Sleep 500
                break
            }
        }
    }

    if (FindImage(IMAGE_PATH . "het-phieu-1.png", 30) || CheckDateSmaller(DATE, RESULT.firstItem)) {
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
        Sleep 500
        Send("{Tab}")
        Sleep 500
        Send("{{Tab}}")
        Sleep 500
    } else {
        Send("{WheelDown 2}")
        Sleep 500
    }
}

TimPhieuDieuTri(x1, y1, x2, y2, date) {
    Width := A_ScreenWidth
    Height := A_ScreenHeight
    Multiple := 6

    SaveScreenShotGrayScale(x1, y1, x2, y2, 'screen.png', 'png', Multiple) ;
    RunWait('tesseract screen.png output -l vie tsv', , 'Hide')
    OCROutput := FileRead('output.tsv', "UTF-8")
    splitOutput := StrSplit(OCROutput, "`n", "`r")

    result := { foundList: [], firstItem: "" }

    for Line in splitOutput {
        Fields := StrSplit(Line, "`t")

        if (A_Index = 1) {
            continue
        }
        if (result.firstItem = '' && (SubStr(Fields[12], 3, 1) = '/')) {
            result.firstItem := Fields[12]
        }

        if (Fields.Length < 12)
            continue

        if (StrCompare(Fields[12], date) = 0) {
            if (!(StrSplit(splitOutput[A_Index + 2], "`t")[12] = "(VTYT)")) {
                X := Fields[7]
                Y := Fields[8]
                result.foundList.Push({ x: X / Multiple, y: Y / Multiple })
            }
        }
    }

    ; CleanUp()
    return result
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

FormatDate(dateCheck) {
    return SubStr(dateCheck, 7, 4) . SubStr(dateCheck, 4, 2) . SubStr(dateCheck, 1, 2) . "000000"
}

CheckDateSmaller(dateCheck, firstDateOfList) {
    formattedCheck := FormatDate(dateCheck)
    formattedFirst := FormatDate(firstDateOfList)

    return DateDiff(formattedCheck, formattedFirst, "Days") > 0
}
