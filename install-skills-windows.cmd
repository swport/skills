@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SOURCE_ROOT=%~dp0"
if "%SOURCE_ROOT:~-1%"=="\" set "SOURCE_ROOT=%SOURCE_ROOT:~0,-1%"

for %%D in ("agents") do (
  set "DEST_BASE=%USERPROFILE%\.%%~D"
  set "SKILLS_DEST=!DEST_BASE!\skills"
  set "PROMPTS_DEST=!DEST_BASE!\prompts"
  
  if not exist "!SKILLS_DEST!" mkdir "!SKILLS_DEST!"
  if not exist "!PROMPTS_DEST!" mkdir "!PROMPTS_DEST!"
  
  set /a SKILLS_COPIED=0
  set /a PROMPTS_COPIED=0
  
  REM Copy skills
  for /r "%SOURCE_ROOT%" %%F in (SKILL.md) do (
    set "SKILL_DIR=%%~dpF"
    if "!SKILL_DIR:~-1!"=="\" set "SKILL_DIR=!SKILL_DIR:~0,-1!"
  
    set "IS_HIDDEN=0"
    echo !SKILL_DIR! | findstr /R /C:"\\\.[^\\]*" >nul && set "IS_HIDDEN=1"
  
    for %%S in ("!SKILL_DIR!") do set "SKILL_NAME=%%~nxS"
    set "TARGET_DIR=!SKILLS_DEST!\!SKILL_NAME!"
  
    if "!IS_HIDDEN!"=="0" if /I not "!SKILL_DIR!"=="!TARGET_DIR!" (
      if exist "!TARGET_DIR!" rmdir /s /q "!TARGET_DIR!"
      xcopy "!SKILL_DIR!" "!TARGET_DIR!" /E /I /H /Y >nul
      if not errorlevel 1 set /a SKILLS_COPIED+=1
    )
  )
  
  REM Copy prompts
  for /r "%SOURCE_ROOT%" %%F in (*.prompt.md) do (
    set "PROMPT_DIR=%%~dpF"
    if "!PROMPT_DIR:~-1!"=="\" set "PROMPT_DIR=!PROMPT_DIR:~0,-1!"
  
    set "IS_HIDDEN=0"
    echo !PROMPT_DIR! | findstr /R /C:"\\\.[^\\]*" >nul && set "IS_HIDDEN=1"
  
    for %%P in ("%%F") do set "PROMPT_NAME=%%~nxP"
    set "TARGET_PROMPT=!PROMPTS_DEST!\!PROMPT_NAME!"
  
    if "!IS_HIDDEN!"=="0" (
      copy /Y "%%F" "!TARGET_PROMPT!" >nul
      if not errorlevel 1 set /a PROMPTS_COPIED+=1
    )
  )
  
  echo Copied !SKILLS_COPIED! skill^(s^) to !SKILLS_DEST!
  echo Copied !PROMPTS_COPIED! prompt^(s^) to !PROMPTS_DEST!
)
endlocal
