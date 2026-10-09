$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
$flutterLocal = Join-Path $env:USERPROFILE 'development\flutter\bin\flutter.bat'
if ($flutterCommand) {
    $flutterExecutable = $flutterCommand.Source
} elseif (Test-Path -LiteralPath $flutterLocal) {
    $flutterExecutable = $flutterLocal
} else {
    throw 'Instale o Flutter e adicione a pasta bin ao PATH.'
}

& $flutterExecutable pub get
if ($LASTEXITCODE -ne 0) { throw 'Falha ao instalar as dependências.' }

$braveExecutable = 'C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe'
if (Test-Path -LiteralPath $braveExecutable) {
    Start-Process -FilePath $braveExecutable -ArgumentList 'http://127.0.0.1:8080'
} else {
    Start-Process 'http://127.0.0.1:8080'
}

Write-Host 'Aguarde a compilação e atualize a página no navegador. Para encerrar, pressione Ctrl+C.'
& $flutterExecutable run -d web-server --web-hostname 127.0.0.1 --web-port 8080
