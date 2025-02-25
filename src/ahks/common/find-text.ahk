#Requires AutoHotkey v2.0
#Include screen-shot.ahk ;

FindTextAndMoveMouse(TextToFind) {
    CoordMode "Mouse", "Screen"

    Width := A_ScreenWidth
    Height := A_ScreenHeight

    SaveScreenShot(0, 0, Width, Height, 'screen.png', 'png') ;
    RunWait('tesseract screen.png output -l eng tsv', , 'Hide')
    OCROutput := FileRead('output.tsv')
    FoundPos := FindTextPosition(OCROutput, TextToFind)

    if (FoundPos != "") {
        MouseMove(FoundPos.X, FoundPos.Y)
    } else {
        ; MsgBox('Text not found.')
    }

    ; Clean up
    FileDelete('screen.png')
    FileDelete('output.tsv')

    FindTextPosition(OCROutput, TextToFind) {
        for Line in StrSplit(OCROutput, "`n", "`r") {
            if (A_Index = 1)
                continue

            Fields := StrSplit(Line, "`t")

            if (Fields.Length < 12)
                continue

            if (Fields[12] = TextToFind) {
                X := Fields[7]
                Y := Fields[8]
                Width := Fields[9]
                Height := Fields[10]
                CenterX := X + (Width / 2)
                CenterY := Y + (Height / 2)
                return { X: CenterX, Y: CenterY }
            }
        }
        return ""
    }
    return FoundPos != ""
}

FindTextArrayAndMoveMouse(TextArr) {
    CoordMode "Mouse", "Screen"

    Width := A_ScreenWidth
    Height := A_ScreenHeight
    LastWord := ''
    IsContinuedString := false

    SaveScreenShot(0, 0, Width, Height, 'screen.png', 'png') ;
    RunWait('tesseract screen.png output -l eng tsv', , 'Hide')
    OCROutput := FileRead('output.tsv')
    FoundPos := FindTextPosition(OCROutput, TextArr)

    if (FoundPos != "") {
        MouseMove(FoundPos.X, FoundPos.Y)
    }

    ; Clean up
    FileDelete('screen.png')
    FileDelete('output.tsv')

    FindTextPosition(OCROutput, TextArr) {
        Lines := StrSplit(OCROutput, "`n", "`r")
        for Line in Lines {
            if (A_Index = 1)
                continue

            Fields := StrSplit(Line, "`t")

            if (Fields.Length < 12)
                continue

            if (Fields[12] = TextArr[2]) {
                PrevLine := StrSplit(Lines[A_Index - 1], "`t")
                if (PrevLine[12] = TextArr[1]) {
                    X := Fields[7]
                    Y := Fields[8]
                    Width := Fields[9]
                    Height := Fields[10]
                    CenterX := X + (Width / 2)
                    CenterY := Y + (Height / 2)
                    return { X: CenterX, Y: CenterY }
                }
            }
        }
        return ""
    }

    return FoundPos != ""
}

Log(msg) {
    FileAppend msg "`n", "*"
}
