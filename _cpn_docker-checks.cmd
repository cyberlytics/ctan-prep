@echo off 
cd /D "%~dp0" 
choco install dive -y 
echo. 
echo == IMAGE sizes: docker system df -v == 
pwsh.exe -command "docker system df -v" 
echo. 
echo == CONTAINER sizes: docker ps --size == 
pwsh.exe -command "docker ps --size" 
echo. 
echo == LAYERS: docker image HISTORY cyberlytics/ctan-prep:latest == 
pwsh.exe -command "docker image history cyberlytics/ctan-prep:latest" 
rem echo. 
rem echo == LAYERS: docker image INSPECT cyberlytics/ctan-prep:latest == 
rem pwsh.exe -command "docker image inspect cyberlytics/ctan-prep:latest" 
echo. 
echo == SNYK: docker scan == 
echo ^> Logging into dockerhub as: cyberlytics 
pwsh.exe -command "docker login --username=cyberlytics" 
echo ^> Logging into SNYK... 
pwsh.exe -command "snyk auth" 
pwsh.exe -command "docker scan cyberlytics/ctan-prep:latest" 
echo. 
echo == DIVE cyberlytics/ctan-prep:latest == 
echo Press RETURN to continue... 
pause 
cmd /D/C dive cyberlytics/ctan-prep:latest 
rem pause 
