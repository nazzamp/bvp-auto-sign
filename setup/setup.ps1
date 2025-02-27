Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install autohotkey
choco install tesseract

$url = "https://raw.githubusercontent.com/tesseract-ocr/tessdata/refs/heads/main/vie.traineddata"
$tesseractFolder = "C:\Program Files\Tesseract-OCR\tessdata"
$destinationFile = Join-Path -Path $tesseractFolder -ChildPath "vie.traineddata"
Invoke-WebRequest -Uri $url -OutFile $destinationFile
Write-Host "Vietnamese trained data file downloaded to $destinationFile"

exit

