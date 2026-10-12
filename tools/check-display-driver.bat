@echo off
title Check Display Driver Version

echo ===============================================
echo Check Display Driver Version
echo ===============================================
echo.

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -Command "Get-CimInstance Win32_VideoController | Format-List Name,PNPDeviceID,DriverVersion,DriverDate,Status"

echo ===============================================
echo Windows Update driver status
echo ===============================================
echo.

C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -Command "$wu = (Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -ErrorAction SilentlyContinue).ExcludeWUDriversInQualityUpdate; $so = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' -ErrorAction SilentlyContinue).SearchOrderConfig; if ($wu -eq 1) { Write-Host 'Windows Update drivers : BLOCKED (disable script was run)' -ForegroundColor Yellow } else { Write-Host 'Windows Update drivers : ALLOWED (Windows default)' -ForegroundColor Green }; if ($so -eq 0) { Write-Host 'Auto driver search     : BLOCKED' -ForegroundColor Yellow } else { Write-Host 'Auto driver search     : ALLOWED (Windows default)' -ForegroundColor Green }"

echo.
pause
