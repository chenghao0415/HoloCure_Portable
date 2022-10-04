@echo off

color 97
mode con cols=25 lines=3
title HoloCure Portable

set run_in=%cd%
set rand=%random%

if not exist "%run_in%\app\log.txt" (
	echo [INFO:	%date% %time%] First run!>>"%run_in%\app\log.txt"
) else (
	echo:>>"%run_in%\app\log.txt"
)
echo [INFO:	%date% %time%] Start run!>>"%run_in%\app\log.txt"
echo [DATA:	%date% %time%] USER NAME:%username%>>"%run_in%\app\log.txt"
echo [DATA:	%date% %time%] Run in %cd%>>"%run_in%\app\log.txt"

if not exist "%cd%\app\HoloCure\HoloCure.exe" (
	color 94
	cls
	echo !!!!!error!!!!!
	echo HoloCure.exe not find!
	echo [WARNING:	%date% %time%] %cd%\app\HoloCure\HoloCure.exe not find!>>"%run_in%\app\log.txt"
	ping -w 100 -n 3 0.0.0.0>nul
	color 97
	goto end
)

cd "%cd%\app\HoloCure"
if exist "%localappdata%\HoloCure" (
	set exist=1
	goto create_over
) else (
	set exist=0
)

cls
echo HoloCure Create
echo [INFO:	%date% %time%] Create %cd%\app\HoloCure>>"%run_in%\app\log.txt"
start "" "%cd%\HoloCure.exe"
:create
ping -w 100 -n 1 0.0.0.0>nul
if not exist "%localappdata%\HoloCure\save.dat" (
	goto create
) else (
	taskkill /IM HoloCure.exe /F>nul
)

:create_over

cd "%run_in%"

for /f " " %%i in (%localappdata%\HoloCure\save.dat) do set pc_base64=%%i
for /f " " %%i in (%run_in%\data\HoloCure\save.dat) do set data_base64=%%i
echo %pc_base64:~0,82%%data_base64:~82%>%run_in%\data\HoloCure\save.dat
xcopy "%localappdata%\HoloCure" /c /q /i "%temp%\HoloCure%rand%">nul
rd /q /s "%localappdata%\HoloCure"
echo [INFO:	%date% %time%] Move %localappdata%\HoloCure to %temp%\HoloCure%rand%>>"%run_in%\app\log.txt"

:check_over
xcopy "%run_in%\data\HoloCure" /c /q /i "%localappdata%\HoloCure">nul
echo [INFO:	%date% %time%] Copy %run_in%\data\HoloCure to %localappdata%\HoloCure>>"%run_in%\app\log.txt"

cls
echo HoloCure Start
echo [INFO:	%date% %time%] Start %cd%\app\HoloCure\HoloCure.exe>>"%run_in%\app\log.txt"
cd "%cd%\app\HoloCure"
"%cd%\HoloCure.exe"

rd /q /s "%run_in%\data\HoloCure"
echo [INFO:	%date% %time%] Delete %run_in%\data\HoloCure>>"%run_in%\app\log.txt"
xcopy "%localappdata%\HoloCure" /c /q /i "%run_in%\data\HoloCure">nul
rd /q /s "%localappdata%\HoloCure"
echo [INFO:	%date% %time%] Move %localappdata%\HoloCure to %run_in%\data\HoloCure>>"%run_in%\app\log.txt"

if "%exist%"=="1" (
	xcopy "%temp%\HoloCure%rand%" /c /q /i "%localappdata%\HoloCure">nul
	echo [INFO:	%date% %time%] Move %temp%\HoloCure%rand% to %localappdata%\HoloCure>>"%run_in%\app\log.txt"
)
rd /q /s "%temp%\HoloCure%rand%"

:end
cls
echo HoloCure Stop
echo [INFO:	%date% %time%] Close! >>"%run_in%\app\log.txt"
ping -w 100 -n 2 0.0.0.0>nul
echo [INFO:	%date% %time%] Finish! >>"%run_in%\app\log.txt"
exit