#Requires AutoHotkey v2.0
#Include ../common/find-text.ahk

PASS := A_Args[1]

F9::
{
    MyGui := Gui()

    CloseApp(*) {
        MyGui.Destroy()
    }

    try {
        MyGui.Title := "Script Progress"
        StepText := MyGui.Add("Text", "w300", "Step: Initializing...")

        StopButton := MyGui.Add("Button", "w100", "Close")
        StopButton.OnEvent("Click", CloseApp)

        MyGui.Show()

        ; Function to update the step text in the GUI
        UpdateStep(stepName) {
            StepText.Text := "Step: " stepName
        }

        ; Simulate your script steps
        UpdateStep("Setting CoordMode")
        CoordMode "Pixel", "Screen"

        UpdateStep("Activating FPT Window")
        if WinExist("FPT")
            WinActivate

        UpdateStep("Getting Screen Dimensions")
        Width := A_ScreenWidth
        Height := A_ScreenHeight

        UpdateStep("Searching for Image")
        if (FindTextAndMoveMouse("Lưu")) {
            Sleep 200
            MouseClick 'Left'
            Sleep 200
            if WinExist("FPT")
                WinActivate
        }

        UpdateStep("Searching for Image")
        if (FindTextAndMoveMouse("NhânSự")) {
            Sleep 200
            MouseMove(30, 40, 50, 'R')
            Sleep 100
            MouseClick "Left"
            Sleep 500
        }

        UpdateStep("Clicking Mouse")
        MouseClick 'Left'
        Sleep 1000

        UpdateStep("Sending Enter Key")
        Send("{Enter}")
        Sleep 1000

        UpdateStep("Waiting for 'Thông tin văn bản' Window")
        loop {
            if WinExist("Thông tin văn bản") {
                WinActivate
                break
            }
            Sleep(500)
        }

        UpdateStep("Searching for Text and Moving Mouse")
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

        UpdateStep("Script Completed")
        Sleep 1000
        CloseApp

        return
    } catch Error {
        UpdateStep("Script failed! Please try again!")
        CloseApp
    }
}
