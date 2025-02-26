@echo off
start /B lightshot_converter.exe
timeout /t 5
start http://127.0.0.1:5000
exit
