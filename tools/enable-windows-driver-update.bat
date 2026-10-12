@echo off
:: Ask for Administrator rights (needed to change the registry), then re-run this file
net session >nul 2>&1 || (
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)
title Enable Windows Update Driver Search

echo ===============================================
echo Enable Windows Update Driver Search
echo ===============================================
echo.
echo This will allow Windows Update to search for
echo and install device drivers again.
echo.

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig /t REG_DWORD /d 1 /f

echo.
echo ===============================================
echo Verify settings
echo ===============================================
echo.

reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig

echo.
echo Expected values:
echo ExcludeWUDriversInQualityUpdate = 0x0
echo SearchOrderConfig = 0x1
echo.
echo Please restart Windows after this.
echo.
pause
