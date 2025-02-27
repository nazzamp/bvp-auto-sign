#Requires AutoHotkey v2.0

SignAtPos(PASS) {
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
}

SignAtPosNotExit(PASS) {
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
}
