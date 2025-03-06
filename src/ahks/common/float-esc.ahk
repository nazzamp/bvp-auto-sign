#Requires AutoHotkey v2.0

FloatEscButton() {
    ButtonClick(*) {
        ExitApp
    }

    CornerPos := 300

    MyGui := Gui("+AlwaysOnTop +ToolWindow -Caption +Border", "Floating Button")
    MyGui.SetFont("s11 cRed bold", "Arial")
    MyButton := MyGui.Add("Text", "Center w140 h40", "Bấm ESC để thoát")
    MyButton.OnEvent("Click", ButtonClick)

    ; Add a red border using a separate GUI
    BorderGui := Gui("+AlwaysOnTop +ToolWindow -Caption +E0x20", "Border") ; E0x20 makes it click-through
    BorderGui.BackColor := "Red"
    BorderGui.Show("x" . A_ScreenWidth - CornerPos - 2 . " y" . A_ScreenHeight - CornerPos - 2 . " w176 h64") ; Adjust size to create a border

    MyGui.Show("x" . A_ScreenWidth - CornerPos . " " . "y" . A_ScreenHeight - CornerPos)
}
