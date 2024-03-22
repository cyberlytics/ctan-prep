@echo off 
cd /D "%~dp0" 
pwsh.exe -command "docker image prune -a" 
pause 
