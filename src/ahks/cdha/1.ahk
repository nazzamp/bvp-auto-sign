#Requires AutoHotkey v2.0
#Include ../common/find-text.ahk

Esc:: ExitApp

PASS := A_Args[1]
IMAGE_PATH := A_Args[2]

F9::
{
    try {
        CoordMode "Pixel", "Screen"

        if WinExist("FPT")
            WinActivate

        Width := A_ScreenWidth
        Height := A_ScreenHeight

        result := ImageSearch(&OutputVarX, &OutputVarY, 0, 0, Width, Height, IMAGE_PATH . "save.png")
        if (result = 1) {
            MouseMove(OutputVarX + 20, OutputVarY)
            MouseClick 'Left'
            Sleep 1000
        }

        ImageSearch(&OutputVarX, &OutputVarY, 0, 0, Width, Height, IMAGE_PATH . "ky-so.png")
        MouseMove(OutputVarX + 30, OutputVarY - 10)

        MouseClick 'Left'
        Sleep 1000

        Send("{Enter}")
        Sleep 1000

        loop {
            if WinExist("Thông tin văn bản") {
                WinActivate
                Sleep 200
                Send("#{Up}")
                Sleep 200
                MouseMove(A_ScreenWidth / 2, A_ScreenHeight / 2)
                break
            }
            Sleep(1000)
        }

        loop {
            if (FindTextAndMoveMouse("Bs.")) {
                Sleep 500
                MouseMove(-140, -10, 50, "R")
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
                Sleep 200
                Send "{WheelDown 3}"
                Sleep 300
            }
            if (A_Index = 15) {
                break
            }
        }

        Sleep 1000

        return
    } catch Error {

    }
}
