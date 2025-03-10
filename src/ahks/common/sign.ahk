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
            Sleep 6000
            if (WinExist("Error")) {
                WinActivate
                Sleep 500
                Send("!{F4}")
                Sleep 500
                Send("!{F4}")
                Sleep 500
                Send("!{F4}")
                break
            }
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
    Sleep 500
    loop {
        if WinExist("Thông tin văn bản") {
            WinActivate
            Send("!{F4}")
            Sleep 800
            if WinExist("Nghiệp vụ") {
                WinActivate
                Send("!{F4}")
                Sleep 800
                break
            }
        }
        Sleep 1000
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
            Sleep 6000
            if (WinExist("Error")) {
                WinActivate
                Sleep 500
                Send("!{F4}")
                Sleep 500
                Send("!{F4}")
                Sleep 500
                Send("!{F4}")
                break
            }
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
