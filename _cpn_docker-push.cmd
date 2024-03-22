@echo off 
cd /D "%~dp0" 
echo > Logging into dockerhub as: cyberlytics 
pwsh.exe -command "docker login --username=cyberlytics" 
rem pwsh.exe -command "docker tag <lokale-ImageID> cyberlytics/ctan-prep:latest" 
pwsh.exe -command "docker push cyberlytics/ctan-prep" 
pause 
