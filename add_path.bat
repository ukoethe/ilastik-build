@echo off
:start
if "%~1"=="" (goto :eof)
set PATH=%~1;%PATH%
SHIFT
goto :start
