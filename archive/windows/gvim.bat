@echo off

REM  For windows system that has linux util installed
tasklist /FI "IMAGENAME eq gvim.exe" 2>NUL | grep "gvim.exe" >NUL
REM  Otherwise use this
REM tasklist /FI "IMAGENAME eq gvim.exe" 2>NUL | find /I /N "gvim.exe" >NUL
IF "%ERRORLEVEL%"=="1" (
  D:\PortableAppsPlatform\PortableApps\GvimPortable\gvim.exe --servername GVIM %1
) ELSE (
  D:\PortableAppsPlatform\PortableApps\GvimPortable\gvim.exe --servername GVIM --remote %1
)
