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

    CoordMode "Pixel", "Screen"
    return FoundPos != ""
}

FindTextArrayAndMoveMouse(TextArr) {
    CoordMode "Mouse", "Screen"

    Width := A_ScreenWidth
    Height := A_ScreenHeight
    LastWord := ''
    IsContinuedString := false

    SaveScreenShot(0, 0, Width, Height, 'screen.png', 'png') ;
    RunWait('tesseract screen.png output -l vie tsv --psm 0', , 'Hide')
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

    CoordMode "Pixel", "Screen"
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

    CoordMode "Pixel", "Screen"
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

    CoordMode "Pixel", "Screen"
    return Result
}

Log(msg) {
    FileAppend msg "`n", "*"
}

FindTextInRegion(x1, y1, x2, y2) {
    Width := A_ScreenWidth
    Height := A_ScreenHeight

    SaveScreenShotGrayScale(x1, y1, x2, y2, 'screen.png', 'png', 10) ;
    RunWait('tesseract screen.png output -l vie tsv', , 'Hide')
    OCROutput := FileRead('output.tsv', "UTF-8")
    splitOutput := StrSplit(OCROutput, "`n", "`r")
    if (splitOutput.Length >= 6) {
        Line := splitOutput[6]
        Fields := StrSplit(Line, "`t")
        CleanUp()
        return Fields[12]
    }
    CleanUp()

    return ''
}

FindNameInRegion(x1, y1, x2, y2) {
    Width := A_ScreenWidth
    Height := A_ScreenHeight

    SaveScreenShotGrayScale(x1, y1, x2, y2, 'screen.png', 'png', 10) ;
    RunWait('tesseract screen.png output -l vie tsv', , 'Hide')
    OCROutput := FileRead('output.tsv', "UTF-8")
    splitOutput := StrSplit(OCROutput, "`n", "`r")
    if (splitOutput.Length = 10) {
        name := ''
        for index in [6, 7, 8, 9] {
            if (index = 6) {
                name := value[12]
            } else {
                value := StrSplit(splitOutput[index], "`t")
                name := name . " " . value[12]
            }
        }
        CleanUp()
        return name
    }
    if (splitOutput.Length = 9) {
        name := ''
        for index in [6, 7, 8] {
            value := StrSplit(splitOutput[index], "`t")
            if (index = 6) {
                name := value[12]
            } else {
                name := name . " " . value[12]
            }
        }
        CleanUp()
        return name
    }
    CleanUp()
    return ''
}

CleanUp() {
    FileDelete('screen.png')
    FileDelete('output.tsv')
}
