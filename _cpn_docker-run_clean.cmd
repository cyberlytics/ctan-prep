@echo off 
cd /D "%~dp0" 
pwsh.exe -command "docker run --rm -it --privileged --user root -v ${PWD}/:/app cyberlytics/ctan-prep:latest make clean" 
pause 
