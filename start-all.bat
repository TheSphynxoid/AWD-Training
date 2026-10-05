@echo off
REM =====================================================================
REM  AWD-Training - start all microservices in separate CMD windows
REM  Usage: double-click this file, or run:  start-all.bat
REM  Stop:  close the windows, or run  stop-all.bat
REM =====================================================================

set ROOT=%~dp0

echo.
echo  Starting AWD-Training services...
echo.

REM --- 1. Eureka server first: the other services register into it -----
start "1 - discovery (Eureka :8761)" cmd /k "cd /d "%ROOT%backend\discovery" && mvn spring-boot:run"
timeout /t 20 /nobreak >nul

REM --- 2. Spring Boot microservices -------------------------------------
start "2 - candidat (:8081)"   cmd /k "cd /d "%ROOT%backend\microservices\candidat"    && mvn spring-boot:run"
start "3 - job (:8082)"        cmd /k "cd /d "%ROOT%backend\microservices\job"         && mvn spring-boot:run"
start "4 - canditature (:8085)" cmd /k "cd /d "%ROOT%backend\microservices\canditature" && mvn spring-boot:run"

REM --- 3. Node.js and Python microservices ------------------------------
start "5 - meeting (:8083)"       cmd /k "cd /d "%ROOT%backend\microservices\meeting"      && npm start"
start "6 - notification (:8084)"  cmd /k "cd /d "%ROOT%backend\microservices\notification" && venv\Scripts\python.exe -m uvicorn app.main:app --port 8084"

echo  Eureka dashboard : http://localhost:8761
echo  meeting          : http://localhost:8083/swagger-ui
echo  notification     : http://localhost:8084/swagger-ui
echo.
echo  Note: the Spring services take ~20-30s each to appear in the dashboard.
echo  Run stop-all.bat to close everything.
echo.
