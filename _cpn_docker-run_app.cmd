@echo off 
cd /D "%~dp0" 
pwsh.exe -command "docker run --rm -it -v ${PWD}/:/app cyberlytics/ctan-prep:latest" 
pause 
