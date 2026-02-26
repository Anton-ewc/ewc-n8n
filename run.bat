@echo off
title n8n win docker
color 0A

:menu
echo ==========================
echo      Select an action
echo ==========================
echo 1. Build
echo 2. Run
echo 3. Exit
echo ==========================
set /p choice=Enter your choice [1-3]: 

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
echo Running Build of n8n
docker build -t n8n:tag1 .
echo.
pause
cls
goto menu

:action2
echo.
echo Running the n8n docker
rem docker run -d -v $(local_path)/n8n:/home/node/.n8n -p 5678:5678 --env-file .env n8n:tag1
set LOCAL_PATH=%~dp0

docker run -d ^
  -v "%LOCAL_PATH%n8n:/home/node/.n8n" ^
  -p 5678:5678 ^
  --env-file "%LOCAL_PATH%.env" ^
  --name n8n n8n:tag1

echo.
pause
cls
goto menu

:exit_script
echo Exiting script...
rem pause
exit
