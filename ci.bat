@echo off

if exist package-lock.json (
  call npm ci
) else (
  call npm install
)
if errorlevel 1 exit /b %ERRORLEVEL%

call npm run build
if errorlevel 1 exit /b %ERRORLEVEL%

call npm test
if errorlevel 1 exit /b %ERRORLEVEL%

call npm start
if errorlevel 1 exit /b %ERRORLEVEL%
