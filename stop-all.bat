@echo off
REM =====================================================================
REM  AWD-Training - stop all microservices started by start-all.bat
REM  Kills only the processes listening on the workshop ports.
REM =====================================================================

echo.
echo  Stopping AWD-Training services...
echo.

for %%P in (8761 8081 8082 8083 8084 8085) do (
    for /f "tokens=5" %%I in ('netstat -ano ^| findstr ":%%P " ^| findstr LISTENING') do (
        echo  Port %%P -^> killing PID %%I
        taskkill /PID %%I /F /T >nul 2>&1
    )
)

REM uvicorn --reload leaves an orphaned multiprocessing child behind.
for /f "tokens=2" %%I in ('tasklist /FI "IMAGENAME eq python.exe" /NH') do (
    wmic process where "ProcessId=%%I" get CommandLine 2> nul | findstr /i "uvicorn app.main" >nul && (
        echo  Killing orphaned uvicorn PID %%I
        taskkill /PID %%I /F /T >nul 2>&1
    )
)

echo.
echo  Done. Anything still running can be closed with its CMD window.
echo.
pause
