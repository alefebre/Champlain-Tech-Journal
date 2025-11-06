@echo off

REM This script will collect volatile information from a Windows system.

:TKT
set /p TKTNUM=What is the ticket number for this report? (e.g. 0001):
ECHO You entered: "%TKTNUM%"
set /p CHKTKT=Is this correct? (y/n)
If /i "%CHKTKT%"=="n" goto :TKT
cls

:USR
set /p USRNAME=Enter the userID authenticated at the time of the incident (e.g. bmookie):
ECHO You entered: "%USRNAME%"
set /p USR=Is this correct? (y/n)
If /i "%USR%"=="n" goto :USR
cls

REM Create location to save results
mkdir %TKTNUM%-%COMPUTERNAME%-Results
set resultsDir=%TKTNUM%-%COMPUTERNAME%-Results

REM Run commands to collect system information.
echo "Collecting Running Processes..."
tasklist /svc /FO table > "%resultsDir%\tasklist.txt"
echo "Collection Complete"
echo.

echo "Collecting network statistics..."
netstat -an > "%resultsDir%\netstat.txt"
echo "Collection Complete"
echo.

echo "Collecting directory structure of C:\ drive..."
tree C:\ /F /A > "%resultsDir%\directory_structure.txt"
echo "Collection Complete"
echo.

echo "Collecting hardware, os, and network information..."
systeminfo > "%resultsDir%\system_info.txt"
echo "Collection Complete"
echo.

echo "Your information is available under the %TKTNUM%-%COMPUTERNAME%-Results directory."
timeout /t 15
