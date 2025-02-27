#Requires AutoHotkey v2.0
#Include screen-shot.ahk ;

FindTextAndMoveMouse(TextToFind) {
    CoordMode "Mouse", "Screen"

    Width := A_ScreenWidth
    Height := A_ScreenHeight

    SaveScreenShot(0, 0, Width, Height, 'screen.png', 'png') ;
    RunWait('tesseract screen.png output -l vie tsv', , 'Hide')
    OCROutput := FileRead('output.tsv', "UTF-8")
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
    RunWait('tesseract screen.png output -l vie tsv', , 'Hide')
    OCROutput := FileRead('output.tsv', "UTF-8")
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

FindDoctorName() {
    CoordMode "Mouse", "Screen"

    Width := A_ScreenWidth
    Height := A_ScreenHeight
    LastWord := ''
    IsContinuedString := false

    SaveScreenShot(0, 0, Width, Height, 'screen.png', 'png') ;
    RunWait('tesseract screen.png output -l vie tsv', , 'Hide')
    OCROutput := FileRead('output.tsv', "UTF-8")
    Result := FindText(OCROutput)

    ; Clean up
    FileDelete('screen.png')
    FileDelete('output.tsv')

    FindText(OCROutput) {
        Lines := StrSplit(OCROutput, "`n", "`r")
        for Line in Lines {
            if (A_Index = 1)
                continue

            Fields := StrSplit(Line, "`t")

            if (Fields.Length < 12)
                continue

            if (Fields[12] = "Sĩ") {
                PrevLine := StrSplit(Lines[A_Index - 1], "`t")
                PrevLine1 := StrSplit(Lines[A_Index + 1], "`t")
                PrevLine2 := StrSplit(Lines[A_Index + 2], "`t")
                if (PrevLine[12] = "Bắc") {
                    return PrevLine1[12] . ' ' . PrevLine2[12]
                }
            }
        }
        return ""
    }

    return Result
}

FindDoctorSignTreatment(docName) {
    CoordMode "Mouse", "Screen"

    Width := A_ScreenWidth
    Height := A_ScreenHeight
    LastWord := ''
    IsContinuedString := false

    SaveScreenShot(0, 0, Width, Height, 'screen.png', 'png') ;
    RunWait('tesseract screen.png output -l vie tsv', , 'Hide')
    OCROutput := FileRead('output.tsv', "UTF-8")
    Result := FindText(OCROutput)

    ; Clean up
    FileDelete('screen.png')
    FileDelete('output.tsv')

    FindText(OCROutput) {
        Lines := StrSplit(OCROutput, "`n", "`r")
        docNameArr := StrSplit(docName, " ")

        for Line in Lines {
            if (A_Index = 1)
                continue

            Fields := StrSplit(Line, "`t")

            if (Fields.Length < 12)
                continue

            if (Fields[12] = docNameArr[2]) {
                PrevLine := StrSplit(Lines[A_Index - 1], "`t")
                NextLine1 := StrSplit(Lines[A_Index + 2], "`t")
                NextLine2 := StrSplit(Lines[A_Index + 3], "`t")
                NextLine3 := StrSplit(Lines[A_Index + 4], "`t")
                if (PrevLine[12] = docNameArr[1]) {
                    X := Fields[7]
                    Y := Fields[8]
                    IsSignMore := false
                    if (docNameArr[1] = NextLine1[12]) {
                        return [{ X: X, Y: Y }, { X: NextLine1[7], Y: NextLine1[8] }]
                    }
                    if (docNameArr[1] = NextLine2[12]) {
                        return [{ X: X, Y: Y }, { X: NextLine2[7], Y: NextLine2[8] }]
                    }
                    if (docNameArr[1] = NextLine3[12]) {
                        return [{ X: X, Y: Y }, { X: NextLine3[7], Y: NextLine3[8] }]
                    }
                    return [{ X: X, Y: Y }]
                }
            }
        }
        return []
    }
    return Result
}

Log(msg) {
    FileAppend msg "`n", "*"
}
