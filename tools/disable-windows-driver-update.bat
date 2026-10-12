@echo off
:: Ask for Administrator rights (needed to change the registry), then re-run this file
net session >nul 2>&1 || (
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)
title Disable Windows Update Driver Override

echo ===============================================
echo Disable Windows Update Driver Override
echo ===============================================
echo.
echo This will prevent Windows Update from automatically
echo replacing installed device drivers.
echo.

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig /t REG_DWORD /d 0 /f

echo.
echo ===============================================
echo Verify settings
echo ===============================================
echo.

reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ExcludeWUDriversInQualityUpdate
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig

echo.
echo Expected values:
echo ExcludeWUDriversInQualityUpdate = 0x1
echo SearchOrderConfig = 0x0
echo.
echo ===============================================
echo Maker apps that can still update drivers
echo ===============================================
echo.
echo This script only stops Windows Update. Apps from the PC or GPU maker
echo can still install drivers by themselves.
echo.

powershell -NoProfile -Command "$apps = [ordered]@{ 'NVIDIA App / GeForce Experience' = @('NvContainerLocalSystem'); 'AMD Software' = @('AMD External Events Utility'); 'Intel Driver & Support Assistant' = @('DSAService'); 'ASUS Armoury Crate' = @('ArmouryCrateService'); 'MyASUS' = @('ASUSSoftwareManager','ASUSOptimization'); 'Dell SupportAssist' = @('SupportAssistAgent'); 'Dell Command Update' = @('DellClientManagementService'); 'Lenovo Vantage' = @('ImControllerService'); 'HP Support Assistant' = @('HPAppHelperCap','HPSysInfoCap') }; $found = 0; foreach ($k in $apps.Keys) { if (Get-Service -Name $apps[$k] -ErrorAction SilentlyContinue) { Write-Host ('  FOUND: ' + $k + '  -> turn off automatic driver updates in this app') -ForegroundColor Yellow; $found++ } }; if (-not $found) { Write-Host '  None found.' -ForegroundColor Green }"

echo.
echo Please restart Windows after this.
echo.
pause
