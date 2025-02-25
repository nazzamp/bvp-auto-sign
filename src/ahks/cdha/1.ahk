#Requires AutoHotkey v2.0
#Include ../common/find-text.ahk

PASS := "082406"

^F9::
{
    CoordMode "Pixel", "Screen"

    if WinExist("FPT")
        WinActivate

    Width := A_ScreenWidth
    Height := A_ScreenHeight

    ImageSearch(&OutputVarX, &OutputVarY, 0, 0, Width, Height,
        "test-2.png")
    MouseMove(OutputVarX + 30, OutputVarY - 5)

    MouseClick 'Left'
    Sleep 1000

    Send("{Enter}")
    Sleep 1000

    loop {
        if WinExist("Thông tin văn bản") {
            WinActivate
            break
        }
        Sleep(500)
    }

    loop {
        if (FindTextAndMoveMouse("Bs.")) {
            Sleep 500
            MouseMove(-70, -10, 50, "R")
            Sleep 100
            MouseClick "Left", , , 2
            Sleep 500
            Send("{Enter}")
            Sleep 1000
            loop {
                if WinExist("Security") {
                    WinActivate
                    SendInput(PASS)
                    Sleep 300
                    Send("{Enter}")
                    Sleep 3000
                    if (WinExist("Security")) {
                        WinActivate
                        SendInput(PASS)
                        Sleep 300
                        Send("{Enter}")
                        Sleep 2000
                    }
                }
                Sleep 1000
                if (A_Index = 3) {
                    break
                }
            }
            if WinExist("Thông tin văn bản") {
                WinActivate
                Send("!{F4}")
                Sleep 500
                if WinExist("Nghiệp vụ") {
                    WinActivate
                    Send("!{F4}")
                    Sleep 500
                }
            }
            break
        } else {
            if WinExist("Thông tin văn bản") {
                WinActivate
            }
            MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2)
            Sleep 200
            Send "{WheelDown 3}"
            Sleep 300
        }
        if (A_Index = 15) {
            break
        }
    }

    return
}
