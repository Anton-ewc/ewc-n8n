@echo off
setlocal EnableDelayedExpansion
title n8n win docker
set LOCAL_PATH=%~dp0
set DOCKER_NAME=n8n_postgres
set PORT=5678
color 0A

:menu
echo.
echo  ========================================
echo            n8n - Select an action
echo  ========================================
echo.
echo    LOCAL_PATH:  %LOCAL_PATH%
echo    DOCKER_NAME: %DOCKER_NAME%
echo    PORT: %PORT%
echo.
echo  ----------------------------------------
echo    1.  Build ^& Run
echo    2.  Run
echo    3.  Exit
echo  ========================================
echo.
set /p "choice=  Enter your choice [1-3]: " 

rem Check user input
if "%choice%"=="1" goto action1
if "%choice%"=="2" goto action2
if "%choice%"=="3" goto exit_script

echo Invalid choice. Please try again.
pause
cls
goto menu

:action1
echo.
echo Running Build of n8n (%DOCKER_NAME%)
rem Check if port is already in use (Windows netstat)
netstat -an | findstr "LISTENING" | findstr ":%PORT% " >nul
if not errorlevel 1 (
  powershell.exe -Command Write-Host "Port %PORT% is already in use." -ForegroundColor Red
  powershell.exe -Command Write-Host "Please try again with a different port or type the port for override." -ForegroundColor Yellow
  :type_port
    set /p "NEWPORT=Enter the port for override [default: %PORT%]: "
    if "!NEWPORT!"=="" (
      powershell.exe -Command Write-Host "Invalid port. Please try again." -ForegroundColor Red
      goto type_port
    )
    set /a "portnum=!NEWPORT!" 2>nul
    if not "!portnum!"=="!NEWPORT!" (
      powershell.exe -Command Write-Host "Invalid port. Please try again." -ForegroundColor Red
      goto type_port
    )
    if !portnum! lss 1 (
      powershell.exe -Command Write-Host "Invalid port. Please try again." -ForegroundColor Red
      goto type_port
    ) 

    set "PORT=!NEWPORT!"
    set "DOCKER_BY_PORT="
    for /f "delims=" %%a in ('docker ps --filter "publish=!PORT!" --format "{{.Names}}" 2^>nul') do set "DOCKER_BY_PORT=%%a"
    if defined DOCKER_BY_PORT (
      echo Removing docker container on PORT !PORT! - !DOCKER_BY_PORT!
      echo Docker container "!DOCKER_BY_PORT!" will be removed and replaced with %DOCKER_NAME%
      set /p "overide=  Do you want to override [Y/n]: "
      if /i "!overide!"=="Y" (
        (docker stop !DOCKER_BY_PORT!) 2>nul
        (docker rm -f !DOCKER_BY_PORT!) 2>nul
      ) else (
        cls
        goto menu
      )
    )
    goto run_after_port_check
)
:run_after_port_check

docker build --no-cache -t %DOCKER_NAME% .
if errorlevel 1 (
  echo Build failed.
  pause
  cls
  goto menu
)
docker rm -f %DOCKER_NAME% 2>nul
docker run -d ^
  -v "%LOCAL_PATH%n8n:/home/node/.n8n-files" ^
  -p %PORT%:5678 ^
  --env-file "%LOCAL_PATH%.env" ^
  --name %DOCKER_NAME% %DOCKER_NAME%
echo.
pause
cls
goto menu

:action2
echo.
echo Running the n8n docker
netstat -an | findstr "LISTENING" | findstr ":%PORT% " >nul
if not errorlevel 1 (
  echo Port %PORT% is already in use. Please try again with a different port.
  pause
  cls
  goto menu
)
docker rm -f %DOCKER_NAME% 2>nul
docker run -d ^
  -v "%LOCAL_PATH%n8n:/home/node/.n8n-files" ^
  -p %PORT%:5678 ^
  --env-file "%LOCAL_PATH%.env" ^
  --name %DOCKER_NAME% %DOCKER_NAME%

echo.
pause
cls
goto menu

:exit_script
echo Exiting script...
rem pause
exit
