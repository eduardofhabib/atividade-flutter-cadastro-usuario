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

Write-Host 'Aguarde a compilacao e abra no navegador o endereco informado pelo Flutter.'
Write-Host 'Para encerrar, pressione Ctrl+C.'
& $flutterExecutable run -d web-server --web-hostname 127.0.0.1
