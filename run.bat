@echo off
setlocal
cd /d "%~dp0"

set "JARVIS_PORT=8795"
set "JARVIS_URL=http://127.0.0.1:%JARVIS_PORT%/stage.html"

echo Starting Jarvis...

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $p=(Get-Location).Path; $port='%JARVIS_PORT%'; $url='%JARVIS_URL%'; $cfg=Join-Path $p 'barehands.json'; $utf8=New-Object System.Text.UTF8Encoding($false); if (-not (Test-Path $cfg)) { [IO.File]::WriteAllText($cfg, ('{\"port\": ' + $port + '}'), $utf8); Write-Host ('Created ' + $cfg + ' (port ' + $port + ')') } try { $r=Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 2; if ($r.StatusCode -eq 200) { Start-Process 'chrome.exe' $url; Write-Host ('Jarvis already running: ' + $url); exit 0 } } catch {}; $backup=[IO.File]::ReadAllText($cfg); $tmp=$backup -replace '\"port\"\s*:\s*\d+', ('\"port\": ' + $port); [IO.File]::WriteAllText($cfg,$tmp,$utf8); try { $py=$null; foreach ($c in 'python.exe','py.exe','python3.exe') { try { $py=(Get-Command $c -ErrorAction Stop).Source; break } catch {} }; if (-not $py) { throw 'Python not found on PATH' }; $proc=Start-Process -FilePath $py -ArgumentList 'server.py' -WorkingDirectory $p -WindowStyle Hidden -PassThru; Start-Sleep -Seconds 2; Start-Process 'chrome.exe' $url; Write-Host ('Jarvis started on ' + $url + ' (PID ' + $proc.Id + ')') } finally { if ([IO.File]::ReadAllText($cfg) -ne $backup) { [IO.File]::WriteAllText($cfg,$backup,$utf8) } }"

if errorlevel 1 (echo Failed to start Jarvis. & pause & exit /b 1)

echo Jarvis is available at %JARVIS_URL%
endlocal
