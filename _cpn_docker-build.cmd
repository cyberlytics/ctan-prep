@echo off 
cd /D "%~dp0" 
docker build -t cyberlytics/ctan-prep:latest . 
pause 
