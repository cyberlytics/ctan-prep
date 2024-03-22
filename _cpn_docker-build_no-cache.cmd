@echo off 
cd /D "%~dp0" 
docker build --no-cache -t cyberlytics/ctan-prep:latest . 
pause 
