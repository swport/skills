@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SOURCE_ROOT=%~dp0"
if "%SOURCE_ROOT:~-1%"=="\" set "SOURCE_ROOT=%SOURCE_ROOT:~0,-1%"
set "DEST_DIR=%USERPROFILE%\.agents\skills"

if not exist "%DEST_DIR%" mkdir "%DEST_DIR%"

set /a COPIED=0

for /r "%SOURCE_ROOT%" %%F in (SKILL.md) do (
  set "SKILL_DIR=%%~dpF"
  if "!SKILL_DIR:~-1!"=="\" set "SKILL_DIR=!SKILL_DIR:~0,-1!"

  set "IS_HIDDEN=0"
  echo !SKILL_DIR! | findstr /R /C:"\\\.[^\\]*" >nul && set "IS_HIDDEN=1"

  for %%D in ("!SKILL_DIR!") do set "SKILL_NAME=%%~nxD"
  set "TARGET_DIR=%DEST_DIR%\!SKILL_NAME!"

  if "!IS_HIDDEN!"=="0" if /I not "!SKILL_DIR!"=="!TARGET_DIR!" (
    if exist "!TARGET_DIR!" rmdir /s /q "!TARGET_DIR!"
    xcopy "!SKILL_DIR!" "!TARGET_DIR!" /E /I /H /Y >nul
    if not errorlevel 1 set /a COPIED+=1
  )
)

echo Copied !COPIED! skill(s) to %DEST_DIR%
endlocal
