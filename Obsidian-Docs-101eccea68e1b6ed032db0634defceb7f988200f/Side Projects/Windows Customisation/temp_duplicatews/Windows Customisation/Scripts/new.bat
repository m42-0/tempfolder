@echo off
echo off
chcp 1251 | break
pushd "%cd%"
cd /d "%~dp0"
if /i not "%cd%\"=="%~dp0" cd /d "%~dp0"
set logs=%~dp0..\..\Logs
if not exist "%SystemRoot%\SysWOW64" (set "arch=x86") else (set "arch=x64")
set SystemUser=%~dp0superUser_%arch%.exe /c
set allrf=del /f /q /s
set rf=del /f /q
set rgd=reg delete
set rga=reg add
%rga% "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%~dp0captime.exe" /t REG_SZ /d "~ RUNASADMIN WINXPSP3" /f >nul 2>&1
%rga% "HKCU\SOFTWARE\VB and VBA Program Settings\K Clock\CapTime" /v "Format" /t REG_SZ /d "• $c • $dd • $tt •" /f >nul 2>&1
%rga% "HKCU\SOFTWARE\VB and VBA Program Settings\K Clock\CapTime" /v "AMPM" /t REG_SZ /d "False" /f >nul 2>&1
%rga% "HKCU\SOFTWARE\VB and VBA Program Settings\K Clock\CapTime" /v "Speed" /t REG_SZ /d "11" /f >nul 2>&1
%rga% "HKCU\SOFTWARE\VB and VBA Program Settings\K Clock\CapTime" /v "RemoveCount" /t REG_SZ /d "0" /f >nul 2>&1
%~dp0nircmdc_%arch%.exe exec hide "%~dp0captime.exe" /noicon
timeout /t 1 /nobreak | break
%~dp0nircmdc_%arch%.exe win hide process "captime.exe"
setlocal enableextensions enabledelayedexpansion
if defined SAFEBOOT_OPTION (
	echo  *** Âû íàõîäèòåñü â áåçîïàñíîì ðåæèìå^! Äàííûé ñêðèïò ïðåäíàçíà÷åí òîëüêî äëÿ çàïóñêà â îáû÷íîì ðåæèìå. ***
	timeout /t 10 /nobreak | break
	goto :eof
)
ver | findstr /i "10.0." | break
if %errorLevel% neq 0 (
	echo  *** Âàøà ÎÑ íå ïîääåðæèâàåòñÿ^! Äàííûé ñêðèïò ïðåäíàçíà÷åí òîëüêî äëÿ ïðèìåíåíèÿ â ÎÑ Windows 10. ***
	timeout /t 10 /nobreak | break
	goto :eof
)
reg query "HKU\S-1-5-19\Environment" & cls
if %errorlevel% neq 0 (
	echo: Set UAC = CreateObject^("Shell.Application"^) > "%logs%\getadmin.vbs"
	echo: UAC.ShellExecute "%~f0", "", "", "runas", 1 >> "%logs%\getadmin.vbs"
	"%logs%\getadmin.vbs" goto :eof
)
if exist "%logs%\getadmin.vbs" ( %rf% "%logs%\getadmin.vbs" >nul 2>&1 ) & goto :eof
set ScriptVersion=v0.9.5 Stable
set HostOSName=
set HostArchitecture=
set HostLanguage=
set HostDisplayVersion=
set HostVersion=
set HostBuild=
set AgainRunning=
if exist "%~dp0launched.mtp" set /p AgainDate= < %~dp0launched.mtp
if exist "%~dp0launched.mtp" set "AgainRunning=Äà"
if not exist "%~dp0launched.mtp" set "AgainRunning=Íåò"
if exist "%SystemRoot%\SysWOW64" set "HostArchitecture=x64"
if not exist "%SystemRoot%\SysWOW64" set "HostArchitecture=x86"
for /f "skip=2 tokens=1,2*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName" 2^>nul') do if /i "%%i" == "ProductName" set "HostOSName=%%k"
for /f "skip=2 tokens=1,2*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion" 2^>nul') do if /i "%%i" == "DisplayVersion" set "HostDisplayVersion=%%k"
for /f "tokens=4-5 delims=. " %%s in ('ver 2^>nul') do set "HostVersion=%%s.%%t"
for /f "tokens=1 delims=" %%i in ('wmic os get BuildNumber ^| find /v "BuildNumber"') do (for /f "delims=" %%b in ("%%i") do (set /a HostBuild=%%~nb))
for /f "tokens=2 delims==" %%a in ('wmic os get OSLanguage /Value') do (set HostLanguage=%%a)
if %HostLanguage% equ 1049 (
  set HostLanguage=Ðóññêàÿ
) else if %HostLanguage% equ 0409 (
  set HostLanguage=Àíãëèéñêàÿ
) else (
  echo ßçûê ñèñòåìû íå ïîääåðæèâàåòñÿ. Âûõîä èç ñêðèïòà...
  timeout /t 5 /nobreak | break
  goto :eof
)
reg query "HKLM\SYSTEM\Setup" /v "Upgrade" | findstr /r "1" >nul 2>&1
if %errorlevel% equ 1 (
	set WhichVersion=ïîëíàÿ âåðñèÿ
) else (
	set WhichVersion=îáíîâëåííàÿ âåðñèÿ
)
call :clr
chcp 1251 | break
set title=ñêðèïò âû èñïîëüçóåòå íà ñâîé ñòðàõ è ðèñê, çà ïðè÷èíåííûé óùåðá ñîçäàòåëü ñêðèïòà îòâåòñòâåííîñòè íå íåñåò.
title %title%
rem #########################################################################################################################################################################################################################
echo.  
echo.                                              %clr%[91m• Ï Ð Å Ä Ó Ï Ð Å Æ Ä Å Í È Å •%clr%[0m
echo.                                                ___________________________%clr%[91m
echo.  
echo.  
echo.  MegaTweaksPack for Highest Performance îò TheDoctor - ýòî ñèñòåìíûé ñêðèïò äëÿ îïòèìèçàöèè, òîíêîé íàñòðîéêè è î÷èñòêè Windows 10 
echo.  îò ñèñòåìíîãî ìóñîðà. Âñå ýòî â ñîâîêóïíîñòè, ïîçâîëèò óâåëè÷èòü ñêîðîñòü ðàáîòû ñèñòåìû, âû ñìîæåòå óñòðàíèòü ðàçíîãî òèïà îøèáêè, 
echo.  óëó÷øèòü áåçîïàñíîñòü è ïðèìåíèòü ðÿä äðóãèõ îïòèìèçèðîâàííûõ íàñòðîåê. Âû ïîëó÷èòå ñâûøå 50 ðàçíûõ óòèëèò, êîòîðûå ïîìîãóò âàì 
echo.  çàñòàâèòü Windows 10 ðàáîòàòü áûñòðåå è ñòàáèëüíåå.
echo.  
echo.  Äëÿ êîððåêòíîãî âûïîëíåíèÿ ñêðèïòà, âàì íåîáõîäèìî îòêëþ÷èòü àíòèâèðóñ è äîáàâèòü %clr%[0mâñþ ïàïêó ñî ñêðèïòîì%clr%[91m â äîâåðåííóþ çîíó. 
echo.  ÏÎÑËÅ âûïîëíåíèÿ ñêðèïòà, äîáàâüòå ïàïêó %clr%[0m%HomeDrive%\Windows\Tools%clr%[91m â äîâåðåííóþ çîíó àíòèâèðóñà.
echo.  
echo.  
echo.  %clr%[0m___________________________________________________________________________________________________________________________________%clr%[0m
echo.  
echo.  %clr%[0mÂàøà ÎÑ:                  %clr%[91m %clr%[92m%HostOSName% %HostArchitecture% %HostLanguage% %WhichVersion% (%HostDisplayVersion%) Ñáîðêà: %HostVersion%.%HostBuild%%clr%[91m
echo.  %clr%[0mÑêðèïò ðàíåå çàïóñêàëñÿ:  %clr%[91m %clr%[92m%AgainRunning%%clr%[91m
if exist "%~dp0launched.mtp" echo.  %clr%[0mÏîñëåäíèé çàïóñê ñêðèïòà:  %clr%[92m%AgainDate%%clr%[91m
echo.  %clr%[0m___________________________________________________________________________________________________________________________________%clr%[0m
echo.  
echo.  %clr%[0mÑîçäàòåëü ñêðèïòà:        %clr%[92m TheDoctor
echo.  %clr%[0mÂåðñèÿ ñêðèïòà:           %clr%[92m %ScriptVersion%
echo.  %clr%[0mÏîñëåäíÿÿ âåðñèÿ ñêðèïòà: %clr%[92m https://github.com/TheDoctorTash/MegaTweakPack
echo.  %clr%[0mÎòçûâû è ïðåäëîæåíèÿ:     %clr%[92m Telegram - https://t.me/MegaTweakPack
echo.  %clr%[0mÊîíòàêòíàÿ èíôîðìàöèÿ:    %clr%[92m Zello - TheDoctorTash
echo.  %clr%[0m___________________________________________________________________________________________________________________________________%clr%[91m
echo.  
echo.  
choice /c yn /n /m "Âû âûïîëíèëè âñå óñëîâèÿ è ïîäòâåðæäàåòå çàïóñê? [Y:Ïîäòâåðäèòü / N:Âûéòè]"
if errorlevel 2 (
taskkill /f /im "captime.exe"
goto :eof
)
rem #########################################################################################################################################################################################################################
set tmpfile=%logs%\temp.dat
time /t > %tmpfile%
set /p ftime= < %tmpfile%
set daytime=%date:~0,2%.%date:~3,2%.%date:~6%_%ftime:~0,2%-%ftime:~3,2%
set daytimecmd=%date:~0,2%.%date:~3,2%.%date:~6% %ftime:~0,2%:%ftime:~3,2%
set logfile=%logs%\MegaTweakPack_%daytime%.log
echo %daytimecmd% > %~dp0launched.mtp
powershell "Set-ExecutionPolicy Unrestricted" | break
setx NUGET_XMLDOC_MODE skip | break
set "PS=powershell -NoLogo -NoProfile -NonInteractive -InputFormat None -ExecutionPolicy Bypass -Command"
set autoChoose=30
set keySelY="Âûïîëíèòü çàäà÷ó? Äåéñòâèå ïî-óìîë÷àíèþ: çàïóñê çàäà÷è ÷åðåç %autoChoose% ñåêóíä. [Y:Âûïîëíèòü / N:Ïðîïóñòèòü]"
set keySelN="Âûïîëíèòü çàäà÷ó? Äåéñòâèå ïî-óìîë÷àíèþ: îòìåíà çàäà÷è ÷åðåç %autoChoose% ñåêóíä. [Y:Âûïîëíèòü / N:Ïðîïóñòèòü]"
cls
rem #########################################################################################################################################################################################################################
set copyright=MegaTweaksPack for Highest Performance %ScriptVersion% by TheDoctor
@echo %clr%[30m %clr%[106m %copyright% %clr%[0m
@echo *** %copyright% *** 1>> %logfile%
echo. 1>> %logfile%
timeout /t 5 /nobreak | break
%~dp0ExitExplorer.exe
call :kill "explorer.exe"
echo.
rem #########################################################################################################################################################################################################################
@echo %clr%[0m %clr%[93mÑîçäàíèå òî÷êè âîññòàíîâëåíèÿ. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
@echo Ñîçäàíèå òî÷êè âîññòàíîâëåíèÿ. 1>> %logfile%
set timerStart=!time!
rem reg load "HKU\.DEFAULT" "%SystemDrive%\Users\Default\NTUSER.DAT" 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "DisableConfig" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "DisableSR" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableConfig" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableSR" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
call :auto_svc srservice
%PS% "$SysDrive = $env:SystemDrive; Enable-ComputerRestore $SysDrive" 1>> %logfile% 2>>&1
%SystemRoot%\system32\cmd.exe /c "vssadmin delete shadows /all /quiet" 1>> %logfile% 2>>&1
%SystemRoot%\system32\cmd.exe /c "vssadmin Resize ShadowStorage /For=C: /On=C: /MaxSize=10GB" 1>> %logfile% 2>>&1
%PS% "Checkpoint-Computer -Description 'MegaTweakPack - Recovery Point at %date%' -RestorePointType 'MODIFY_SETTINGS'" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo.
rem #########################################################################################################################################################################################################################
@echo %clr%[36mÂûïîëíèòü îáñëóæèâàíèå ÎÑ? ^(ýòî ìîæåò çàíÿòü ïðèìåðíî 1 ÷àñ^)%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
echo.
@echo %clr%[0m %clr%[93mÂûïîëíåíèå îáñëóæèâàíèÿ ÎÑ. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
@echo Âûïîëíåíèå îáñëóæèâàíèÿ ÎÑ. 1>> %logfile%
set timerStart=!time!
%PS% "%~dp0OutdatedDrivers.ps1" 1>> %logfile% 2>>&1
fsutil usn createjournal m=1 a=1 %SystemDrive%
fsutil usn deletejournal /d %SystemDrive%
sfc /scannow 1>> %logfile% 2>>&1
%SystemRoot%\Microsoft.NET\Framework\v2.0.50727\ngen.exe update /force /queue 1>> %logfile% 2>>&1
%SystemRoot%\Microsoft.NET\Framework64\v2.0.50727\ngen.exe update /force /queue 1>> %logfile% 2>>&1
%SystemRoot%\Microsoft.NET\Framework\v2.0.50727\ngen.exe executequeueditems 1>> %logfile% 2>>&1
%SystemRoot%\Microsoft.NET\Framework64\v2.0.50727\ngen.exe executequeueditems 1>> %logfile% 2>>&1
%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ngen.exe update /force /queue 1>> %logfile% 2>>&1
%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe update /force /queue 1>> %logfile% 2>>&1
%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ngen.exe executequeueditems 1>> %logfile% 2>>&1
%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\ngen.exe executequeueditems 1>> %logfile% 2>>&1
dism /online /Cleanup-Image /ScanHealth 1>> %logfile% 2>>&1
dism /online /Cleanup-Image /RestoreHealth 1>> %logfile% 2>>&1
dism /online /Cleanup-Image /SpSuperseded 1>> %logfile% 2>>&1
dism /Cleanup-Mountpoints 1>> %logfile% 2>>&1
sfc /scannow 1>> %logfile% 2>>&1
rem echo Y|chkdsk %HomeDrive% /f 1>> %logfile% 2>>&1
wmic recoveros get autoreboot 1>> %logfile% 2>>&1
wmic recoveros set autoreboot=false 1>> %logfile% 2>>&1
wmic recoveros get autoreboot 1>> %logfile% 2>>&1
wmic recoveros get DebugInfoType 1>> %logfile% 2>>&1
wmic recoveros set DebugInfoType=7 1>> %logfile% 2>>&1
wmic recoveros get DebugInfoType 1>> %logfile% 2>>&1
wmic pagefile list /format:list 1>> %logfile% 2>>&1
wmic computersystem where name="%ComputerName%" get AutomaticManagedPagefile 1>> %logfile% 2>>&1
wmic computersystem where name="%ComputerName%" set AutomaticManagedPagefile=True 1>> %logfile% 2>>&1
wmic computersystem where name="%ComputerName%" get AutomaticManagedPagefile 1>> %logfile% 2>>&1
bcdedit /enum {badmemory} 1>> %logfile% 2>>&1
net stop WerSvc 1>> %logfile% 2>>&1
net stop TrustedInstaller 1>> %logfile% 2>>&1
net stop WaaaSMedicSVC 1>> %logfile% 2>>&1
net stop wuauserv 1>> %logfile% 2>>&1
net stop bits 1>> %logfile% 2>>&1
net stop DPS 1>> %logfile% 2>>&1
net stop Wecsvc 1>> %logfile% 2>>&1
net stop EventLog 1>> %logfile% 2>>&1
call :disable_task "\Microsoft\Windows\Wininet\CacheTask"
call :acl_registry "HKCR\AppID\{3eb3c877-1f16-487c-9050-104dbcd66683}"
%rgd% "HKCR\AppID\{3eb3c877-1f16-487c-9050-104dbcd66683}" /f 1>> %logfile% 2>>&1
call :acl_registry "HKCR\CLSID\{0358b920-0ac7-461f-98f4-58e32cd89148}"
%rgd% "HKCR\CLSID\{0358b920-0ac7-461f-98f4-58e32cd89148}" /f 1>> %logfile% 2>>&1
call :acl_registry "HKCR\WOW6432Node\CLSID\{0358b920-0ac7-461f-98f4-58e32cd89148}"
%rgd% "HKCR\WOW6432Node\CLSID\{0358b920-0ac7-461f-98f4-58e32cd89148}" /f 1>> %logfile% 2>>&1
call :acl_registry "HKCR\WinInetCache.WinInetCache\CLSID"
%rgd% "HKCR\WinInetCache.WinInetCache\CLSID" /f 1>> %logfile% 2>>&1
call :acl_registry "HKCR\WinInetCache.WinInetCache"
%rgd% "HKCR\WinInetCache.WinInetCache" /f 1>> %logfile% 2>>&1
call :acl_registry "HKCR\WinInetCache.WinInetCache.1\CLSID"
%rgd% "HKCR\WinInetCache.WinInetCache.1\CLSID" /f 1>> %logfile% 2>>&1
call :acl_registry "HKCR\WinInetCache.WinInetCache.1"
%rgd% "HKCR\WinInetCache.WinInetCache.1" /f 1>> %logfile% 2>>&1
call :acl_registry "HKLM\SYSTEM\CurrentControlSet\Control\Ubpm"
%rgd% "HKLM\SYSTEM\CurrentControlSet\Control\Ubpm" /v "CriticalAction_WinInetCacheTask" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Internet Explorer\TypedURLs" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Internet Explorer\TypedURLsTime" /va /f 1>> %logfile% 2>>&1
call :kill "dllhost.exe"
%PS% "$bin = (New-Object -ComObject Shell.Application).NameSpace(10);$bin.items() | ForEach {Remove-Item $_.Path -Recurse -Force}" 1>> %logfile% 2>>&1
%allrf% "%HomeDrive%\*.log" 1>> %logfile% 2>>&1
%allrf% "%HomeDrive%\*.tmp" 1>> %logfile% 2>>&1
%allrf% "%HomeDrive%\*.chk" 1>> %logfile% 2>>&1
%allrf% "%HomeDrive%\*.dmp" 1>> %logfile% 2>>&1
%allrf% "%HomeDrive%\*._mp" 1>> %logfile% 2>>&1
%allrf% "%HomeDrive%\*.err" 1>> %logfile% 2>>&1
%allrf% "%HomeDrive%\*.edb" 1>> %logfile% 2>>&1
%allrf% "%HomeDrive%\*.jrs" 1>> %logfile% 2>>&1
%allrf% "%HomeDrive%\$Recycle.Bin\S-1-5*\*" 1>> %logfile% 2>>&1
%allrf% "%ProgramData%\Microsoft\Network\Downloader\*" 1>> %logfile% 2>>&1
%allrf% "%ProgramData%\Microsoft\SmsRouter\MessageStore\*" 1>> %logfile% 2>>&1
%allrf% "%ProgramData%\Microsoft\Windows\Containers\Dumps\*" 1>> %logfile% 2>>&1
%allrf% "%ProgramData%\Microsoft\Windows\WER\*" 1>> %logfile% 2>>&1
for /d %%i in (%ProgramData%\Microsoft\Windows\WER\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%ProgramData%\NVIDIA\*.log_backup1" 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
(for /f "usebackq tokens=1,2,*" %%a in (`reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam" /v UninstallString`) do set SteamPathString=%%c) 1>> %logfile% 2>>&1
)
if "%arch%"=="x86" (
(for /f "usebackq tokens=1,2,*" %%a in (`reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam" /v UninstallString`) do set SteamPathString=%%c) 1>> %logfile% 2>>&1
)
set SteamPath=%SteamPathString:\uninstall.exe=%
%allrf% "%SteamPath%\appcache\*.log" 1>> %logfile% 2>>&1
%allrf% "%SteamPath%\Dumps\*" 1>> %logfile% 2>>&1
%allrf% "%SteamPath%\logs\*" 1>> %logfile% 2>>&1
%allrf% "%SteamPath%\Traces\*" 1>> %logfile% 2>>&1
%allrf% "%SteamPath%\steamapps\downloading\*" 1>> %logfile% 2>>&1
for /d %%i in (%SteamPath%\steamapps\downloading\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%SteamPath%\steamapps\shadercache\*" 1>> %logfile% 2>>&1
%allrf% "%SteamPath%\steamapps\temp\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\CrashDumps\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Google\CrashReports\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Google\Chrome\User Data\Crashpad\reports\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\CLR_v2.0\UsageLogs\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\CLR_v2.0\UsageTraces\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\CLR_v4.0\UsageLogs\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\CLR_v4.0\UsageTraces\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\CLR_v4.0_32\UsageLogs\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\CLR_v4.0_32\UsageTraces\*" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\System32\config\systemprofile\AppData\Local\Microsoft\CLR_v4.0\UsageLogs\*" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\System32\config\systemprofile\AppData\Local\Microsoft\CLR_v4.0_32\UsageLogs\*" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\System32\config\systemprofile\AppData\Local\Microsoft\Windows\WebCache\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\Internet Explorer\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\Internet Explorer\CacheStorage\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\Internet Explorer\Indexed DB\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\Terminal Server Client\Cache\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\Windows\Caches\*" 1>> %logfile% 2>>&1
for /d %%i in (%LocalAppdata%\Microsoft\Internet Explorer\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%LocalAppData%\Microsoft\Windows\Explorer\*.db" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\Windows\History\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\Windows\INetCache\*" 1>> %logfile% 2>>&1
for /d %%i in (%LocalAppdata%\Microsoft\Windows\INetCache\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\Windows\WebCache\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Microsoft\Windows\WER\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\SquirrelTemp\*" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Temp\*" 1>> %logfile% 2>>&1
for /d %%i in (%LocalAppdata%\Temp\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%LocalAppdata%\Windows\WebCache\*" 1>> %logfile% 2>>&1
%allrf% "%Appdata%\Listary\UserData\*" 1>> %logfile% 2>>&1
%allrf% "%Appdata%\Macromedia\Flash Player\*" 1>> %logfile% 2>>&1
for /d %%i in (%Appdata%\Macromedia\Flash Player\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%Appdata%\Microsoft\Windows\Recent\AutomaticDestinations\*" 1>> %logfile% 2>>&1
%allrf% "%Appdata%\Microsoft\Windows\Recent\CustomDestinations\*" 1>> %logfile% 2>>&1
%allrf% "%Appdata%\Microsoft\Office\Recent\*" 1>> %logfile% 2>>&1
%allrf% "%Appdata%\Sun\Java\Deployment\cache\*" 1>> %logfile% 2>>&1
for /d %%i in (%Appdata%\Sun\Java\Deployment\cache\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%UserProfile%\.dotnet\TelemetryStorageService\*" 1>> %logfile% 2>>&1
%allrf% "%UserProfile%\AppData\LocalLow\Microsoft\Internet Explorer\DOMStore\*" 1>> %logfile% 2>>&1
%allrf% "%UserProfile%\MicrosoftEdgeBackups\*" 1>> %logfile% 2>>&1
for /d %%i in (%UserProfile%\MicrosoftEdgeBackups\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\Installer\$PatchCache$\Managed\*" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\ServiceProfiles\LocalService\AppData\Local\Temp\*" 1>> %logfile% 2>>&1
for /d %%i in (%SystemRoot%\ServiceProfiles\LocalService\AppData\Local\Temp\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Temp\*" 1>> %logfile% 2>>&1
call :acl_file-folders "%SystemRoot%\Logs"
%allrf% "%SystemRoot%\Logs\*" 1>> %logfile% 2>>&1
for /d %%i in (%SystemRoot%\Logs\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\Panther\*" 1>> %logfile% 2>>&1
for /d %%i in (%SystemRoot%\Panther\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\Prefetch\*" 1>> %logfile% 2>>&1
for /d %%i in (%SystemRoot%\Prefetch\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\SoftwareDistribution\*" 1>> %logfile% 2>>&1
for /d %%i in (%SystemRoot%\SoftwareDistribution\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%rf% "%SystemRoot%\System32\catroot2\dberr.txt" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\System32\DriverStore\Temp\*" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\System32\GroupPolicy\*" 1>> %logfile% 2>>&1
for /d %%i in (%SystemRoot%\System32\GroupPolicy\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\System32\LogFiles\*" 1>> %logfile% 2>>&1
for /d %%i in (%SystemRoot%\System32\LogFiles\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% /a "%SystemRoot%\System32\*.sru" 1>> %logfile% 2>>&1
rem %allrf% /a "%SystemRoot%\System32\sru*" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\System32\config\systemprofile\AppData\Local\Microsoft\CLR_v4.0\UsageLogs\*" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\System32\config\systemprofile\AppData\Local\Microsoft\Windows\WebCache\*" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\Temp\*" 1>> %logfile% 2>>&1
for /d %%i in (%SystemRoot%\Temp\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%TEMP%\*" 1>> %logfile% 2>>&1
for /d %%i in (%TEMP%\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%TMP%\*" 1>> %logfile% 2>>&1
for /d %%i in (%TMP%\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\Traces\WindowsUpdate\*" 1>> %logfile% 2>>&1
if exist "%SystemDrive%\Windows.old" (
	call :acl_file-folders "%SystemDrive%\Windows.old"
	rd /s /q "%SystemDrive%\Windows.old" 1>> %logfile% 2>>&1
)
%rgd% "HKCU\DesktopBackground\Shell\UWTSettings" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Terminal Server Client\Default" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Terminal Server Client\Servers" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" /va /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" /va /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Regedit" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Search Assistant\ACMru" /va /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\MediaPlayer\Player\RecentFileList" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\MediaPlayer\Player\RecentURLList" /va /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\MediaPlayer\Player\RecentFileList" /va /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\MediaPlayer\Player\RecentURLList" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Direct3D\MostRecentApplication" /va /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Direct3D\MostRecentApplication" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /va /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Terminal Server Client\Servers" /f 1>> %logfile% 2>>&1
attrib -s -h "%UserProfile%\Documents\Default.rdp" 1>> %logfile% 2>>&1
%rf% "%UserProfile%\Documents\Default.rdp" 1>> %logfile% 2>>&1
%PS% "Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options' -Name * -Force" 1>> %logfile% 2>>&1
for /f "tokens=* delims=" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches" /s /v "StateFlags0001"^|FindStr HKEY_') do ( %rga% "%%i" /v "StateFlags0001" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1 )
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\DownloadsFolder" /v "StateFlags0001" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
start "" /wait %SystemUser% /w run-hidden.exe %SystemRoot%\System32\cmd.exe /c "cleanmgr /sageset:1 && cleanmgr /sagerun:1"
%~dp0..\Cleanmgr+\Cleanmgr+.exe /nowindow 1>> %logfile% 2>>&1
%SystemUser% run-hidden.exe "wevtutil sl Microsoft-Windows-LiveId/Operational /ca:O:BAG:SYD:(A;;0x1;;;SY)(A;;0x5;;;BA)(A;;0x1;;;LA)" >nul 2>&1
rem for /f "tokens=*" %%i in ('wevtutil el') do (%SystemUser% run-hidden.exe wevtutil cl '%%i') 1>> %logfile% 2>>&1
for /f "tokens=*" %%i in ('wevtutil.exe el') do (%SystemUser% run-hidden.exe wevtutil.exe cl %1 "%%i" >nul 2>&1)
net user defaultuser0 /delete 1>> %logfile% 2>>&1
net start Wecsvc 1>> %logfile% 2>>&1
net start EventLog 1>> %logfile% 2>>&1
net start DPS 1>> %logfile% 2>>&1
net start TrustedInstaller 1>> %logfile% 2>>&1
net start bits 1>> %logfile% 2>>&1
net start wuauserv 1>> %logfile% 2>>&1
net start WaaaSMedicSVC 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!hours!%clr%[0m ÷àñîâ%clr%[93m %clr%[91m!mins!%clr%[0m ìèíóò%clr%[93m %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
)
echo.
rem #########################################################################################################################################################################################################################
@echo %clr%[36mÏðèìåíèòü òâèêè îïòèìèçàöèè? ^(ýòî ìîæåò çàíÿòü ïðèìåðíî 30 ìèíóò^)%clr%[92m
choice /c yn /n /m "Çàïóñòèòü çàäà÷ó èëè âûéòè èç ñêðèïòà? [Y:Âûïîëíèòü / N:Âûéòè]"
if errorlevel 2 goto :explorer & goto :eof
echo.
@echo %clr%[36mÏðèìåíåíèå òâèêîâ îïòèìèçàöèè. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
@echo Ïðèìåíåíèå òâèêîâ îïòèìèçàöèè. 1>> %logfile%
echo.
echo.
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Çàãðóçêà %clr%[0m
@echo Çàãðóçêà 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Âðåìÿ îæèäàíèÿ âûáîðà ÎÑ.%clr%[92m
@echo Âðåìÿ îæèäàíèÿ âûáîðà ÎÑ. 1>> %logfile%
set timerStart=!time!
bcdedit /timeout 2 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Âêëþ÷èòü NumLock ïðè çàãðóçêå.%clr%[92m
@echo Âêëþ÷èòü NumLock ïðè çàãðóçêå. 1>> %logfile%
set timerStart=!time!
bcdedit /set numlock Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Îòêëþ÷èòü ðåæèì àâòîìàòè÷åñêîãî âîññòàíîâëåíèÿ âî âðåìÿ çàãðóçêè, åñëè ñèñòåìà íå çàâåðøèëà ïðåäûäóùóþ çàãðóçêó èëè çàâåðøåíèå ðàáîòû.%clr%[92m
@echo Îòêëþ÷èòü ðåæèì àâòîìàòè÷åñêîãî âîññòàíîâëåíèÿ âî âðåìÿ çàãðóçêè, åñëè ñèñòåìà íå çàâåðøèëà ïðåäûäóùóþ çàãðóçêó èëè çàâåðøåíèå ðàáîòû. 1>> %logfile%
set timerStart=!time!
bcdedit /set bootstatuspolicy IgnoreAllFailures 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Îòêëþ÷èòü èñïîëüçîâàíèå ñòîðîííåé îáîëî÷êè ïðè çàãðóçêå â áåçîïàñíîì ðåæèìå.%clr%[92m
@echo Îòêëþ÷èòü èñïîëüçîâàíèå ñòîðîííåé îáîëî÷êè ïðè çàãðóçêå â áåçîïàñíîì ðåæèìå. 1>> %logfile%
set timerStart=!time!
bcdedit /set safebootalternateshell No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Ïàìÿòü %clr%[0m
@echo Ïàìÿòü 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Èçáåãàòü èñïîëüçîâàíèÿ ïàìÿòè íèæå óêàçàííîãî ôèçè÷åñêîãî àäðåñà â çàãðóç÷èêå.%clr%[92m
@echo Èçáåãàòü èñïîëüçîâàíèÿ ïàìÿòè íèæå óêàçàííîãî ôèçè÷åñêîãî àäðåñà â çàãðóç÷èêå.>> %logfile%
set timerStart=!time!
bcdedit /set avoidlowmemory 0x8000000 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Êîíòðîëèðóåò âêëþ÷åíèå è âûêëþ÷åíèå ïÿòèóðîâíåâîé ïîäêà÷êè äëÿ ïðèëîæåíèé (âîçìîæíûå çíà÷åíèÿ: default, optout, optin).%clr%[92m
@echo Êîíòðîëèðóåò âêëþ÷åíèå è âûêëþ÷åíèå ïÿòèóðîâíåâîé ïîäêà÷êè äëÿ ïðèëîæåíèé (âîçìîæíûå çíà÷åíèÿ: default, optout, optin).>> %logfile%
set timerStart=!time!
bcdedit /set linearaddress57 optout 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Èñïîëüçîâàòü ïîëíûé îáúåì îïåðàòèâíîé ïàìÿòè.%clr%[92m
@echo Èñïîëüçîâàòü ïîëíûé îáúåì îïåðàòèâíîé ïàìÿòè.>> %logfile%
set timerStart=!time!
bcdedit /set removememory 0 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Îòêëþ÷èòü ðåæèì PAE (ðàñøèðåíèå ôèçè÷åñêîãî àäðåñà). Ïîçâîëÿåò èñïîëüçîâàòü áîëåå 4 ÃÁ îïåðàòèâíîé ïàìÿòè â 32-áèòíîé ÎÑ (âîçìîæíûå çíà÷åíèÿ: Default, ForceEnable, ForceDisable).%clr%[92m
@echo Îòêëþ÷èòü ðåæèì PAE (ðàñøèðåíèå ôèçè÷åñêîãî àäðåñà). Ïîçâîëÿåò èñïîëüçîâàòü áîëåå 4 ÃÁ îïåðàòèâíîé ïàìÿòè â 32-áèòíîé ÎÑ (âîçìîæíûå çíà÷åíèÿ: Default, ForceEnable, ForceDisable).>> %logfile%
set timerStart=!time!
bcdedit /set pae ForceDisable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Îòêëþ÷èòü DEP (ïðåäîòâðàùåíèå âûïîëíåíèÿ äàííûõ). Ïàðàìåòð äîñòóïåí òîëüêî â 32-áèòíûõ ÎÑ ïðè ðàáîòå íà ïðîöåññîðàõ, ïîääåðæèâàþùèõ ïàìÿòü áåç âûïîëíåíèÿ, è òîëüêî òîãäà, êîãäà âêëþ÷åí PAE. (âîçìîæíûå çíà÷åíèÿ: OptIn, OptOut, AlwaysOff, AlwaysOn).%clr%[92m
@echo Îòêëþ÷èòü DEP (ïðåäîòâðàùåíèå âûïîëíåíèÿ äàííûõ). Ïàðàìåòð äîñòóïåí òîëüêî â 32-áèòíûõ ÎÑ ïðè ðàáîòå íà ïðîöåññîðàõ, ïîääåðæèâàþùèõ ïàìÿòü áåç âûïîëíåíèÿ, è òîëüêî òîãäà, êîãäà âêëþ÷åí PAE. (âîçìîæíûå çíà÷åíèÿ: OptIn, OptOut, AlwaysOff, AlwaysOn). 1>> %logfile%
set timerStart=!time!
bcdedit /set nx AlwaysOff 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 6.%clr%[36m Ïðåäîòâðàòèòü ñèñòåìå âûäåëÿòü ïðèëîæåíèÿì äî 3 ÃÁ âèðòóàëüíîãî àäðåñíîãî ïðîñòðàíñòâà. Äàííûé ïàðàìåòð óäàëÿåòñÿ èç BCD â ñâÿçè ñ ïðîáëåìàìè ñ ïàìÿòüþ ïóëà ñòðàíèö.%clr%[92m
@echo Ïðåäîòâðàòèòü ñèñòåìå âûäåëÿòü ïðèëîæåíèÿì äî 3 ÃÁ âèðòóàëüíîãî àäðåñíîãî ïðîñòðàíñòâà. Äàííûé ïàðàìåòð óäàëÿåòñÿ èç BCD â ñâÿçè ñ ïðîáëåìàìè ñ ïàìÿòüþ ïóëà ñòðàíèö.>> %logfile%
set timerStart=!time!
bcdedit /deletevalue increaseuserva 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 7.%clr%[36m Çàïðåòèòü çàãðóçêó ñèñòåìíûõ ôàéëîâ è äðàéâåðîâ â îáëàñòü ïàìÿòè çà ïðåäåëû 4 ÃÁ.%clr%[92m
@echo Çàïðåòèòü çàãðóçêó ñèñòåìíûõ ôàéëîâ è äðàéâåðîâ â îáëàñòü ïàìÿòè çà ïðåäåëû 4 ÃÁ.>> %logfile%
set timerStart=!time!
bcdedit /set nolowmem No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Óñòðîéñòâà è îáîðóäîâàíèå %clr%[0m
@echo Óñòðîéñòâà è îáîðóäîâàíèå 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Îòêëþ÷èòü çàïóñê RTOS (îïåðàöèîííàÿ ñèñòåìà ðåàëüíîãî âðåìåíè) äëÿ ðàçãðóçêè ÿäåð ïðîöåññîðà.%clr%[92m
@echo Îòêëþ÷èòü çàïóñê RTOS (îïåðàöèîííàÿ ñèñòåìà ðåàëüíîãî âðåìåíè) äëÿ ðàçãðóçêè ÿäåð ïðîöåññîðà. 1>> %logfile%
set timerStart=!time!
bcdedit /deletevalue firstmegabytepolicy 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Èñïîëüçîâàòü ïîääåðæêó BIOS çàãðóçî÷íûì ïðèëîæåíèÿì äëÿ ðàñøèðåííîãî ââîäà ñ êîíñîëè.%clr%[92m
@echo Èñïîëüçîâàòü ïîääåðæêó BIOS çàãðóçî÷íûì ïðèëîæåíèÿì äëÿ ðàñøèðåííîãî ââîäà ñ êîíñîëè. 1>> %logfile%
set timerStart=!time!
bcdedit /set extendedinput Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Óñòðàíèòü ïðîáëåìó ñ íåõâàòêîé ðåñóðñîâ äëÿ óñòðîéñòâ â äèñïåò÷åðå óñòðîéñòâ.%clr%[92m
@echo Óñòðàíèòü ïðîáëåìó ñ íåõâàòêîé ðåñóðñîâ äëÿ óñòðîéñòâ â äèñïåò÷åðå óñòðîéñòâ. 1>> %logfile%
set timerStart=!time!
bcdedit /set configaccesspolicy DisallowMmConfig 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Ïðîöåññîðû è êîíòðîëëåðû APIC %clr%[0m
@echo Ïðîöåññîðû è êîíòðîëëåðû APIC 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Óäàëèòü èñïîëüçóåìûé ïîòîê ïðîöåññîðà äëÿ RTOS.%clr%[92m
@echo Óäàëèòü èñïîëüçóåìûé ïîòîê ïðîöåññîðà äëÿ RTOS. 1>> %logfile%
set timerStart=!time!
bcdedit /deletevalue numproc 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Èñïîëüçîâàòü ìàêñèìàëüíîå ÷èñëî ïîòîêîâ ïðîöåññîðà â ÎÑ.%clr%[92m
@echo Èñïîëüçîâàòü ìàêñèìàëüíîå ÷èñëî ïîòîêîâ ïðîöåññîðà â ÎÑ. 1>> %logfile%
set timerStart=!time!
bcdedit /set maxproc Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Èñïîëüçîâàòü âñå ëîãè÷åñêèå ÿäðà ïðîöåññîðà.%clr%[92m
@echo Èñïîëüçîâàòü âñå ëîãè÷åñêèå ÿäðà ïðîöåññîðà. 1>> %logfile%
set timerStart=!time!
bcdedit /set onecpu No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Îòêëþ÷èòü ôèçè÷åñêîå èñïîëüçîâàíèå óëó÷øåííîãî ïðîãðàììèðóåìîãî êîíòðîëëåðà ïðåðûâàíèé (APIC).%clr%[92m
@echo Îòêëþ÷èòü ôèçè÷åñêîå èñïîëüçîâàíèå óëó÷øåííîãî ïðîãðàììèðóåìîãî êîíòðîëëåðà ïðåðûâàíèé (APIC). 1>> %logfile%
set timerStart=!time!
bcdedit /set usephysicaldestination No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Îòêëþ÷èòü èñïîëüçîâàíèå óñòàðåâøåãî ðåæèìà óëó÷øåííîãî ïðîãðàììèðóåìîãî êîíòðîëëåðà ïðåðûâàíèé (APIC).%clr%[92m
@echo Îòêëþ÷èòü èñïîëüçîâàíèå óñòàðåâøåãî ðåæèìà óëó÷øåííîãî ïðîãðàììèðóåìîãî êîíòðîëëåðà ïðåðûâàíèé (APIC). 1>> %logfile%
set timerStart=!time!
bcdedit /set uselegacyapicmode No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 6.%clr%[36m Âêëþ÷èòü èñïîëüçîâàíèå ðàñøèðåííîãî ðåæèìà APIC.%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m ïðåäâàðèòåëüíî âêëþ÷èòå x2APIC â BIOS ïîñëå ïåðåçàãðóçêè.
@echo Âêëþ÷èòü èñïîëüçîâàíèå ðàñøèðåííîãî ðåæèìà APIC. Ïðåäóïðåæäåíèå: ïðåäâàðèòåëüíî âêëþ÷èòå x2APIC â BIOS ïîñëå ïåðåçàãðóçêè. 1>> %logfile%
set timerStart=!time!
bcdedit /set x2apicpolicy Enable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 7.%clr%[36m Âêëþ÷èòü ðàñøèðåíèå ñèñòåìû êîìàíä x86 äëÿ ìèêðîïðîöåññîðîâ Intel è AMD èíñòðóêöèè â ÎÑ (AVX).%clr%[92m
@echo Âêëþ÷èòü ðàñøèðåíèå ñèñòåìû êîìàíä x86 äëÿ ìèêðîïðîöåññîðîâ Intel è AMD èíñòðóêöèè â ÎÑ (AVX). 1>> %logfile%
set timerStart=!time!
bcdedit /set xsavedisable 0 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 8.%clr%[36m Îòêëþ÷èòü îãðàíè÷åíèÿ ïàìÿòè ÿäðà äëÿ çàïóñêà BitLocker.%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m âûçûâàåò ñáîè/öèêëû çàãðóçêè, åñëè âêëþ÷åí Intel Software Guard Extensions.
@echo Îòêëþ÷èòü îãðàíè÷åíèÿ ïàìÿòè ÿäðà äëÿ çàïóñêà BitLocker. Ïðåäóïðåæäåíèå:âûçûâàåò ñáîè/öèêëû çàãðóçêè, åñëè âêëþ÷åí Intel Software Guard Extensions. 1>> %logfile%
set timerStart=!time!
bcdedit /set allowedinmemorysettings 0x0 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 9.%clr%[36m Îòêëþ÷èòü ïðèíóäèòåëüíîå øèôðîâàíèå ôåäåðàëüíûõ ñòàíäàðòîâ îáðàáîòêè èíôîðìàöèè (FIPS).%clr%[92m
@echo Îòêëþ÷èòü ïðèíóäèòåëüíîå øèôðîâàíèå ôåäåðàëüíûõ ñòàíäàðòîâ îáðàáîòêè èíôîðìàöèè (FIPS). 1>> %logfile%
set timerStart=!time!
bcdedit /set forcefipscrypto No 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "FipsAlgorithmPolicy" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 10.%clr%[36m Çàäàòü ôëàãè êîíôèãóðàöèè, ñïåöèôè÷åñêèå äëÿ ïðîöåññîðà.%clr%[92m
@echo Çàäàòü ôëàãè êîíôèãóðàöèè, ñïåöèôè÷åñêèå äëÿ ïðîöåññîðà. 1>> %logfile%
set timerStart=!time!
bcdedit /set configflags 0 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Ñëîé àáñòðàãèðîâàíèÿ îáîðóäîâàíèÿ (HAL) è ÿäðà (KERNEL) %clr%[0m
@echo Ñëîé àáñòðàãèðîâàíèÿ îáîðóäîâàíèÿ (HAL) è ÿäðà (KERNEL) 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Îòêëþ÷èòü ñïåöèàëüíóþ òî÷êó îñòàíîâà ñëîÿ àáñòðàãèðîâàíèÿ îáîðóäîâàíèÿ (HAL).%clr%[92m
@echo Îòêëþ÷èòü ñïåöèàëüíóþ òî÷êó îñòàíîâà ñëîÿ àáñòðàãèðîâàíèÿ îáîðóäîâàíèÿ (HAL). 1>> %logfile%
set timerStart=!time!
bcdedit /set halbreakpoint No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Îòêëþ÷èòü òàéìåð ñîáûòèé âûñîêîé òî÷íîñòè (High Precision Event Timer).%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m ïðåäâàðèòåëüíî âêëþ÷èòå HPET â BIOS ïîñëå ïåðåçàãðóçêè.
@echo Îòêëþ÷èòü òàéìåð ñîáûòèé âûñîêîé òî÷íîñòè (High Precision Event Timer). Ïðåäóïðåæäåíèå: ïðåäâàðèòåëüíî âêëþ÷èòå HPET â BIOS ïîñëå ïåðåçàãðóçêè. 1>> %logfile%
set timerStart=!time!
bcdedit /deletevalue useplatformclock 1>> %logfile% 2>>&1
bcdedit /set useplatformclock No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Çàïðåòèòü ïîääåðæêó óñòàðåâøèõ óñòðîéñòâ (CMOS, êîíòðîëëåð êëàâèàòóðû è ò.ä).%clr%[92m
@echo Çàïðåòèòü ïîääåðæêó óñòàðåâøèõ óñòðîéñòâ (CMOS, êîíòðîëëåð êëàâèàòóðû è ò.ä). 1>> %logfile%
set timerStart=!time!
bcdedit /set forcelegacyplatform No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Âêëþ÷èòü ðàñøèðåííóþ âðåìåííóþ ñèíõðîíèçàöèþ (âîçìîæíûå çíà÷åíèÿ: Legacy, Enhanced).%clr%[92m
@echo Âêëþ÷èòü ðàñøèðåííóþ âðåìåííóþ ñèíõðîíèçàöèþ (âîçìîæíûå çíà÷åíèÿ: Legacy, Default, Enhanced). 1>> %logfile%
set timerStart=!time!
bcdedit /set tscsyncpolicy Enhanced 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Èñïîëüçîâàòü òàéìåðû ïëàòôîðìû â êà÷åñòâå ñ÷åò÷èêà ïðîèçâîäèòåëüíîñòè ñèñòåìû.%clr%[92m
@echo Èñïîëüçîâàòü òàéìåðû ïëàòôîðìû â êà÷åñòâå ñ÷åò÷èêà ïðîèçâîäèòåëüíîñòè ñèñòåìû. 1>> %logfile%
set timerStart=!time!
bcdedit /set useplatformtick Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 6.%clr%[36m Îòêëþ÷èòü äèíàìè÷åñêèå ïðîöåññîðíûå òàêòû.%clr%[92m
@echo Îòêëþ÷èòü äèíàìè÷åñêèå ïðîöåññîðíûå òàêòû. 1>> %logfile%
set timerStart=!time!
bcdedit /deletevalue disabledynamictick 1>> %logfile% 2>>&1
bcdedit /set disabledynamictick Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m VESA, PCI, VGA è TPM %clr%[0m
@echo VESA, PCI, VGA è TPM 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Çàïðåòèòü PCI-óñòðîéñòâàì âûïîëíåíèå äèíàìè÷åñêîãî íàçíà÷åíèÿ IRQ è äðóãèõ ðåñóðñîâ ââîäà-âûâîäà (áëîêèðîâêà PCI).%clr%[92m
@echo Çàïðåòèòü PCI-óñòðîéñòâàì âûïîëíåíèå äèíàìè÷åñêîãî íàçíà÷åíèÿ IRQ è äðóãèõ ðåñóðñîâ ââîäà-âûâîäà (áëîêèðîâêà PCI). 1>> %logfile%
set timerStart=!time!
bcdedit /set usefirmwarepcisettings No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Âêëþ÷èòü ïðåðûâàíèÿ, èíèöèèðóåìûå ñîîáùåíèÿìè îò PCI, PCI-X, PCI Express (MSI).%clr%[92m
@echo Âêëþ÷èòü ïðåðûâàíèÿ, èíèöèèðóåìûå ñîîáùåíèÿìè îò PCI, PCI-X, PCI Express (MSI). 1>> %logfile%
set timerStart=!time!
bcdedit /set MSI Default 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Âêëþ÷èòü ïîëèòèêó ýíòðîïèè çàãðóçêè TPM è ïåðåäàòü åå ÿäðó (TPM çàïîëíÿåò ãåíåðàòîð ñëó÷àéíûõ ÷èñåë (RNG) ÿäðà äàííûìè).%clr%[92m
@echo Âêëþ÷èòü ïîëèòèêó ýíòðîïèè çàãðóçêè TPM è ïåðåäàòü åå ÿäðó (ïðè èñïîëüçîâàíèè ýíòðîïèè çàãðóçêè TPM çàïîëíÿåò ãåíåðàòîð ñëó÷àéíûõ ÷èñåë (RNG) ÿäðà äàííûìè). 1>> %logfile%
set timerStart=!time!
bcdedit /set tpmbootentropy ForceEnable 1>> %logfile% 2>>&1
call :demand_svc TPM
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Îòêëþ÷èòü ðåæèì VGA (èñïðàâëÿåò ÷åðíûé ýêðàí ïðè çàãðóçêå íà íåêîòîðûõ âèäåîêàðòàõ).%clr%[92m
@echo Îòêëþ÷èòü ðåæèì VGA (èñïðàâëÿåò ÷åðíûé ýêðàí ïðè çàãðóçêå íà íåêîòîðûõ âèäåîêàðòàõ). 1>> %logfile%
set timerStart=!time!
bcdedit /set novesa yes 1>> %logfile% 2>>&1
bcdedit /set novga yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Îòêëþ÷èòü âñòðîåííûé êîíòðîëü PCI Express (âîçìîæíûå çíà÷åíèÿ: default, forcedisable).%clr%[92m
@echo Îòêëþ÷èòü âñòðîåííûé êîíòðîëü PCI Express (âîçìîæíûå çíà÷åíèÿ: default, forcedisable). 1>> %logfile%
set timerStart=!time!
bcdedit /set pciexpress forcedisable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Äðàéâåðû %clr%[0m
@echo Äðàéâåðû 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Îòêëþ÷èòü ñëóæáû àâàðèéíîãî óïðàâëåíèÿ äëÿ îïåðàöèîííîé ñèñòåìû.%clr%[92m
@echo Îòêëþ÷èòü ñëóæáû àâàðèéíîãî óïðàâëåíèÿ äëÿ îïåðàöèîííîé ñèñòåìû. 1>> %logfile%
set timerStart=!time!
bcdedit /ems Off 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Îòêëþ÷èòü ñëóæáû àâàðèéíîãî óïðàâëåíèÿ äëÿ ïðèëîæåíèé çàãðóçêè.%clr%[92m
@echo Îòêëþ÷èòü ñëóæáû àâàðèéíîãî óïðàâëåíèÿ äëÿ ïðèëîæåíèé çàãðóçêè. 1>> %logfile%
set timerStart=!time!
bcdedit /bootems Off 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Âêëþ÷èòü òåñòîâûé ðåæèì äëÿ ïîääåðæêè íåïîäïèñàííûõ äðàéâåðîâ.%clr%[92m
@echo Âêëþ÷èòü òåñòîâûé ðåæèì äëÿ ïîääåðæêè íåïîäïèñàííûõ äðàéâåðîâ. 1>> %logfile%
set timerStart=!time!
bcdedit /set testsigning Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Îòêëþ÷èòü ïðîâåðêó öèôðîâîé ïîäïèñè äðàéâåðîâ.%clr%[92m
@echo Îòêëþ÷èòü ïðîâåðêó öèôðîâîé ïîäïèñè äðàéâåðîâ. 1>> %logfile%
set timerStart=!time!
bcdedit /set nointegritychecks Yes 1>> %logfile% 2>>&1
bcdedit /set loadoptions DISABLE_INTEGRITY_CHECKS 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Îòêëþ÷èòü îòîáðàæåíèå èìåí äðàéâåðîâ â ïðîöåññå çàãðóçêè.%clr%[92m
@echo Îòêëþ÷èòü îòîáðàæåíèå èìåí äðàéâåðîâ â ïðîöåññå çàãðóçêè. 1>> %logfile%
set timerStart=!time!
bcdedit /set sos No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Ýêðàíû îøèáîê %clr%[0m
@echo Ýêðàíû îøèáîê 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Îòêëþ÷èòü çàâåðøåíèå ðàáîòû ïîñëå îòîáðàæåíèÿ ýêðàíà îøèáêè.%clr%[92m
@echo Îòêëþ÷èòü çàâåðøåíèå ðàáîòû ïîñëå îòîáðàæåíèÿ ýêðàíà îøèáêè. 1>> %logfile%
set timerStart=!time!
bcdedit /set bootshutdowndisabled Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Çàäàòü òèï ãðàôè÷åñêîãî èíòåðôåéñà ïðè îøèáêàõ çàãðóçêè.%clr%[92m
@echo Çàäàòü òèï ãðàôè÷åñêîãî èíòåðôåéñà ïðè îøèáêàõ çàãðóçêè. 1>> %logfile%
set timerStart=!time!
bcdedit /set booterrorux Simple 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Îòëàäêà è ëîãèðîâàíèå %clr%[0m
@echo Îòëàäêà è ëîãèðîâàíèå 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Îòêëþ÷èòü æóðíàë çàãðóçêè.%clr%[92m
@echo Îòêëþ÷èòü æóðíàë çàãðóçêè. 1>> %logfile%
set timerStart=!time!
bcdedit /set bootlog No 1>> %logfile% 2>>&1
bcdedit /event Off 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Ôîðìàò æóðíàëà çàãðóçêè (âîçìîæíûå çíà÷åíèÿ: Default, Sha1).%clr%[92m
@echo Ôîðìàò æóðíàëà çàãðóçêè (âîçìîæíûå çíà÷åíèÿ: Default, Sha1). 1>> %logfile%
set timerStart=!time!
bcdedit /set measuredbootlogformat Default 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Îòêëþ÷èòü îòëàäêó.%clr%[92m
@echo Îòêëþ÷èòü îòëàäêó. 1>> %logfile%
set timerStart=!time!
bcdedit /dbgsettings LOCAL /start Disable 1>> %logfile% 2>>&1
bcdedit /dbgsettings USB /start Disable 1>> %logfile% 2>>&1
bcdedit /dbgsettings SERIAL /start Disable 1>> %logfile% 2>>&1
bcdedit /bootdebug Off 1>> %logfile% 2>>&1
bcdedit /debug Off 1>> %logfile% 2>>&1
bcdedit /set debug No 1>> %logfile% 2>>&1
bcdedit /set debugstart Disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Îòêëþ÷èòü âûäåëåíèå ïàìÿòè äëÿ òåñòèðîâàíèÿ ïðîèçâîäèòåëüíîñòè.%clr%[92m
@echo Îòêëþ÷èòü âûäåëåíèå ïàìÿòè äëÿ òåñòèðîâàíèÿ ïðîèçâîäèòåëüíîñòè. 1>> %logfile%
set timerStart=!time!
bcdedit /set perfmem 0 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Èñïðàâèòü çàâèñàíèå ïðè çàãðóçêå ïðè âêëþ÷åíîì ðåæèìå îòëàäêè.%clr%[92m
@echo Èñïðàâèòü çàâèñàíèå ïðè çàãðóçêå ïðè âêëþ÷åíîì ðåæèìå îòëàäêè. 1>> %logfile%
set timerStart=!time!
bcdedit /set noumex Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Íàñòðîéêè íèçêîóðîâíåâîé îáîëî÷êè %clr%[0m
@echo Íàñòðîéêè íèçêîóðîâíåâîé îáîëî÷êè 1>> %logfile%
echo ••••••••••••
echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Îòêëþ÷èòü îòëàäêó ãèïåðâèçîðà.%clr%[92m
@echo Îòêëþ÷èòü îòëàäêó ãèïåðâèçîðà. 1>> %logfile%
set timerStart=!time!
bcdedit /set hypervisordebug No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Âêëþ÷èòü çàùèòó îò CVE-2018-3646 äëÿ âèðòóàëüíûõ ìàøèí.%clr%[92m
@echo Âêëþ÷èòü çàùèòó îò CVE-2018-3646 äëÿ âèðòóàëüíûõ ìàøèí. 1>> %logfile%
set timerStart=!time!
bcdedit /set hypervisorschedulertype Core 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Âêëþ÷èòü çàãðóçêó ãèïåðâèçîðà â ñèñòåìå äëÿ Hyper-V.%clr%[92m
@echo Âêëþ÷èòü çàãðóçêó ãèïåðâèçîðà â ñèñòåìå äëÿ Hyper-V. 1>> %logfile%
set timerStart=!time!
bcdedit /set hypervisorlaunchtype Auto 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Âêëþ÷èòü ïîëèòèêó IOMMU (áëîê óïðàâëåíèÿ ïàìÿòüþ äëÿ îïåðàöèé ââîäà-âûâîäà) íèçêîóðîâíåâîé îáîëî÷êè (âîçìîæíûå çíà÷åíèÿ: default, enable, disable).%clr%[92m
@echo Âêëþ÷èòü ïîëèòèêó IOMMU (áëîê óïðàâëåíèÿ ïàìÿòüþ äëÿ îïåðàöèé ââîäà-âûâîäà) íèçêîóðîâíåâîé îáîëî÷êè (âîçìîæíûå çíà÷åíèÿ: default, enable, disable). 1>> %logfile%
set timerStart=!time!
bcdedit /set hypervisoriommupolicy Enable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Èñïîëüçîâàòü ãèïåðâèçîðó áîëüøåå êîëè÷åñòâî çàïèñåé âèðòóàëüíîãî TLB (áóôåð àññîöèàòèâíîé òðàíñëÿöèè).%clr%[92m
@echo Èñïîëüçîâàòü ãèïåðâèçîðó áîëüøåå êîëè÷åñòâî çàïèñåé âèðòóàëüíîãî TLB (áóôåð àññîöèàòèâíîé òðàíñëÿöèè). 1>> %logfile%
set timerStart=!time!
bcdedit /set hypervisoruselargevtlb Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 6.%clr%[36m Îòêëþ÷èòü áåçîïàñíûé ðåæèì ïàìÿòè DMA è èçîëÿöèþ ÿäåð äëÿ ìàøèí Hyper-V.%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m âêëþ÷åíèå ðåæèìà ìîæåò ïðèâåñòè ê ñáîþ ñòàðûõ ïðèëîæåíèé è äðàéâåðîâ èëè äàæå ê BSOD.
@echo Îòêëþ÷èòü áåçîïàñíûé ðåæèì ïàìÿòè DMA è èçîëÿöèþ ÿäåð äëÿ ìàøèí Hyper-V. Ïðåäóïðåæäåíèå: âêëþ÷åíèå ðåæèìà ìîæåò ïðèâåñòè ê ñáîþ ñòàðûõ ïðèëîæåíèé è äðàéâåðîâ èëè äàæå ê BSOD. 1>> %logfile%
set timerStart=!time!
bcdedit /set vsmlaunchtype Off 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 7.%clr%[36m Îòêëþ÷èòü èçîëÿöèþ ïðîöåññîâ ÷åðåç çàùèòíèê Windows â âèðòóàëüíîì îêðóæåíèè.%clr%[92m
@echo Îòêëþ÷èòü èçîëÿöèþ ïðîöåññîâ ÷åðåç çàùèòíèê Windows â âèðòóàëüíîì îêðóæåíèè. 1>> %logfile%
set timerStart=!time!
bcdedit /set isolatedcontext No 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Îòîáðàæåíèå %clr%[0m
@echo Îòîáðàæåíèå 1>> %logfile%
echo ••••••••••••
echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Âêëþ÷èòü áëîêèðîâêó óñòðîéñòâà è ñêðûòü ýêðàí ïðèâåòñòâèÿ ïðè âõîäå â ñèñòåìó?%clr%[92m %clr%[7;31mÏðèìå÷àíèå:%clr%[0m%clr%[36m%clr%[92m ðàáîòàåò òîëüêî â ðåäàêöèÿõ Education è Enterprise.
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå áëîêèðîâêè óñòðîéñòâà è ñêðûòèå ýêðàíà ïðèâåòñòâèÿ ïðè âõîäå â ñèñòåìó. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå áëîêèðîâêè óñòðîéñòâà è ñêðûòèå ýêðàíà ïðèâåòñòâèÿ ïðè âõîäå â ñèñòåìó. Ïðèìå÷àíèå: ðàáîòàåò òîëüêî â ðåäàêöèÿõ Education è Enterprise. 1>> %logfile%
	set timerStart=!time!
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Client-EmbeddedExp-Package -NoRestart -All" 1>> %logfile% 2>>&1
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Client-DeviceLockdown -NoRestart -All" 1>> %logfile% 2>>&1
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Client-EmbeddedShellLauncher -NoRestart -All" 1>> %logfile% 2>>&1
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Client-EmbeddedBootExp -NoRestart -All" 1>> %logfile% 2>>&1
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Client-EmbeddedLogon -NoRestart -All" 1>> %logfile% 2>>&1
	xcopy %~dp0Rexplorer.exe %SystemRoot% /c /q /h /r /y 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows Embedded\BrandingNeutral" /v "HideAutoLogonUI" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon" /v "HideAutoLogonUI" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows Embedded\EmbeddedLogon" /v "HideFirstLogonAnimation" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Shell" /t REG_SZ /d "explorer.exe" /f 1>> %logfile% 2>>&1
	for /f "tokens=2" %%i in ('whoami /user /fo table /nh') do set SID=%%i
	echo Y|%rga% "HKLM\SOFTWARE\Microsoft\Windows Embedded\Shell Launcher\%SID%" /v "Shell" /t REG_SZ /d "explorer.exe" /f 1>> %logfile% 2>>&1
	echo Y|%rga% "HKLM\SOFTWARE\Microsoft\Windows Embedded\Shell Launcher\%SID%" /v "DefaultReturnCodeAction" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows Embedded\Shell Launcher\S-1-5-32-544" /v "Shell" /t REG_SZ /d "explorer.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows Embedded\Shell Launcher\S-1-5-32-544" /v "DefaultReturnCodeAction" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[91m 2.%clr%[36m Îòêëþ÷èòü èñïîëüçîâàíèå àíèìàöèè ïðè çàïóñêå.%clr%[92m
@echo Îòêëþ÷èòü èñïîëüçîâàíèå àíèìàöèè ïðè çàïóñêå. 1>> %logfile%
set timerStart=!time!
bcdedit /set bootux Disabled 1>> %logfile% 2>>&1
bcdedit /set {globalsettings} bootuxdisabled Yes 1>> %logfile% 2>>&1
bcdedit /set {globalsettings} nobootuxtext Yes 1>> %logfile% 2>>&1
bcdedit /set {globalsettings} nobootuxprogress Yes 1>> %logfile% 2>>&1
bcdedit /set {globalsettings} nobootuxfade Yes 1>> %logfile% 2>>&1
bcdedit /set {bootmgr} noerrordisplay Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Îòêëþ÷èòü ëîãîòèï çàãðóçêè.%clr%[92m
@echo Îòêëþ÷èòü ëîãîòèï çàãðóçêè. 1>> %logfile%
set timerStart=!time!
bcdedit /set {globalsettings} custom:16000067 true 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Îòêëþ÷èòü êðóã àíèìàöèè çàãðóçêè.%clr%[92m
@echo Îòêëþ÷èòü êðóã àíèìàöèè çàãðóçêè. 1>> %logfile%
set timerStart=!time!
bcdedit /set {globalsettings} custom:16000069 true 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Îòêëþ÷èòü çàãðóçî÷íûå ñîîáùåíèÿ.%clr%[92m
@echo Îòêëþ÷èòü çàãðóçî÷íûå ñîîáùåíèÿ. 1>> %logfile%
set timerStart=!time!
bcdedit /set {globalsettings} custom:16000068 true 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
@echo. 1>> %logfile%
@echo %clr%[91m 6.%clr%[36m Âðåìÿ ïåðåõîäà àíèìàöèè ïðè âîçîáíîâëåíèè.%clr%[92m
@echo Âðåìÿ ïåðåõîäà àíèìàöèè ïðè âîçîáíîâëåíèè. 1>> %logfile%
set timerStart=!time!
bcdedit /set bootuxtransitiontime 1 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 7.%clr%[36m Âêëþ÷èòü îòîáðàæåíèå ðàñòðîâîãî èçîáðàæåíèÿ ñ âûñîêèì ðàçðåøåíèåì âìåñòî îòîáðàæåíèÿ ýêðàíà çàãðóçêè Windows è àíèìàöèè.%clr%[92m
@echo Âêëþ÷èòü îòîáðàæåíèå ðàñòðîâîãî èçîáðàæåíèÿ ñ âûñîêèì ðàçðåøåíèåì âìåñòî îòîáðàæåíèÿ ýêðàíà çàãðóçêè Windows è àíèìàöèè. 1>> %logfile%
set timerStart=!time!
bcdedit /set quietboot Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 8.%clr%[36m Âêëþ÷èòü òåêñòîâûé ðåæèì çàãðóçêè ÷åðåç êëàâèøó F8 (âîçìîæíûå çíà÷åíèÿ: Legacy, Standard).%clr%[92m
@echo Âêëþ÷èòü òåêñòîâûé ðåæèì çàãðóçêè ÷åðåç êëàâèøó F8 (âîçìîæíûå çíà÷åíèÿ: Legacy, Standard). 1>> %logfile%
set timerStart=!time!
bcdedit /set bootmenupolicy Legacy 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 9.%clr%[36m Îòêëþ÷èòü ãðàôè÷åñêèé ðåæèì äëÿ çàãðóçî÷íûõ ïðèëîæåíèé.%clr%[92m
@echo Îòêëþ÷èòü ãðàôè÷åñêèé ðåæèì äëÿ çàãðóçî÷íûõ ïðèëîæåíèé. 1>> %logfile%
set timerStart=!time!
bcdedit /set graphicsmodedisabled Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 10.%clr%[36m Ðàçðåøèòü ïðèëîæåíèÿì çàãðóçêè èñïîëüçîâàòü ìàêñèìàëüíûé ãðàôè÷åñêèé ðåæèì, ïðåäîñòàâëÿåìûé âñòðîåííûì ÏÎ.%clr%[92m
@echo Ðàçðåøèòü ïðèëîæåíèÿì çàãðóçêè èñïîëüçîâàòü ìàêñèìàëüíûé ãðàôè÷åñêèé ðåæèì, ïðåäîñòàâëÿåìûé âñòðîåííûì ÏÎ. 1>> %logfile%
set timerStart=!time!
bcdedit /set highestmode Yes 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
timeout /t 3 /nobreak | break
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Windows Defender, SmartScreen, Edge, ïîèñê è Cortana. %clr%[0m
@echo Windows Defender, SmartScreen, Edge, ïîèñê è Cortana. 1>> %logfile%
echo ••••••••••••
echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Îòêëþ÷èòü Windows Defender Antivirus?%clr%[92m
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÎòêëþ÷åíèå Windows Defender Antivirus. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Îòêëþ÷åíèå Windows Defender Antivirus. 1>> %logfile%
	set timerStart=!time!
	setx /m MP_FORCE_USE_SANDBOX 0 1>> %logfile% 2>>&1
	bcdedit /set disableelamdrivers Yes 1>> %logfile% 2>>&1
	call :trusted_app net stop WinDefend
	call :trusted_app net stop WdNisSvc
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-ApplicationGuard -NoRestart -Remove" 1>> %logfile% 2>>&1
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName Windows-Defender-Default-Definitions -NoRestart -Remove" 1>> %logfile% 2>>&1
	call :acl_registry "HKLM\SOFTWARE\Microsoft\Windows Defender"
	call :acl_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Features"
	call :acl_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection"
	call :acl_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Scan"
	call :acl_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\UX Configuration"
	call :acl_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access"
	call :acl_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection"
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender /v DisableAntiSpyware /t REG_DWORD /d 1 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender /v DisableRoutinelyTakingAction /t REG_DWORD /d 1
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender /v ProductStatus /t REG_DWORD /d 0 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender /v PUAProtection /t REG_DWORD /d 0 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection /v EnableNetworkProtection /t REG_DWORD /d 0 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access /v EnableControlledFolderAccess /t REG_DWORD /d 0 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Features /v TamperProtection /t REG_DWORD /d 4 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection /v DisableAntiSpywareRealtimeProtection /t REG_DWORD /d 1 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection /v DisableIOAVProtection /t REG_DWORD /d 1 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection /v DisableOnAccessProtection /t REG_DWORD /d 1 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Scan /v AutomaticallyCleanAfterScan /t REG_DWORD /d 0 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\Scan /v ScheduleDay /t REG_DWORD /d 8 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\UX Configuration /v AllowNonAdminFunctionality /t REG_DWORD /d 0 /f
	call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows Defender\UX Configuration /v DisablePrivacyMode /t REG_DWORD /d 1 /f
	if "%arch%"=="x64" (
		call :acl_registry "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender"
		call :acl_registry "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\Real-Time Protection"
		call :acl_registry "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\Scan"
		call :acl_registry "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\UX Configuration"
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender" /v "ProductStatus" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection" /v "EnableNetworkProtection" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access" /v "EnableControlledFolderAccess" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\Real-Time Protection" /v "DisableAntiSpywareRealtimeProtection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\Scan" /v "AutomaticallyCleanAfterScan" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\Scan" /v "ScheduleDay" /t REG_DWORD /d "8" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\UX Configuration" /v "AllowNonAdminFunctionality" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows Defender\UX Configuration" /v "DisablePrivacyMode" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows Defender\Spynet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
		%rga% "HKLM\SOFTWARE\WOW6432Node\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
		call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{195B4D07-3DE2-4744-BBF2-D90121AE785B} /f
		call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{2781761E-28E0-4109-99FE-B9D127C57AFE} /f
		call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{361290c0-cb1b-49ae-9f3e-ba1cbe5dab35} /f
		call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{8a696d12-576b-422e-9712-01b9dd84b446} /f
		call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{A2D75874-6750-4931-94C1-C99D3BC9D0C7} /f
		call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{A7C452EF-8E9F-42EB-9F2B-245613CA0DC9} /f
		call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{DACA056E-216A-4FD1-84A6-C306A017ECEC} /f
		call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Wow6432Node\TypeLib\{8C389764-F036-48F2-9AE2-88C260DCF43B} /f
		%rgd% "HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f 1>> %logfile% 2>>&1
		%rgd% "HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{D8559EB9-20C0-410E-BEDA-7ED416AECC2A}" /f 1>> %logfile% 2>>&1
		%rgd% "HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{13F6A0B6-57AF-4BA7-ACAA-614BC89CA9D8}" /f 1>> %logfile% 2>>&1
		%rgd% "HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{94F35585-C5D7-4D95-BA71-A745AE76E2E2}" /f 1>> %logfile% 2>>&1
		%rgd% "HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{FDA74D11-C4A6-4577-9F73-D7CA8586E10D}" /f 1>> %logfile% 2>>&1
	)
	call :acl_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender"
	call :acl_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
	call :acl_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting"
	call :acl_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet"
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "CheckForSignaturesBeforeRunningScan" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v "DisableHeuristics" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericReports" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "LocalSettingOverrideSpynetReporting" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection" /v "EnableNetworkProtection" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access" /v "EnableControlledFolderAccess" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	call :disable_svc_sudo WinDefend
	call :disable_svc_sudo WdBoot
	call :disable_svc_sudo WdFilter
	call :disable_svc_sudo WdNisDrv
	call :disable_svc_sudo WdNisSvc
	call :disable_svc_sudo Wdnsfltr
	call :disable_svc_sudo wscsvc
	call :disable_svc_sudo Sense
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	call :trusted_app %rgd% HKLM\SOFTWARE\Classes\CLSID\{195B4D07-3DE2-4744-BBF2-D90121AE785B} /f
	call :trusted_app %rgd% HKLM\SOFTWARE\Classes\CLSID\{2781761E-28E0-4109-99FE-B9D127C57AFE} /f
	call :trusted_app %rgd% HKLM\SOFTWARE\Classes\CLSID\{361290c0-cb1b-49ae-9f3e-ba1cbe5dab35} /f
	call :trusted_app %rgd% HKLM\SOFTWARE\Classes\CLSID\{8a696d12-576b-422e-9712-01b9dd84b446} /f
	call :trusted_app %rgd% HKLM\SOFTWARE\Classes\CLSID\{A2D75874-6750-4931-94C1-C99D3BC9D0C7} /f
	call :trusted_app %rgd% HKLM\SOFTWARE\Classes\CLSID\{A7C452EF-8E9F-42EB-9F2B-245613CA0DC9} /f
	call :trusted_app %rgd% HKLM\SOFTWARE\Classes\CLSID\{DACA056E-216A-4FD1-84A6-C306A017ECEC} /f
	call :trusted_app %rgd% HKLM\SOFTWARE\Classes\TypeLib\{8C389764-F036-48F2-9AE2-88C260DCF43B} /f
	%rgd% "HKLM\SOFTWARE\Classes\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Classes\CLSID\{D8559EB9-20C0-410E-BEDA-7ED416AECC2A}" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Classes\CLSID\{13F6A0B6-57AF-4BA7-ACAA-614BC89CA9D8}" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Classes\CLSID\{94F35585-C5D7-4D95-BA71-A745AE76E2E2}" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Classes\CLSID\{FDA74D11-C4A6-4577-9F73-D7CA8586E10D}" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "WindowsDefender" /f 1>> %logfile% 2>>&1
	call :disable_task "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
	call :disable_task "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
	call :disable_task "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
	call :disable_task "\Microsoft\Windows\Windows Defender\Windows Defender Verification"
	call :acl_file-folders "%ProgramData%\Microsoft\Windows Defender"
	rmdir /s /q "%ProgramData%\Microsoft\Windows Defender" 1>> %logfile% 2>>&1
	call :acl_file-folders "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection"
	rmdir /s /q "%ProgramData%\Microsoft\Windows Defender Advanced Threat Protection" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	@echo. 1>> %logfile%
)
rem #########################################################################################################################################################################################################################
@echo %clr%[91m 2.%clr%[36m Îòêëþ÷èòü SmartScreen?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÎòêëþ÷åíèå SmartScreen. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Îòêëþ÷åíèå SmartScreen. 1>> %logfile%
	set timerStart=!time!
	%rga% "HKCU\SOFTWARE\Microsoft\Windows Security Health\State" /v "AccountProtection_MicrosoftAccount_Disconnected" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows Security Health\State" /v "AppAndBrowser_EdgeSmartScreenOff" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /t REG_SZ /d "Warn" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableHHDEP" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SecHealthUI.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d "BlockSecHealthUI|Action=Block|Active=TRUE|Dir=Out|App=C:\Windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\SearchUI.exe|Name=SecHealthUI application|" /f 1>> %logfile% 2>>&1
	call :acl_file-folders "%SystemRoot%\SystemApps\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy\SecHealthUI.exe"
	call :kill "SecHealthUI.exe"
	ren %SystemRoot%\SystemApps\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy\SecHealthUI.exe SecHealthUI.bkp 1>> %logfile% 2>>&1
	call :kill "SecurityHealthSystray.exe"
	call :disable_svc_sudo SecurityHealthService
	call :acl_file-folders "%ProgramData%\Microsoft\Windows Security Health"
	rmdir /s /q "%ProgramData%\Microsoft\Windows Security Health" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	@echo. 1>> %logfile%
)
rem #########################################################################################################################################################################################################################
@echo %clr%[91m 3.%clr%[36m Óäàëèòü Microsoft Edge?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÓäàëåíèå Microsoft Edge. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Óäàëåíèå Microsoft Edge. 1>> %logfile%
	set timerStart=!time!
	call :disable_svc edgeupdatem
	call :kill "browser_broker.exe"
	call :kill "RuntimeBroker.exe"
	call :kill "MicrosoftEdge.exe"
	call :kill "MicrosoftEdgeCP.exe"
	call :kill "MicrosoftEdgeSH.exe"
	%rga% "HKLM\SOFTWARE\Microsoft" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	if "%arch%"=="x64" ( %PS% "Start-Process -FilePath ${env:ProgramFiles(x86)}\Microsoft\Edge\Application\*\Installer\setup.exe -ArgumentList '-uninstall -system-level -verbose-logging -force-uninstall' -NoNewWindow -Wait" 1>> %logfile% 2>>&1 )
	if "%arch%"=="x86" ( %PS% "Start-Process -FilePath ${env:ProgramFiles}\Microsoft\Edge\Application\*\Installer\setup.exe -ArgumentList '-uninstall -system-level -verbose-logging -force-uninstall' -NoNewWindow -Wait" 1>> %logfile% 2>>&1 )
	call :acl_file-folders "%SystemRoot%\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
	rmdir /s /q "%SystemRoot%\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" 1>> %logfile% 2>>&1
	call :acl_file-folders "%ProgramFiles%\Microsoft\Edge"
	rmdir /s /q "%ProgramFiles%\Microsoft\Edge" 1>> %logfile% 2>>&1
	call :acl_file-folders "%ProgramFiles%\Microsoft\EdgeUpdate"
	rmdir /s /q "%ProgramFiles%\Microsoft\EdgeUpdate" 1>> %logfile% 2>>&1
	call :acl_file-folders "%ProgramFiles%\Microsoft\Temp"
	rmdir /s /q "%ProgramFiles%\Microsoft\Temp" 1>> %logfile% 2>>&1
	if "%arch%"=="x64" (
		call :acl_file-folders "%ProgramFiles(x86)%\Microsoft\Edge"
		rmdir /s /q "%ProgramFiles(x86)%\Microsoft\Edge" 1>> %logfile% 2>>&1
		call :acl_file-folders "%ProgramFiles(x86)%\Microsoft\EdgeUpdate"
		rmdir /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate" 1>> %logfile% 2>>&1
		call :acl_file-folders "%ProgramFiles(x86)%\Microsoft\Temp"
		rmdir /s /q "%ProgramFiles(x86)%\Microsoft\Temp" 1>> %logfile% 2>>&1
	)
	call :acl_file-folders "%ProgramData%\Microsoft\EdgeUpdate"
	rmdir /s /q "%ProgramData%\Microsoft\EdgeUpdate" 1>> %logfile% 2>>&1
	rmdir /s /q "%AppData%\Microsoft\Edge" 1>> %logfile% 2>>&1
	rmdir /s /q "%LocalAppData%\MicrosoftEdge" 1>> %logfile% 2>>&1
	rmdir /s /q "%LocalAppData%\Microsoft\Edge" 1>> %logfile% 2>>&1
	rmdir /s /q "%LocalAppData%\Microsoft\EdgeBho" 1>> %logfile% 2>>&1
	rmdir /s /q "%UserProfile%\MicrosoftEdgeBackups" 1>> %logfile% 2>>&1
	rmdir /s /q "%UserProfile%\AppData\LocalLow\Microsoft\EdgeBho" 1>> %logfile% 2>>&1
	%rf% "%AppData%\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk" 1>> %logfile% 2>>&1
	%rf% "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" 1>> %logfile% 2>>&1
	%rf% "%HomePath%\Desktop\Microsoft Edge.lnk" 1>> %logfile% 2>>&1
	%rf% "%Public%\Desktop\Microsoft Edge.lnk" 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v "FavoritesResolve" /t REG_BINARY /d "320300004c0000000114020000000000c00000000000004683008000200000007a93da2ef73cd7012858df2ef73cd701d353b05b0eded401970100000000000001000000000000000000000000000000a0013a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000004c43b521f73cd7016845cc2ef73cd701cff5dc2ef73cd701140056003100000000009d52296711005461736b42617200400009000400efbe9d5229679d5229672e000000d6050200000001000000000000000000000000000000311581005400610073006b00420061007200000016000e01320097010000734e7c25200046494c4545587e312e4c4e4b00007c0009000400efbe9d5229679d5229672e000000d70502000000010000000000000000005200000000002dfa9b00460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00220000001e00efbe02005500730065007200500069006e006e006500640000001c00120000002b00efbe2858df2ef73cd7011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c0000009b0000001c000000010000001c0000002d000000000000009a0000001100000003000000e06219521000000000433a5c55736572735c746573745c417070446174615c526f616d696e675c4d6963726f736f66745c496e7465726e6574204578706c6f7265725c517569636b204c61756e63685c557365722050696e6e65645c5461736b4261725c46696c65204578706c6f7265722e6c6e6b000060000000030000a058000000000000006465736b746f702d3668747071376600cc9e61a2a4954f42ac398d38cb60e68887f9b542e9a8eb11a0e000155d125200cc9e61a2a4954f42ac398d38cb60e68887f9b542e9a8eb11a0e000155d12520045000000090000a03900000031535053b1166d44ad8d7048a748402ea43d788c1d00000068000000004800000030462c212f54464e88b6c5eb1d5292d00000000000000000000000009d0600004c0000000114020000000000c00000000000004681008000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000004b0614001f809bd434424502f34db7803893943456e1350600009d05415050538b0508000300000000000000520200003153505355284c9f799f394ba8d0e1d42de1d5f35d00000011000000001f000000250000004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f003800770065006b0079006200330064003800620062007700650000000000110000000e0000000013000000010000008500000015000000001f0000003a0000004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f00310031003800310031002e0031003000300031002e00310038002e0030005f007800360034005f005f003800770065006b0079006200330064003800620062007700650000006500000005000000001f000000290000004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f003800770065006b00790062003300640038006200620077006500210041007000700000000000c10000000f000000001f0000005700000043003a005c00500072006f006700720061006d002000460069006c00650073005c00570069006e0064006f007700730041007000700073005c004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f00310031003800310031002e0031003000300031002e00310038002e0030005f007800360034005f005f003800770065006b00790062003300640038006200620077006500000000001d00000020000000004800000078d85872f8786e42a43f34253f188061000000008a020000315350534d0bd48669903c44819a2a54090dccec550000000c000000001f000000210000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f00720065004d0065006400540069006c0065002e0070006e006700000000005500000002000000001f000000210000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f00720065004100700070004c006900730074002e0070006e00670000000000590000000f000000001f000000230000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f0072006500420061006400670065004c006f0067006f002e0070006e00670000000000550000000d000000001f000000220000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f00720065005700690064006500540069006c0065002e0070006e0067000000110000000400000000130000000078d7ff5900000013000000001f000000230000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f00720065004c006100720067006500540069006c0065002e0070006e0067000000000011000000050000000013000000ffffffff110000000e0000000013000000a5040000310000000b000000001f000000100000004d006900630072006f0073006f00660074002000530074006f007200650000005900000014000000001f000000230000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f007200650053006d0061006c006c00540069006c0065002e0070006e00670000000000000000003100000031535053b1166d44ad8d7048a748402ea43d788c150000006400000000150000004200000000000000000000004d0000003153505330f125b7ef471a10a5f102608c9eebac310000000a000000001f000000100000004d006900630072006f0073006f00660074002000530074006f00720065000000000000002d00000031535053b377ed0d14c66c45ae5b285b38d7b01b110000000700000000130000000000000000000000000000000000220000001e00efbe02005500730065007200500069006e006e00650064000000a305120000002b00efbee21ce42ef73cd701a3055e0000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f003800770065006b0079006200330064003800620062007700650021004100700070000000a305000000000000" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband" /v "Favorites" /t REG_BINARY /d "00a40100003a001f80c827341f105c1042aa032ee45287d668260001002600efbe120000004c43b521f73cd7016845cc2ef73cd701cff5dc2ef73cd701140056003100000000009d52296711005461736b42617200400009000400efbe9d5229679d5229672e000000d6050200000001000000000000000000000000000000311581005400610073006b00420061007200000016001201320097010000734e7c25200046494c4545587e312e4c4e4b00007c0009000400efbe9d5229679d5229672e000000d70502000000010000000000000000005200000000002dfa9b00460069006c00650020004500780070006c006f007200650072002e006c006e006b00000040007300680065006c006c00330032002e0064006c006c002c002d003200320030003600370000001c00120000002b00efbe2858df2ef73cd7011c00420000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f00770073002e004500780070006c006f0072006500720000001c00260000001e00efbe0200530079007300740065006d00500069006e006e006500640000001c000000004f06000014001f809bd434424502f34db7803893943456e1390600009d05415050538b0508000300000000000000520200003153505355284c9f799f394ba8d0e1d42de1d5f35d00000011000000001f000000250000004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f003800770065006b0079006200330064003800620062007700650000000000110000000e0000000013000000010000008500000015000000001f0000003a0000004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f00310031003800310031002e0031003000300031002e00310038002e0030005f007800360034005f005f003800770065006b0079006200330064003800620062007700650000006500000005000000001f000000290000004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f003800770065006b00790062003300640038006200620077006500210041007000700000000000c10000000f000000001f0000005700000043003a005c00500072006f006700720061006d002000460069006c00650073005c00570069006e0064006f007700730041007000700073005c004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f00310031003800310031002e0031003000300031002e00310038002e0030005f007800360034005f005f003800770065006b00790062003300640038006200620077006500000000001d00000020000000004800000078d85872f8786e42a43f34253f188061000000008a020000315350534d0bd48669903c44819a2a54090dccec550000000c000000001f000000210000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f00720065004d0065006400540069006c0065002e0070006e006700000000005500000002000000001f000000210000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f00720065004100700070004c006900730074002e0070006e00670000000000590000000f000000001f000000230000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f0072006500420061006400670065004c006f0067006f002e0070006e00670000000000550000000d000000001f000000220000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f00720065005700690064006500540069006c0065002e0070006e0067000000110000000400000000130000000078d7ff5900000013000000001f000000230000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f00720065004c006100720067006500540069006c0065002e0070006e0067000000000011000000050000000013000000ffffffff110000000e0000000013000000a5040000310000000b000000001f000000100000004d006900630072006f0073006f00660074002000530074006f007200650000005900000014000000001f000000230000004100730073006500740073005c00410070007000540069006c00650073005c00530074006f007200650053006d0061006c006c00540069006c0065002e0070006e00670000000000000000003100000031535053b1166d44ad8d7048a748402ea43d788c150000006400000000150000004200000000000000000000004d0000003153505330f125b7ef471a10a5f102608c9eebac310000000a000000001f000000100000004d006900630072006f0073006f00660074002000530074006f00720065000000000000002d00000031535053b377ed0d14c66c45ae5b285b38d7b01b110000000700000000130000000000000000000000000000000000120000002b00efbee21ce42ef73cd701a3055e0000001d00efbe02004d006900630072006f0073006f00660074002e00570069006e0064006f0077007300530074006f00720065005f003800770065006b0079006200330064003800620062007700650021004100700070000000a305260000001e00efbe0200530079007300740065006d00500069006e006e00650064000000a3050000ff" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MicrosoftEdge.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\msedge.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
	call :disable_task "\MicrosoftEdgeUpdateTaskMachineCore"
	call :disable_task "\MicrosoftEdgeUpdateTaskMachineUA"
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	timeout /t 3 /nobreak | break
	@echo. 1>> %logfile%
)
rem #########################################################################################################################################################################################################################
@echo %clr%[91m 3.%clr%[36m Îòêëþ÷èòü ñëóæáó ïîèñêà è Cortana?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÎòêëþ÷åíèå ñëóæáû ïîèñêà è Cortana. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Îòêëþ÷åíèå ñëóæáû ïîèñêà è Cortana. 1>> %logfile%
	set timerStart=!time!
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName SearchEngine-Client-Package -NoRestart -Remove" 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "VoiceActivationOn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "VoiceActivationDefaultOn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "VoiceActivationEnableAboveLockscreen" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Experience\AllowCortana" /v "value" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "AllowCortana" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaInAmbientMode" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "VoiceShortcut" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowIndexingEncryptedStoresOrItems" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AlwaysUseAutoLangDetection" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v "DisableVoice" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CanCortanaBeEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId" /v "State" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCortanaButton" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Experience" /v "AllowCortana" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	call :remove_uwp Microsoft.549981C3F5F10
	%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Cortana.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchApp.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchUI.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d "BlockCortana|Action=Block|Active=TRUE|Dir=Out|App=C:\Windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\SearchUI.exe|Name=Search and Cortana application|" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t REG_SZ /d "BlockSearch|Action=Block|Active=TRUE|Dir=Out|App=C:\Windows\systemapps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe|Name=Search application|" /f 1>> %logfile% 2>>&1
	call :acl_file-folders "%SystemRoot%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe"
	call :kill "SearchUI.exe"
	ren %SystemRoot%\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe SearchUI.bkp 1>> %logfile% 2>>&1
	call :acl_file-folders "%SystemRoot%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe"
	call :kill "SearchApp.exe"
	ren %SystemRoot%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe SearchApp.bkp 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
rem #########################################################################################################################################################################################################################
@echo %clr%[91m 4.%clr%[36m Îòêëþ÷èòü Öåíòð îáíîâëåíèÿ Windows?%clr%[92m
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÎòêëþ÷åíèå Öåíòðà îáíîâëåíèÿ Windows. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Îòêëþ÷åíèå Öåíòðà îáíîâëåíèÿ Windows. 1>> %logfile%
	set timerStart=!time!
	call :disable_svc wuauserv
	call :disable_svc UsoSvc
	call :disable_svc WaaSMedicSvc
	call :disable_task "\Microsoft\Windows\WaaSMedic\PerformRemediation"
	call :disable_task "\Microsoft\Windows\WindowsUpdate\sihpostreboot"
	call :disable_task "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f 1>> %logfile%
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f 1>> %logfile%
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "DetectionFrequencyEnabled" /t REG_DWORD /d "0" /f 1>> %logfile%
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownLoadMode" /t REG_DWORD /d "100" /f 1>> %logfile%
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	@echo. 1>> %logfile%
)
rem #########################################################################################################################################################################################################################
@echo %clr%[91m 5.%clr%[36m Îòêëþ÷èòü ñëóæáû ïå÷àòè è ñêàíèðîâàíèÿ?%clr%[92m
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÎòêëþ÷åíèå ñëóæá ïå÷àòè è ñêàíèðîâàíèÿ. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Îòêëþ÷åíèå ñëóæá ïå÷àòè è ñêàíèðîâàíèÿ. 1>> %logfile%
	set timerStart=!time!
	call :disable_svc_sudo PrintWorkflowUserSvc
	call :disable_svc Spooler
	call :disable_svc WiaRpc
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	@echo. 1>> %logfile%
)
rem #########################################################################################################################################################################################################################
@echo. 1>> %logfile%
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Îò÷åòû è ðåêëàìà %clr%[0m
@echo Îò÷åòû è ðåêëàìà 1>> %logfile%
echo ••••••••••••
echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Îòêëþ÷èòü îò÷åòû îá îøèáêàõ Windows.%clr%[92m
@echo Îòêëþ÷èòü îò÷åòû îá îøèáêàõ Windows. 1>> %logfile%
set timerStart=!time!
call :disable_svc WerSvc
call :disable_svc wercplsupport
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "AutoApproveOSDumps" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "ForceQueueMode" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoExternalURL" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoFileCollection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoSecondLevelCollection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\HelpSvc" /v "Headlines" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\HelpSvc" /v "MicrosoftKBSearch" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v "DisableSendRequestAdditionalSoftwareToWER" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
call :disable_task "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
call :disable_task "\Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate"
call :disable_task "\Microsoft\Windows\ErrorDetails\ErrorDetailsUpdate"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Îòêëþ÷èòü ñîâåòû Windows.%clr%[92m
@echo Îòêëþ÷èòü ñîâåòû Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableTelemetryOptInChangeNotification" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v "AllowSuggestedAppsInWindowsInkWorkspace" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Îòêëþ÷èòü îòîáðàæåíèå ðåêëàìû, ïðåäëîæåíèÿ ïðèëîæåíèé è èõ àâòîìàòè÷åñêóþ óñòàíîâêó.%clr%[92m
@echo Îòêëþ÷èòü îòîáðàæåíèå ðåêëàìû, ïðåäëîæåíèÿ ïðèëîæåíèé è èõ àâòîìàòè÷åñêóþ óñòàíîâêó. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "FeatureManagementEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310091Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310092Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314563Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338380Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338381Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%PS% "Set-ItemProperty -Path (Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.placeholdertilecollection\Current').PSPath -Name 'Data' -Type Binary -Value (Get-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.placeholdertilecollection\Current').Data[0..15]" 1>> %logfile% 2>>&1
sc stop ShellExperienceHost 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Çàïðåòèòü ïðèëîæåíèÿì èñïîëüçîâàòü ðåêëàìíûé èäåíòèôèêàòîð.%clr%[92m
@echo Çàïðåòèòü ïðèëîæåíèÿì èñïîëüçîâàòü ðåêëàìíûé èäåíòèôèêàòîð. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Id" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 6.%clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèé AppStore ê ñïèñêó ÿçûêîâ.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèé AppStore ê ñïèñêó ÿçûêîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Ñåòåâàÿ îïòèìèçàöèÿ %clr%[0m
@echo Ñåòåâàÿ îïòèìèçàöèÿ 1>> %logfile%
echo ••••••••••••
echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1.%clr%[36m Ïðèìåíåíèå íàñòðîåê ñåòåâîé îïòèìèçàöèè.%clr%[92m
@echo Ïðèìåíåíèå íàñòðîåê ñåòåâîé îïòèìèçàöèè. 1>> %logfile%
set timerStart=!time!
echo Î÷èñòêà òàáëèö ìàðøðóòèçàöèè âñåõ øëþçîâ... 1>> %logfile%
route -f 1>> %logfile% 2>>&1
echo Ñáðîñ ñåòåâûõ ïðîòîêîëîâ... 1>> %logfile%
netsh winsock reset 1>> %logfile% 2>>&1
echo Îñâîáîæäåíèå IP-àäðåñà... 1>> %logfile%
ipconfig /release 1>> %logfile% 2>>&1
echo Îáíîâëåíèå IP-àäðåñà... 1>> %logfile%
ipconfig /renew 1>> %logfile% 2>>&1
echo Î÷èñòêà êåøà ïðîòîêîëà ðàçðåøåíèÿ àäðåñîâ (ARP)... 1>> %logfile%
arp -d * 1>> %logfile% 2>>&1
netsh interface ip delete arpcache 1>> %logfile% 2>>&1
echo Ïåðåçàãðóçêà êýøà èìåí NetBIOS... 1>> %logfile%
nbtstat -r 1>> %logfile% 2>>&1
echo Îòïðàâêà îáíîâëåíèÿ èìåíè NetBIOS... 1>> %logfile%
nbtstat -rr 1>> %logfile% 2>>&1
echo Î÷èñòêà êåøà ñèñòåìû äîìåííûõ èìåí (DNS)... 1>> %logfile%
ipconfig /flushdns 1>> %logfile% 2>>&1
echo Ðåãèñòðàöèÿ DNS-èìåíè... 1>> %logfile%
ipconfig /registerdns 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultReceiveWindow" /t REG_DWORD /d "16384" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DefaultSendWindow" /t REG_DWORD /d "16384" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DisableRawSecurity" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "DynamicSendBufferDisable" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "FastCopyReceiveThreshold" /t REG_DWORD /d "16384" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "FastSendDatagramThreshold" /t REG_DWORD /d "16384" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "IgnorePushBitOnReceives" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters" /v "NonBlockingSendSpecialBuffering" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "CongestionAlgorithm" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DelayedAckFrequency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DelayedAckTicks" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MultihopSets" /t REG_DWORD /d "15" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "FastCopyReceiveThreshold" /t REG_DWORD /d "16384" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "FastSendDatagramThreshold" /t REG_DWORD /d "16384" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "KeepAliveTime" /t REG_DWORD /d "7200000" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "QualifyingDestinationThreshold" /t REG_DWORD /d 3 /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "SynAttackProtect" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "TcpCreateAndConnectTcbRateLimitDepth" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "TcpMaxDataRetransmissions" /t REG_DWORD /d "5" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d "5840" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d "5840" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUBHDetect" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "UseDelayedAcceptance" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "MaxSockAddrLength" /t REG_DWORD /d "16" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Winsock" /v "MinSockAddrLength" /t REG_DWORD /d "16" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters" /v "DisabledComponents" /t REG_DWORD /d "255" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\WinSock2\Parameters" /v "Ws2_32NumHandleBuckets" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RemoteComputer\NameSpace\{D6277990-4C6A-11CF-8D87-00AA0060F5BF}" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "MaxOutstandingSends" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\DiffservByteMappingConforming" /v "ServiceTypeGuaranteed" /t REG_DWORD /d "46" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\DiffservByteMappingConforming" /v "ServiceTypeNetworkControl" /t REG_DWORD /d "56" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\DiffservByteMappingNonConforming" /v "ServiceTypeGuaranteed" /t REG_DWORD /d "46" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\DiffservByteMappingNonConforming" /v "ServiceTypeNetworkControl" /t REG_DWORD /d "56" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeGuaranteed" /t REG_DWORD /d "5" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched\UserPriorityMapping" /v "ServiceTypeNetworkControl" /t REG_DWORD /d "7" /f 1>> %logfile% 2>>&1
netsh int ip set global neighborcachelimit=4096 1>> %logfile% 2>>&1
netsh int ip set global taskoffload=disabled 1>> %logfile% 2>>&1
netsh int tcp set global autotuninglevel=normal 1>> %logfile% 2>>&1
netsh int tcp set global netdma=disabled 1>> %logfile% 2>>&1
netsh int tcp set global timestamps=disabled 1>> %logfile% 2>>&1
netsh int isatap set state disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2.%clr%[36m Îòêëþ÷èòü ýâðèñòèêó ìàñøòàáèðîâàíèÿ, ÷òîáû ïðåäîòâðàòèòü èçìåíåíèå óðîâíÿ àâòîíàñòðîéêè îêíà.%clr%[92m
@echo Îòêëþ÷èòü ýâðèñòèêó ìàñøòàáèðîâàíèÿ, ÷òîáû ïðåäîòâðàòèòü èçìåíåíèå óðîâíÿ àâòîíàñòðîéêè îêíà. 1>> %logfile%
set timerStart=!time!
netsh int tcp set heuristics disabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3.%clr%[36m Óñòàíîâèòü 2 ïîïûòêè äëÿ âîññòàíîâëåíèÿ ñîåäèíåíèÿ.%clr%[92m
@echo Óñòàíîâèòü 2 ïîïûòêè äëÿ âîññòàíîâëåíèÿ ñîåäèíåíèÿ. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global maxsynretransmissions=2 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4.%clr%[36m Âêëþ÷èòü ïðÿìîé äîñòóï ê êåøó.%clr%[92m
@echo Âêëþ÷èòü ïðÿìîé äîñòóï ê êåøó. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global dca=enabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5.%clr%[36m Âêëþ÷èòü îòêàçîóñòîé÷èâîñòü áåç SACK RTT.%clr%[92m
@echo Âêëþ÷èòü îòêàçîóñòîé÷èâîñòü áåç SACK RTT. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global nonsackrttresiliency=enabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 6.%clr%[36m Óñòàíîâèòü íà÷àëüíîå îêíî ïåðåãðóçêè íà 10.%clr%[92m
@echo Óñòàíîâèòü íà÷àëüíîå îêíî ïåðåãðóçêè íà 10. 1>> %logfile%
set timerStart=!time!
%PS% "Set-NetTCPSetting -SettingName InternetCustom -InitialCongestionWindow 10" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 7.%clr%[36m Îòêëþ÷èòü çàùèòó îò äàâëåíèÿ ïàìÿòè.%clr%[92m
@echo Îòêëþ÷èòü çàùèòó îò äàâëåíèÿ ïàìÿòè. 1>> %logfile%
set timerStart=!time!
netsh int tcp set security mpp=disabled 1>> %logfile% 2>>&1
netsh int tcp set security profiles=disabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 8.%clr%[36m Óñòàíîâèòü ìàêñèìàëüíûé áëîê ïåðåäà÷è (MTU) äî 1492.%clr%[92m
@echo Óñòàíîâèòü ìàêñèìàëüíûé áëîê ïåðåäà÷è (MTU) äî 1492. 1>> %logfile%
set timerStart=!time!
%PS% "foreach ($adp in (Get-NetAdapter | Where {$_.Name -Match 'Ethernet'}).Name){netsh interface ipv4 set interface Ethernet mtu=1492 store=persistent}" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 9.%clr%[36m Óñòàíîâèòü TTL íà 64.%clr%[92m
@echo Óñòàíîâèòü TTL íà 64. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 10.%clr%[36m Óñòàíîâèòü ïîääåðæêó ïîëüçîâàòåëüñêèõ ïîðòîâ äî 65534.%clr%[92m
@echo Óñòàíîâèòü ïîääåðæêó ïîëüçîâàòåëüñêèõ ïîðòîâ äî 65534. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 11.%clr%[36m Óñòàíîâèòü âðåìÿ îæèäàíèÿ TCP äî 30.%clr%[92m
@echo Óñòàíîâèòü âðåìÿ îæèäàíèÿ TCP äî 30. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 12.%clr%[36m Óñòàíîâèòü ïðèîðèòåòû ðàçðåøåíèÿ õîñòà.%clr%[92m
@echo Óñòàíîâèòü ïðèîðèòåòû ðàçðåøåíèÿ õîñòà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 13.%clr%[36m Îòêëþ÷èòü çàðåçåðâèðîâàííóþ ïðîïóñêíóþ ñïîñîáíîñòü QoS.%clr%[92m
@echo Îòêëþ÷èòü çàðåçåðâèðîâàííóþ ïðîïóñêíóþ ñïîñîáíîñòü QoS. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 14.%clr%[36m Îòêëþ÷èòü ýâðèñòèêó ìàñøòàáèðîâàíèÿ.%clr%[92m
@echo Îòêëþ÷èòü ýâðèñòèêó ìàñøòàáèðîâàíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableHeuristics" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableWsd" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 15.%clr%[36m Âêëþ÷èòü ìàñøòàáèðîâàíèå îêíà RFC 1323.%clr%[92m
@echo Âêëþ÷èòü ìàñøòàáèðîâàíèå îêíà RFC 1323. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 16.%clr%[36m Óñòàíîâèòü ðàçìåð ïàêåòà UDP íà 1280.%clr%[92m
@echo Óñòàíîâèòü ðàçìåð ïàêåòà UDP íà 1280. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaximumUdpPacketSize" /t REG_DWORD /d "1280" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 17.%clr%[36m Çàäàòü ïàðàìåòðû âðåìåíè êýøèðîâàíèÿ DNS.%clr%[92m
@echo Çàäàòü ïàðàìåòðû âðåìåíè êýøèðîâàíèÿ DNS. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeCacheTime" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NegativeSOACacheTime" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "NetFailureCacheTime" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Dnscache\Parameters" /v "MaxNegativeCacheTtl" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\Dnscache\Parameters" /v "MaxCacheTtl" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 18.%clr%[36m Íàñòðîéêà ïàðàìåòðîâ îïòèìèçàöèè äëÿ ñåòåâûõ àäàïòåðîâ.%clr%[92m
@echo Íàñòðîéêà ïàðàìåòðîâ îïòèìèçàöèè äëÿ ñåòåâûõ àäàïòåðîâ. 1>> %logfile%
set timerStart=!time!
for /f "delims=" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" /s /v ProviderName 2^>nul') do call :adapters "%%i"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 19.%clr%[36m Óñòàíîâèòü àëãîðèòìû Nagle äëÿ ñåòåâûõ èíòåðôåéñîâ.%clr%[92m
@echo Óñòàíîâèòü àëãîðèòìû Nagle äëÿ ñåòåâûõ èíòåðôåéñîâ. 1>> %logfile%
set timerStart=!time!
for /f "tokens=3 delims=_ " %%i in ('net config rdr ^| find /i "tcpip"') do (
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\ControlSet002\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\ControlSet002\Services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\ControlSet002\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 20.%clr%[36m Ïðåäîòâðàòèòü îòïðàâêó ó÷åòíûõ äàííûõ NTLM íà óäàëåííûå ñåðâåðû?%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m áëîêèðîâêà çàïðîñîâ NTLM íàðóøàåò àâòîðèçàöèþ â RDP è Samba.
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÇàïðåò îòïðàâêè ó÷åòíûõ äàííûõ NTLM ïðèìåíåí.%clr%[92m
	@echo Çàïðåò îòïðàâêè ó÷åòíûõ äàííûõ NTLM ïðèìåíåí. Ïðåäóïðåæäåíèå: áëîêèðîâêà çàïðîñîâ NTLM íàðóøàåò àâòîðèçàöèþ â RDP è Samba. 1>> %logfile%
	set timerStart=!time!
	%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" /v "RestrictReceivingNTLMTraffic" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" /v "RestrictSendingNTLMTraffic" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[91m 21.%clr%[36m Çàïðåòèòü ïîëó÷åíèå ìåòàäàííûõ è îáùèé äîñòóï â ïðîèãðûâàòåëå Windows Media.%clr%[92m
@echo Çàïðåòèòü ïîëó÷åíèå ìåòàäàííûõ è îáùèé äîñòóï â ïðîèãðûâàòåëå Windows Media. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" /v "PreventCDDVDMetadataRetrieval" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" /v "PreventMusicFileMetadataRetrieval" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" /v "PreventRadioPresetsRetrieval" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
call :disable_svc WMPNetworkSvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 22.%clr%[36m Îòêëþ÷èòü ìàñòåð ïîäêëþ÷åíèÿ Windows Connect Now (íàñòðàèâàåò ïàðàìåòðû òî÷êè äîñòóïà èëè Wi-Fi).%clr%[92m
@echo Îòêëþ÷èòü ìàñòåð ïîäêëþ÷åíèÿ Windows Connect Now (íàñòðàèâàåò ïàðàìåòðû òî÷êè äîñòóïà èëè Wi-Fi). 1>> %logfile%
set timerStart=!time!
call :disable_svc wcncsvc
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableFlashConfigRegistrar" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableInBand802DOT11Registrar" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableUPnPRegistrar" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableWPDRegistrar" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "EnableRegistrars" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\UI" /v "DisableWcnUi" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\WCN\UI" /v "DisableWcnUi" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 22.%clr%[36m Èñïðàâèòü ïðîáëåìó ñ çàìûëèâàíèåì íåêîòîðûõ îêîí ïðè ìàñøòàáèðîâàíèè ýêðàíà â õ125.%clr%[92m
@echo Èñïðàâèòü ïðîáëåìó ñ çàìûëèâàíèåì íåêîòîðûõ îêîí ïðè ìàñøòàáèðîâàíèè ýêðàíà â õ125. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\Control Panel\Desktop" /v "DpiScalingVer" /t REG_DWORD /d "1018" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Desktop" /v "Win8DpiScaling" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Desktop" /v "LogPixels" /t REG_DWORD /d "78" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 22.%clr%[36m Îòêëþ÷èòü íàáëþäåíèå çà äàò÷èêàìè (êîîðåêòèðîâêà ÿðêîñòè äèñïëåÿ, ïîâîðîòà ýêðàíà è ò.ä.).%clr%[92m
@echo Îòêëþ÷èòü íàáëþäåíèå çà äàò÷èêàìè (êîîðåêòèðîâêà ÿðêîñòè äèñïëåÿ, ïîâîðîòà ýêðàíà è ò.ä.). 1>> %logfile%
set timerStart=!time!
call :disable_svc SensrSvc
call :disable_svc SensorService
call :disable_svc SensorDataService
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ôóíêöèþ îïðåäåëåíèÿ ìåñòîïîëîæåíèÿ è ñêðèïòû äëÿ ôóíêöèè îïðåäåëåíèÿ ìåñòîïîëîæåíèÿ.%clr%[92m
@echo Îòêëþ÷èòü ôóíêöèþ îïðåäåëåíèÿ ìåñòîïîëîæåíèÿ è ñêðèïòû äëÿ ôóíêöèè îïðåäåëåíèÿ ìåñòîïîëîæåíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
call :disable_svc lfsvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 23.%clr%[36m Íå æäàòü íàëè÷èÿ ñåòè ïðè çàïóñêå êîìïüþòåðà è âõîäå â ñåòü äëÿ ðàáî÷èõ ãðóïï.%clr%[92m
@echo Íå æäàòü íàëè÷èÿ ñåòè ïðè çàïóñêå êîìïüþòåðà è âõîäå â ñåòü äëÿ ðàáî÷èõ ãðóïï. 1>> %logfile%
set timerStart=!time!
%rgd% "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "SyncForegroundPolicy" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 24.%clr%[36m Äîïîëíèòåëüíàÿ íàñòðîéêà Microsoft NCSI (èíäèêàòîðà ñîñòîÿíèÿ ñåòåâîãî ïîäêëþ÷åíèÿ).%clr%[92m
@echo Äîïîëíèòåëüíàÿ íàñòðîéêà Microsoft NCSI (èíäèêàòîðà ñîñòîÿíèÿ ñåòåâîãî ïîäêëþ÷åíèÿ). 1>> %logfile%
set timerStart=!time!
rem %rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "NoActiveProbe" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
rem %rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "DisablePassivePolling" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "NoActiveProbe" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "DisablePassivePolling" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveDnsProbeContent" /t REG_SZ /d "8.8.8.8" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveDnsProbeContentV6" /t REG_SZ /d "2001:4860:4860::8888" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveDnsProbeHost" /t REG_SZ /d "dns.google" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveDnsProbeHostV6" /t REG_SZ /d "dns.google" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveWebProbeContent" /t REG_SZ /d "Microsoft Connect Test" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveWebProbeContentV6" /t REG_SZ /d "Microsoft Connect Test" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveWebProbeHost" /t REG_SZ /d "www.msftconnecttest.com" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveWebProbeHostV6" /t REG_SZ /d "ipv6.msftconnecttest.com" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveWebProbePath" /t REG_SZ /d "connecttest.txt" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "ActiveWebProbePathV6" /t REG_SZ /d "connecttest.txt" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "CaptivePortalTimer" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "CaptivePortalTimerBackOffIncrementsInSeconds" /t REG_DWORD /d "5" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "CaptivePortalTimerMaxInSeconds" /t REG_DWORD /d "30" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "EnableActiveProbing" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "PassivePollPeriod" /t REG_DWORD /d "120" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "StaleThreshold" /t REG_DWORD /d "30" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "WebTimeout" /t REG_DWORD /d "35" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 25.%clr%[36m Îòêëþ÷èòü îäíîðàíãîâóþ ñåòü.%clr%[92m
@echo Îòêëþ÷èòü îäíîðàíãîâóþ ñåòü. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Peernet" /v "Disabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 26.%clr%[36m Îòêëþ÷èòü ëèìèòíîå ïîäêëþ÷åíèå è èñïîëüçîâàíèå äàííûõ ñåòè.%clr%[92m
@echo Îòêëþ÷èòü ëèìèòíîå ïîäêëþ÷åíèå è èñïîëüçîâàíèå äàííûõ ñåòè. 1>> %logfile%
set timerStart=!time!
call :acl_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost"
call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost /v 3G /t REG_DWORD /d 1 /f
call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost /v 4G /t REG_DWORD /d 1 /f
call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost /v Default /t REG_DWORD /d 1 /f
call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost /v Ethernet /t REG_DWORD /d 1 /f
call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost /v WiFi /t REG_DWORD /d 1 /f
%PS% "Get-ChildItem 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DusmSvc\Profiles\*\*' | Set-ItemProperty -Name UserCost -Value 0" 1>> %logfile% 2>>&1
call :disable_svc DusmSvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 27.%clr%[36m Èñïðàâèòü íàñòðîéêè äëÿ VPN êàíàëà.%clr%[92m
@echo Èñïðàâèòü íàñòðîéêè äëÿ VPN êàíàëà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent" /v "AssumeUDPEncapsulationContextOnSendRule" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\RasMan\Parameters" /v "DisableIKENameEkuCheck" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\RasMan\Parameters" /v "NegotiateDH2048_AES256" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 28.%clr%[36m Îòêëþ÷èòü ïðèâÿçêó QoS.%clr%[92m
@echo Îòêëþ÷èòü ïðèâÿçêó QoS. 1>> %logfile%
set timerStart=!time!
%~dp0nvspbind_%arch%.exe /d * ms_pacer 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 29.%clr%[36m Îòêëþ÷èòü èñïîëüçîâàíèå ïàêåòîâ QoS.%clr%[92m
@echo Îòêëþ÷èòü èñïîëüçîâàíèå ïàêåòîâ QoS. 1>> %logfile%
set timerStart=!time!
%PS% "Disable-NetAdapterQos -Name *" 1>> %logfile% 2>>&1
call :disable_svc Psched
call :disable_svc QWAVEdrv
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 30.%clr%[36m Âêëþ÷èòü ìàðêèðîâêó DSCP ïàêåòîâ QoS.%clr%[92m
@echo Âêëþ÷èòü ìàðêèðîâêó DSCP ïàêåòîâ QoS. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS" /v "Application DSCP Marking Request" /t REG_SZ /d "Allowed" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 31.%clr%[36m Âêëþ÷èòü àâòîòþíèíã TCP.%clr%[92m
@echo Âêëþ÷èòü àâòîòþíèíã TCP. 1>> %logfile%
set timerStart=!time!
netsh winsock set autotuning on 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 32.%clr%[36m Îòêëþ÷èòü çàõâàò NDIS.%clr%[92m
@echo Îòêëþ÷èòü çàõâàò NDIS. 1>> %logfile%
set timerStart=!time!
%~dp0nvspbind_%arch%.exe /d * ms_ndiscap 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 33.%clr%[36m Îòêëþ÷èòü ïðîòîêîë îáíàðóæåíèÿ ëîêàëüíûõ êàíàëîâ (LLDP).%clr%[92m
@echo Îòêëþ÷èòü ïðîòîêîë îáíàðóæåíèÿ ëîêàëüíûõ êàíàëîâ (LLDP). 1>> %logfile%
set timerStart=!time!
%~dp0nvspbind_%arch%.exe /d * ms_lldp 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 34.%clr%[36m Îòêëþ÷èòü îáíàðóæåíèå òîïîëîãèè ëîêàëüíîãî êàíàëà (LLTD).%clr%[92m
@echo Îòêëþ÷èòü îáíàðóæåíèå òîïîëîãèè ëîêàëüíîãî êàíàëà (LLTD). 1>> %logfile%
set timerStart=!time!
%~dp0nvspbind_%arch%.exe /d * ms_lltdio 1>> %logfile% 2>>&1
%~dp0nvspbind_%arch%.exe /d * ms_rspndr 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 35.%clr%[36m Îòêëþ÷èòü ñåòåâîé ñòåê IPv6.%clr%[92m
@echo Îòêëþ÷èòü ñåòåâîé ñòåê IPv6. 1>> %logfile%
set timerStart=!time!
%~dp0nvspbind_%arch%.exe /d * ms_tcpip6 1>> %logfile% 2>>&1
call :disable_svc Tcpip6
call :disable_svc wanarpv6
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 36.%clr%[36m Îòêëþ÷èòü ìåõàíèçì, ïîçâîëÿþùèé ïåðåäàâàòü IPv6-ïàêåòû ÷åðåç IPv4-ñåòè.%clr%[92m
@echo Îòêëþ÷èòü ìåõàíèçì, ïîçâîëÿþùèé ïåðåäàâàòü IPv6-ïàêåòû ÷åðåç IPv4-ñåòè. 1>> %logfile%
set timerStart=!time!
%PS% "Set-Net6to4Configuration -State Disabled -AutoSharing Disabled -RelayState Disabled -RelayName '6to4.ipv6.microsoft.com'" 1>> %logfile% 2>>&1
netsh int 6to4 set state state=disabled undoonstop=disabled 1>> %logfile% 2>>&1
netsh int 6to4 set routing routing=disabled sitelocals=disabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 37.%clr%[36m Îòêëþ÷èòü Teredo è ïðîòîêîë 6to4.%clr%[92m
@echo Îòêëþ÷èòü Teredo è ïðîòîêîë 6to4. 1>> %logfile%
set timerStart=!time!
netsh int ipv6 delete route ::/0 Teredo 1>> %logfile% 2>>&1
netsh int ipv6 isatap set state disabled 1>> %logfile% 2>>&1
netsh int teredo set state disabled 1>> %logfile% 2>>&1
netsh int ipv6 6to4 set state state=disabled undoonstop=disabled 1>> %logfile% 2>>&1
call :disable_svc iphlpsvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 38.%clr%[36m Âêëþ÷èòü ýêñïåðèìåíòàëüíóþ àâòîíàñòðîéêó è ïðîâàéäåð ïåðåãðóçêè CTCP (äëÿ ñòàáèëüíûõ ñåòåé ðåêîìåíäóåòñÿ âûñòàâèòü cubic).%clr%[92m
@echo Âêëþ÷èòü ýêñïåðèìåíòàëüíóþ àâòîíàñòðîéêó è ïðîâàéäåð ïåðåãðóçêè CTCP (äëÿ ñòàáèëüíûõ ñåòåé ðåêîìåíäóåòñÿ âûñòàâèòü cubic). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\QoS" /v "Tcp Autotuning Level" /t REG_SZ /d "Experimental" /f 1>> %logfile% 2>>&1
netsh int tcp set global autotuning=experimental 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\26" /v "00000000" /t REG_BINARY /d "0000000000000000000000000500000000000000000000000000000000000000ff00000000000000" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\26" /v "04000000" /t REG_BINARY /d "0000000000000000000000000500000000000000000000000000000000000000ff00000000000000" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 39.%clr%[36m Íàñòðîèòü ìåäëåííûé ñòàðò TCP äëÿ îòïðàâêè 10 êàäðîâ.%clr%[92m
@echo Íàñòðîèòü ìåäëåííûé ñòàðò TCP äëÿ îòïðàâêè 10 êàäðîâ. 1>> %logfile%
set timerStart=!time!
%PS% "Set-NetTCPSetting -SettingName Internet -InitialCongestionWindow 10" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 39.%clr%[36m Îòêëþ÷èòü ðàçãðóçêó TCP Chimney.%clr%[92m
@echo Îòêëþ÷èòü ðàçãðóçêó TCP Chimney. 1>> %logfile%
set timerStart=!time!
%PS% "Set-NetOffloadGlobalSetting -Chimney Disabled" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 40.%clr%[36m Îòêëþ÷èòü îáúåäèíåíèå ïàêåòîâ. Ïîëåçíî äëÿ èãð è Wi-Fi.%clr%[92m
@echo Îòêëþ÷èòü îáúåäèíåíèå ïàêåòîâ. Ïîëåçíî äëÿ èãð è Wi-Fi. 1>> %logfile%
set timerStart=!time!
%PS% "Set-NetOffloadGlobalSetting -PacketCoalescingFilter disabled" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 41.%clr%[36m Îòêëþ÷èòü îáúåäèíåíèå ñåãìåíòîâ ïðèåìà.%clr%[92m
@echo Îòêëþ÷èòü îáúåäèíåíèå ñåãìåíòîâ ïðèåìà. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global rsc=disabled 1>> %logfile% 2>>&1
%PS% "Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing disabled" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 42.%clr%[36m Íàñòðîéêà IP ïîëèòèê è âêëþ÷åíèå îòïðàâêè è ïîëó÷åíèÿ Weak Host.%clr%[92m
@echo Íàñòðîéêà IP ïîëèòèê è âêëþ÷åíèå îòïðàâêè è ïîëó÷åíèÿ Weak Host. 1>> %logfile%
set timerStart=!time!
%PS% "Set-NetIPInterface -AdvertiseDefaultRoute Disabled -EcnMarking Disabled -Forwarding Disabled -RetransmitTimeMs 0 -WeakHostReceive Enabled -WeakHostSend Enabled" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 43.%clr%[36m Âêëþ÷èòü ÿâíîå óâåäîìëåíèå î ïåðåãðóçêå.%clr%[92m
@echo Âêëþ÷èòü ÿâíîå óâåäîìëåíèå î ïåðåãðóçêå. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global ecncapability=enabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 44.%clr%[36m Âêëþ÷èòü îòìåòêó âðåìåíè RFC.%clr%[92m
@echo Âêëþ÷èòü îòìåòêó âðåìåíè RFC. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global timestamps=disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 45.%clr%[36m Âûñòàâèòü RTO â 2.5 ñåêóíäû.%clr%[92m
@echo Âûñòàâèòü RTO â 2.5 ñåêóíäû. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global initialRto=2500 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 46.%clr%[36m Âûñòàâèòü ìèíèìàëüíîå RTO.%clr%[92m
@echo Âûñòàâèòü ìèíèìàëüíîå RTO. 1>> %logfile%
set timerStart=!time!
%PS% "Set-NetTCPSetting -SettingName InternetCustom -MinRto 300" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 47.%clr%[36m Âêëþ÷èòü Fastopen.%clr%[92m
@echo Âêëþ÷èòü Fastopen. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global fastopen=enable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 48.%clr%[36m Îòêëþ÷èòü HyStart.%clr%[92m
@echo Îòêëþ÷èòü HyStart. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global hystart=disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 49.%clr%[36m Îòêëþ÷èòü TCP Pacing.%clr%[92m
@echo Îòêëþ÷èòü TCP Pacing. 1>> %logfile%
set timerStart=!time!
netsh int tcp set global pacingprofile=off 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 50.%clr%[36m Âûñòàâèòü ìèíèìàëüíîå MTU íà 576.%clr%[92m
@echo Âûñòàâèòü ìèíèìàëüíîå MTU íà 576. 1>> %logfile%
set timerStart=!time!
netsh int ip set global minmtu=576 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 51.%clr%[36m Îòêëþ÷èòü ìåòêó IP-ïîòîêà.%clr%[92m
@echo Îòêëþ÷èòü ìåòêó IP-ïîòîêà. 1>> %logfile%
set timerStart=!time!
netsh int ip set global flowlabel=disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 52.%clr%[36m Îòêëþ÷èòü ïåðåçàïóñê îêíà TCP.%clr%[92m
@echo Îòêëþ÷èòü ïåðåçàïóñê îêíà TCP. 1>> %logfile%
set timerStart=!time!
netsh int tcp set supplemental InternetCustom enablecwndrestart=disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 53.%clr%[36m Îòêëþ÷èòü ïåðåíàïðàâëåíèÿ ICMP.%clr%[92m
@echo Îòêëþ÷èòü ïåðåíàïðàâëåíèÿ ICMP. 1>> %logfile%
set timerStart=!time!
netsh int ip set global icmpredirects=disabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 54.%clr%[36m Îòêëþ÷èòü ìíîãîàäðåñíóþ ïåðåñûëêó.%clr%[92m
@echo Îòêëþ÷èòü ìíîãîàäðåñíóþ ïåðåñûëêó. 1>> %logfile%
set timerStart=!time!
netsh int ip set global multicastforwarding=disabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 55.%clr%[36m Îòêëþ÷èòü ãðóïïîâûå ïåðåíàïðàâëåííûå ôðàãìåíòû.%clr%[92m
@echo Îòêëþ÷èòü ãðóïïîâûå ïåðåíàïðàâëåííûå ôðàãìåíòû. 1>> %logfile%
set timerStart=!time!
netsh int ip set global groupforwardedfragments=disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 56.%clr%[36m Îòêëþ÷èòü ðàçäóâàíèå TCP.%clr%[92m
@echo Îòêëþ÷èòü ðàçäóâàíèå TCP. 1>> %logfile%
set timerStart=!time!
netsh int tcp set security mpp=disabled profiles=disabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 57.%clr%[36m Îòêëþ÷èòü ýâðèñòèêó TCP.%clr%[92m
@echo Îòêëþ÷èòü ýâðèñòèêó TCP. 1>> %logfile%
set timerStart=!time!
netsh int tcp set heur forcews=disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 58.%clr%[36m Îòêëþ÷èòü óïðàâëåíèå ïèòàíèåì ñåòåâîãî àäàïòåðà.%clr%[92m
@echo Îòêëþ÷èòü óïðàâëåíèå ïèòàíèåì ñåòåâîãî àäàïòåðà. 1>> %logfile%
set timerStart=!time!
%PS% "Disable-NetAdapterPowerManagement -Name *" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 59.%clr%[36m Âêëþ÷èòü ðàçãðóçêó êîíòðîëüíîé ñóììû.%clr%[92m
@echo Âêëþ÷èòü ðàçãðóçêó êîíòðîëüíîé ñóììû. 1>> %logfile%
set timerStart=!time!
%PS% "Enable-NetAdapterChecksumOffload -Name *" 1>> %logfile% 2>>&1
%PS% "Set-NetAdapterAdvancedProperty (Get-NetAdapter | where status -eq 'Up' | select -ExpandProperty name) -DisplayName 'IPv4 Checksum Offload' -DisplayValue 'Disabled' –NoRestart" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 60.%clr%[36m Îòêëþ÷èòü ðàçãðóçêó çàäà÷è èíêàïñóëèðîâàííîãî ïàêåòà.%clr%[92m
@echo Îòêëþ÷èòü ðàçãðóçêó çàäà÷è èíêàïñóëèðîâàííîãî ïàêåòà. 1>> %logfile%
set timerStart=!time!
%PS% "Disable-NetAdapterEncapsulatedPacketTaskOffload -Name *" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 61.%clr%[36m Âêëþ÷èòü ðàçãðóçêó IPsec.%clr%[92m
@echo Âêëþ÷èòü ðàçãðóçêó IPsec. 1>> %logfile%
set timerStart=!time!
%PS% "Enable-NetAdapterIPsecOffload -Name *" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile% 2>>&1
@echo %clr%[91m 62.%clr%[36m Îòêëþ÷èòü ðàçãðóçêó áîëüøîé îòïðàâêè.%clr%[92m
@echo Îòêëþ÷èòü ðàçãðóçêó áîëüøîé îòïðàâêè. 1>> %logfile%
set timerStart=!time!
%PS% "Disable-NetAdapterLso -Name *" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 63.%clr%[36m Âêëþ÷èòü PacketDirect äëÿ ñíèæåíèÿ äæèòòåðà.%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m íà âèðòóàëüíûõ ìàøèíàõ netvsc.sys âûçûâàåò BSOD.
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå PacketDirect äëÿ ñíèæåíèÿ äæèòòåðà. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷èòü PacketDirect äëÿ ñíèæåíèÿ äæèòòåðà. Ïðåäóïðåæäåíèå: íà âèðòóàëüíûõ ìàøèíàõ netvsc.sys âûçûâàåò BSOD. 1>> %logfile%
	set timerStart=!time!
	%PS% "Enable-NetAdapterPacketDirect -Name *" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[91m 64.%clr%[36m Îòêëþ÷èòü îáúåäèíåíèå ñåãìåíòîâ ïðèåìà.%clr%[92m
@echo Îòêëþ÷èòü îáúåäèíåíèå ñåãìåíòîâ ïðèåìà. 1>> %logfile%
set timerStart=!time!
%PS% "Disable-NetAdapterRsc -Name *" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 65.%clr%[36m Âêëþ÷èòü ìàñøòàáèðîâàíèå ñåãìåíòîâ ïðèåìà.%clr%[92m
@echo Âêëþ÷èòü ìàñøòàáèðîâàíèå ñåãìåíòîâ ïðèåìà. 1>> %logfile%
set timerStart=!time!
%PS% "Enable-NetAdapterRss -Name *" 1>> %logfile% 2>>&1
netsh interface tcp set heuristics wsh=enabled 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 66.%clr%[36m Âûïîëíèòü îïòèìèçàöèþ èíòåðíåò áðàóçåðîâ.%clr%[92m
@echo Âûïîëíèòü îïòèìèçàöèþ èíòåðíåò áðàóçåðîâ. 1>> %logfile%
set timerStart=!time!
call :browsers
if /i %browsersFound%==1 (
	echo %clr%[91mÏðîãðàììà îïòèìèçàöèè îáíàðóæèëà íàëè÷èå â ñèñòåìå çàïóùåííîãî ýêçåìïëÿðà áðàóçåðà.%clr%[92m
	echo %clr%[91m×òîáû ïðîäîëæèòü, âû äîëæíû çàêðûòü ñâîé áðàóçåð è ïîäòâåðäèòü ïðèìåíåíèå íàñòðîåê.%clr%[92m
	echo.
	choice /c yn /n /t %autoChoose% /d y /m %keySelY%
	if !errorlevel!==1 (
		call :kill "chrome.exe"
		call :kill "firefox.exe"
		call :kill "opera.exe"
		call :kill "msedge.exe"
		call :kill "vivaldi.exe"
		call :kill "thunderbird.exe"
		rem start "" rundll32.exe InetCpl.cpl,ClearMyTracksByProcess 4351 (î÷èñòêà èñòîðèè è êýøà ïàðîëåé áðàóçåðà)
		regsvr32 /s actxprxy 1>> %logfile% 2>>&1
		call :disable_task "\Microsoft\Windows\Wininet\CacheTask"
		%allrf% "%LocalAppdata%\Microsoft\Windows\WebCache\*" 1>> %logfile% 2>>&1
		for /d %%i in (%LocalAppdata%\Microsoft\Windows\WebCache\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
		%allrf% "%LocalAppData%\Microsoft\Windows\History\*" 1>> %logfile% 2>>&1
		for /d %%i in (%LocalAppdata%\Microsoft\Windows\History\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
		%allrf% "%LocalAppData%\Microsoft\Windows\INetCache\*" 1>> %logfile% 2>>&1
		for /d %%i in (%LocalAppdata%\Microsoft\Windows\INetCache\*.*) do @rd /s /q "%%i" 1>> %logfile% 2>>&1
		%SystemRoot%\system32\cmd.exe /c "%~dp0\..\Tools\speedyfox.exe "/Firefox:all" "/Chrome:all" "/Chromium:all" "/Microsoft Edge:all" "/Skype:all" "/Thunderbird:all" "/Opera:all" "/Vivaldi:all" "/Yandex Browser:all" "/Epic Privacy Browser:all" "/Cyberfox:all" "/FossaMail:all" "/Viber ^for Windows:all" "/Slimjet Browser:all" "/Pale Moon:all" "/SeaMonkey:all"" 1>> %logfile% 2>>&1
		set browsersFound=0
		)
	)
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v "explorer.exe" /t REG_DWORD /d "8" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v "iexplore.exe" /t REG_DWORD /d "8" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v "explorer.exe" /t REG_DWORD /d "8" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPERSERVER" /v "iexplore.exe" /t REG_DWORD /d "8" /f 1>> %logfile% 2>>&1
)
%rga% "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "DNSPreresolution" /t REG_DWORD /d "8" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Use_Async_DNS" /t REG_SZ /d "yes" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "EnablePreBinding" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Internet Explorer\Safety\PrivacIE" /v "DisableInPrivateBlocking" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Internet Explorer\Safety\PrivacIE" /v "StartMode" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "DnsCacheEnabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "DnsCacheEntries" /t REG_DWORD /d "200" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "DnsCacheTimeout" /t REG_DWORD /d "15180" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer" /v "AllowServicePoweredQSA" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\ContinuousBrowsing" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\DomainSuggestion" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Geolocation" /v "PolicyDisableGeolocation" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Geolocation" /v "PolicyDisableGeolocation" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "AutoSearch" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "DEPOff" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "DoNotTrack" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "Isolation64Bit" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\WindowsSearch" /v "EnabledScopes" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\PrefetchPrerender" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Restrictions" /v "NoCrashDetection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Safety\PrivacIE" /v "DisableLogging" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Safety\PrivacIE" /v "DisableLogging" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\SearchScopes" /v "TopResult" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "EnableHTTP2" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "CallLegacyWCMPolicies" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "EnableSSL3Fallback" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "PreventIgnoreCertErrors" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext" /v "DisableAddonLoadTimePerformanceNotifications" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Ext" /v "NoFirsttimeprompt" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\firefox.exe" /v "UseLargePages" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\chrome.exe" /v "UseLargePages" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Íàñòðîéêà óâåäîìëåíèé %clr%[0m
@echo Íàñòðîéêà óâåäîìëåíèé 1>> %logfile%
echo ••••••••••••
echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1. %clr%[36m Îòêëþ÷èòü óâåäîìëåíèÿ Öåíòðà äåéñòâèé.%clr%[92m
@echo Îòêëþ÷èòü óâåäîìëåíèÿ Öåíòðà äåéñòâèé. 1>> %logfile%
set timerStart=!time!
rem %rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
rem %rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotification" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotificationOnLockScreen" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.BioEnrollment_cw5n1h2txyewy!App" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.LockApp_cw5n1h2txyewy!WindowsDefaultLockScreen" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe!App" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy!App" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.Cortana_cw5n1h2txyewy!CortanaUI" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.Cortana_cw5n1h2txyewy!RemindersShareTargetApp" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.LanguageComponentsInstaller" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.NarratorQuickStart_8wekyb3d8bbwe!App" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.ParentalControls" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.ParentalControls_cw5n1h2txyewy!App" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.PeopleExperienceHost_cw5n1h2txyewy!App" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.Defender.SecurityCenter" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.AutoPlay" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Calling" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Calling.SystemAlertNotification" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.Compat" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.FodHelper" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.HelloFace" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.LocationManager" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.MobilityExperience" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityCenter" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.WindowsTip" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.WindowsUpdate.Notification" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2. %clr%[36m Îòêëþ÷èòü óâåäîìëåíèÿ ïîñòàâùèêà ñèíõðîíèçàöèè.%clr%[92m
@echo Îòêëþ÷èòü óâåäîìëåíèÿ ïîñòàâùèêà ñèíõðîíèçàöèè. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3. %clr%[36m Îòêëþ÷èòü çíà÷îê è óâåäîìëåíèÿ Öåíòðà ïîääåðæêè.%clr%[92m
@echo Îòêëþ÷èòü çíà÷îê è óâåäîìëåíèÿ Öåíòðà ïîääåðæêè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "UseActionCenterExperience" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAHealth" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4. %clr%[36m Îòêëþ÷èòü óâåäîìëåíèÿ ñëóæáû ïîääåðæêè.%clr%[92m
@echo Îòêëþ÷èòü óâåäîìëåíèÿ ñëóæáû ïîääåðæêè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Gwx" /v "DisableGwx" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5. %clr%[36m Îòêëþ÷èòü óâåäîìëåíèÿ ôîêóñèðîâêè âíèìàíèÿ.%clr%[92m
@echo Îòêëþ÷èòü óâåäîìëåíèÿ ôîêóñèðîâêè âíèìàíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\QuietHours" /v "Enabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\QuietHours" /v "AllowCalls" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Notifications\Data" /v "0D83063EA3BF1C75" /t REG_BINARY /d "3F00000000000000" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 6. %clr%[36m Îòêëþ÷èòü óâåäîìëåíèÿ Windows Defender, ôàéåðâîëà è Öåíòðà îáíîâëåíèé.%clr%[92m
@echo Îòêëþ÷èòü óâåäîìëåíèÿ Windows Defender, ôàéåðâîëà è Öåíòðà îáíîâëåíèé. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Security Center" /v "AntiVirusDisableNotify" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
call :acl_registry "HKLM\SOFTWARE\Microsoft\Security Center\Svc"
call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Security Center\Svc /v AntiVirusOverride /t REG_DWORD /d 1 /f
%rga% "HKLM\SOFTWARE\Microsoft\Security Center" /v "FirewallDisableNotify" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Security Center\Svc /v FirewallOverride /t REG_DWORD /d 1 /f
%rga% "HKLM\SOFTWARE\Microsoft\Security Center" /v "AntiSpywareDisableNotify" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
call :trusted_app %rga% HKLM\SOFTWARE\Microsoft\Security Center\Svc /v AntiSpywareOverride /t REG_DWORD /d 1 /f
%rga% "HKLM\SOFTWARE\Microsoft\Security Center" /v "UpdatesDisableNotify" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 7. %clr%[36m Îòêëþ÷èòü èñòîðèþ óâåäîìëåíèé.%clr%[92m
@echo Îòêëþ÷èòü èñòîðèþ óâåäîìëåíèé. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ClearTilesOnExit" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Íàñòðîéêà îáíîâëåíèÿ Windows%clr%[0m
@echo Íàñòðîéêà îáíîâëåíèÿ Windows 1>> %logfile%
echo ••••••••••••
echo •••••••••••• 1>> %logfile%
@echo %clr%[91m 1. %clr%[36m Îòêëþ÷èòü îáíîâëåíèå äðàéâåðîâ ÷åðåç Öåíòð îáíîâëåíèé Windows.%clr%[92m
@echo Îòêëþ÷èòü îáíîâëåíèå äðàéâåðîâ ÷åðåç Öåíòð îáíîâëåíèé Windows. 1>> %logfile%
set timerStart=!time!
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v "AllSigningEqual" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DriverUpdateWizardWuSearchEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontSearchWindowsUpdate" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v "DisableSendRequestAdditionalSoftwareToWER" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" /v "Value" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
net stop wuauserv 1>> %logfile% 2>>&1
net stop bits 1>> %logfile% 2>>&1
%allrf% "%SystemRoot%\SoftwareDistribution\*" 1>> %logfile% 2>>&1
net start bits 1>> %logfile% 2>>&1
net start wuauserv 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü àâòîìàòè÷åñêîå îáíîâëåíèå äðàéâåðîâ (òðåáóåòñÿ äëÿ óñòàíîâêè ñïåöèôè÷íûõ èëè óñòàðåâøèõ äðàéâåðîâ äëÿ óñòðîéñòâ).%clr%[92m
@echo Îòêëþ÷èòü àâòîìàòè÷åñêîå îáíîâëåíèå äðàéâåðîâ (òðåáóåòñÿ äëÿ óñòàíîâêè ñïåöèôè÷íûõ èëè óñòàðåâøèõ äðàéâåðîâ äëÿ óñòðîéñòâ). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions" /v "DenyDeviceIDs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions" /v "DenyDeviceIDsRetroactive" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 2. %clr%[36m Ðàçðåøèòü ïîëó÷åíèå îáíîâëåíèé äëÿ äðóãèõ ïðîäóêòîâ Microsoft ÷åðåç Öåíòð îáíîâëåíèÿ Windows.%clr%[92m
@echo Ðàçðåøèòü ïîëó÷åíèå îáíîâëåíèé äëÿ äðóãèõ ïðîäóêòîâ Microsoft ÷åðåç Öåíòð îáíîâëåíèÿ Windows. 1>> %logfile%
set timerStart=!time!
%PS% "(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2('7971f918-a847-4430-9279-4a52d1efe18d', 7, '')" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 3. %clr%[36m Îòêëþ÷èòü àâòîìàòè÷åñêóþ çàãðóçêó ñ Öåíòðà îáíîâëåíèÿ Windows.%clr%[92m
@echo Îòêëþ÷èòü àâòîìàòè÷åñêóþ çàãðóçêó ñ Öåíòðà îáíîâëåíèÿ Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 4. %clr%[36m Îòêëþ÷èòü àâòîìàòè÷åñêóþ çàãðóçêó îáíîâëåíèé ïðèëîæåíèé èç Ìàãàçèíà.%clr%[92m
@echo Îòêëþ÷èòü àâòîìàòè÷åñêóþ çàãðóçêó îáíîâëåíèé ïðèëîæåíèé èç Ìàãàçèíà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore\WindowsUpdate" /v "AutoDownload" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
rem %rga% "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 5. %clr%[36m Îòêëþ÷èòü àâòîìàòè÷åñêîå îáíîâëåíèå êàðò.%clr%[92m
@echo Îòêëþ÷èòü àâòîìàòè÷åñêîå îáíîâëåíèå êàðò. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\Maps" /v "AutoUpdateEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
rem Äèñïåò÷åð çàãðóçêè êàðò âëèÿåò íà ðàáîòó ïðèëîæåíèè ñ êàðòàìè.
call :delayed_svc MapsBroker
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 6. %clr%[36m Îòêëþ÷èòü àâòîìàòè÷åñêóþ ïåðåçàãðóçêó è óâåäîìëåíèå ïîñëå çàâåðøåíèÿ îáíîâëåíèÿ.%clr%[92m
@echo Îòêëþ÷èòü àâòîìàòè÷åñêóþ ïåðåçàãðóçêó è óâåäîìëåíèå ïîñëå çàâåðøåíèÿ îáíîâëåíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "RestartNotificationsAllowed2" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MusNotification.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 7. %clr%[36m Îòêëþ÷èòü íî÷íîå ïðîáóæäåíèå äëÿ àâòîìàòè÷åñêîãî îáñëóæèâàíèÿ è îáíîâëåíèé Windows.%clr%[92m
@echo Îòêëþ÷èòü íî÷íîå ïðîáóæäåíèå äëÿ àâòîìàòè÷åñêîãî îáñëóæèâàíèÿ è îáíîâëåíèé Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUPowerManagement" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "WakeUp" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[91m 8. %clr%[36m Îòêëþ÷èòü àâòîìàòè÷åñêèé ïåðåçàïóñê ïîñëå âõîäà â ñèñòåìó ïðè óñòàíîâêå îáíîâëåíèé.%clr%[92m
@echo Îòêëþ÷èòü àâòîìàòè÷åñêèé ïåðåçàïóñê ïîñëå âõîäà â ñèñòåìó ïðè óñòàíîâêå îáíîâëåíèé. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
echo.%clr%[7m%clr%[0m
@echo %clr%[7m Ðàçíîå %clr%[0m
@echo Ðàçíîå 1>> %logfile%
echo ••••••••••••
@echo •••••••••••• 1>> %logfile%
@echo %clr%[36m Ïðèìåíåíèå ïàðàìåòðîâ äëÿ îòêëþ÷åíèÿ âûñîêèõ çàäåðæåê DPC/ISR.%clr%[92m
@echo Ïðèìåíåíèå ïàðàìåòðîâ äëÿ îòêëþ÷åíèÿ âûñîêèõ çàäåðæåê DPC/ISR. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "ExitLatencyCheckEnabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "Latency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "RtlCapabilityCheckLatency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchedMode" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrLevel" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "UseGpuTimer" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PowerSavingTweaks" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "EnableRuntimePowerManagement" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PrimaryPushBufferSize" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "FlTransitionLatency" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "D3PCLatency" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RMDeepLlEntryLatencyUsec" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "PciLatencyTimerControl" /t REG_DWORD /d "32" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "LOWLATENCY" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RmDisableRegistryCaching" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "RMDisablePostL2Compression" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "UseGpuTimer" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RmGpsPsEnablePerCpuCoreDpc" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "PowerSavingTweaks" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DisableWriteCombining" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "EnableRuntimePowerManagement" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "PrimaryPushBufferSize" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "FlTransitionLatency" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "D3PCLatency" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RMDeepLlEntryLatencyUsec" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "PciLatencyTimerControl" /t REG_DWORD /d "32" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "LOWLATENCY" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RmDisableRegistryCaching" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "RMDisablePostL2Compression" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyActivelyUsed" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleLongTime" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleMonitorOff" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleNoContext" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleShortTime" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultD3TransitionLatencyIdleVeryLongTime" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle0MonitorOff" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceIdle1MonitorOff" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceMemory" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContext" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceNoContextMonitorOff" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceOther" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultLatencyToleranceTimerPeriod" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceActivelyUsed" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceMonitorOff" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "DefaultMemoryRefreshLatencyToleranceNoContext" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "Latency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MaxIAverageGraphicsLatencyInOneBucket" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MiracastPerfTrackGraphicsLatency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorLatencyTolerance" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "MonitorRefreshLatencyTolerance" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Power" /v "TransitionLatency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "D3PCLatency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "F1TransitionLatency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "LOWLATENCY" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "Node3DLowLatency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PciLatencyTimerControl" /t REG_DWORD /d "20" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMDeepL1EntryLatencyUsec" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMaxFtuS" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcMinFtuS" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RmGspcPerioduS" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrEiIdleThresholdUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrIdleThresholdUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrGrRgIdleThresholdUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "RMLpwrMsIdleThresholdUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipDPCDelayUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectFlipTimingMarginUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "VRDirectJITFlipMsHybridFlipDelayUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrCursorMarginUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMarginUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "vrrDeflickerMaxUs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Ïðèíóäèòåëüíîå îòêëþ÷åíèå ëîããèðîâàíèÿ.%clr%[92m
@echo Ïðèíóäèòåëüíîå îòêëþ÷åíèå ëîããèðîâàíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\AppModel" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Cellcore" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Circular Kernel Context Logger" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\CloudExperienceHostOobe" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DataMarket" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\DiagLog" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-RemoteDesktopServices-RemoteFX-SessionLicensing-Debug" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\HolographicDevice" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\iclsClient" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\iclsProxy" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\LwtNetLog" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Mellanox-Kernel" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-AssignedAccess-Trace" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-Rdp-Graphics-RdpIdd-Trace" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Microsoft-Windows-Setup" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\NBSMBLOGGER" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\PEAuthLog" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
call :trusted_app %rga% HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\RadioMgr /v Start /t REG_DWORD /d 0 /f
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\RdrLog" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\ReadyBoot" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SetupPlatform" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SetupPlatformTel" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SocketHeciServer" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SpoolerLogger" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\SQMLogger" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TCPIPLOGGER" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TileStore" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\Tpm" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\TPMProvisioningService" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\UBPM" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WdiContextLog" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WFP-IPsec Trace" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiDriverIHVSession" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiDriverIHVSessionRepro" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WiFiSession" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\WinPhoneCritical" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
rem %PS% "Get-AutologgerConfig | Set-AutologgerConfig -Start 0 -InitStatus 0 -Confirm:$False" 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogEnable" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WUDF" /v "LogLevel" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Credssp" /v "DebugLogLevel" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Ïðèìåíåíèå ïîëèòèêè äëÿ ðåñóðñîâ CPU.%clr%[92m
@echo Ïðèìåíåíèå ïîëèòèêè äëÿ ðåñóðñîâ CPU. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "CapPercentage" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\HardCap0" /v "SchedulingType" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "CapPercentage" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\Paused" /v "SchedulingType" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "CapPercentage" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFull" /v "SchedulingType" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFullAboveNormal" /v "CapPercentage" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFullAboveNormal" /v "PriorityClass" /t REG_DWORD /d "32" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapFullAboveNormal" /v "SchedulingType" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "CapPercentage" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLow" /v "SchedulingType" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLowBackgroundBegin" /v "CapPercentage" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLowBackgroundBegin" /v "PriorityClass" /t REG_DWORD /d "32" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\SoftCapLowBackgroundBegin" /v "SchedulingType" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\UnmanagedAboveNormal" /v "CapPercentage" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\UnmanagedAboveNormal" /v "PriorityClass" /t REG_DWORD /d "32" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\CPU\UnmanagedAboveNormal" /v "SchedulingType" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\BackgroundDefault" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Frozen" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNCS" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\FrozenPPLE" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Paused" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PausedDNK" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\Pausing" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\PrelaunchForeground" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Flags\ThrottleGPUInterference" /v "IsLowPriority" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Critical" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\CriticalNoUi" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\EmptyHostPPLE" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\High" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Low" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Lowest" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\Medium" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\MediumHigh" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\StartHost" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryHigh" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "BasePriority" /t REG_DWORD /d "130" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Importance\VeryLow" /v "OverTargetPriority" /t REG_DWORD /d "80" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\IO\NoCap" /v "IOBandwidth" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitLimit" /t REG_DWORD /d "4294967295" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\ResourcePolicyStore\ResourceSets\Policies\Memory\NoCap" /v "CommitTarget" /t REG_DWORD /d "4294967295" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Ïðèìåíåíèå ïàðàìåòðîâ äëÿ óñêîðåíèÿ ÎÑ è îïòèìèçàöèè 3D èãð.%clr%[92m
@echo Ïðèìåíåíèå ïàðàìåòðîâ äëÿ óñêîðåíèÿ ÎÑ è îïòèìèçàöèè 3D èãð. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "PassiveIntRealTimeWorkerPriority" /t REG_DWORD /d "24" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\KernelVelocity" /v "DisableFGBoostDecay" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoDataExecutionPrevention" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableCursorSuppression" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorMagnetism" /v "MagnetismUpdateIntervalInMilliseconds" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Input\Settings\ControllerProcessor\CursorSpeed" /v "CursorUpdateInterval" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Direct3D" /v "DisableVidMemVBs" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Direct3D" /v "MMX Fast Path" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\SOFTWARE\Microsoft\Direct3D" /v "DisableVidMemVBs" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\SOFTWARE\Microsoft\Direct3D" /v "MMX Fast Path" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\SOFTWARE\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Direct3D" /v "DisableVidMemVBs" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Direct3D" /v "MMX Fast Path" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\SOFTWARE\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "DisableVidMemVBs" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "MMX Fast Path" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D" /v "FlipNoVsync" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Direct3D\Drivers" /v "SoftwareOnly" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\WOW6432Node\Microsoft\DirectDraw" /v "EmulationOnly" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
)
%rga% "HKU\.DEFAULT\Microsoft\Windows\CurrentVersion\Internet Settings" /v "SyncMode5" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "SyncMode5" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /v "SyncMode5" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\OLE" /v "PageAllocatorUseSystemHeap" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\OLE" /v "PageAllocatorSystemHeapIsPrivate" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\OLE" /v "Tracing" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\GRE_Initialize" /v "DisableMetaFiles" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MaxDynamicTickDuration" /t REG_DWORD /d "500" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MaximumSharedReadyQueueSize" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "SerializeTimerExpiration" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableAutoBoost" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DistributeTimers" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "NonPagedPoolSize" /t REG_DWORD /d "192" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagedPoolSize" /t REG_DWORD /d "192" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PoolUsageMaximum" /t REG_DWORD /d "192" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\mouhid\Parameters" /v "UseOnlyMice" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\mouhid\Parameters" /v "TreatAbsolutePointerAsAbsolute" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\mouhid\Parameters" /v "TreatAbsoluteAsRelative" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "fid_D1Latency" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "fid_D2Latency" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\usbflags" /v "fid_D3Latency" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\pci\Parameters" /v "ASPMOptOut" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\Input\Buttons" /v "HardwareButtonsAsVKeys" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
call :disable_svc GraphicsPerfSvc
call :disable_svc GpuEnergyDrv
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "AlpcWakePolicy" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\xusb22\Parameters" /v "IoQueueWorkItem" /t REG_DWORD /d "10" /f 1>> %logfile% 2>>&1
call :auto_svc bam
call :auto_svc dam
rem call :disable_svc bam :: Àâòîîáíîâëåíèå ôàéëîâ íà ðàáî÷åì ñòîëå (Desktop Activity Moderator Driver)
rem call :disable_svc dam :: Àâòîîáíîâëåíèå ôàéëîâ íà ðàáî÷åì ñòîëå (Background Activity Moderator Driver)
call :disable_svc SystemUsageReportSvc_QUEENCREEK
call :disable_svc 'Intel(R) SUR QC SAM'
call :disable_svc kdnic
call :disable_svc LMS
call :disable_svc MEIx64
call :disable_svc MMCSS
call :disable_svc Beep
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\WmiPrvSE.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RuntimeBroker.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "16" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "16" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\explorer.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "16" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\explorer.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vmwp.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "16" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vmwp.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TiWorker.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\TiWorker.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vsserv.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\vsserv.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\downloader.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\downloader.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\testinitsigs.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\testinitsigs.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\fontdrvhost.exe" /v "MaxLoaderThreads" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Ïðèìåíåíèå îïòèìèçàöèè ñëóæáû ïëàíèðîâùèêà êëàññîâ Multimedia äëÿ èãð (MMCSS).%clr%[92m
@echo Ïðèìåíåíèå îïòèìèçàöèè ñëóæáû ïëàíèðîâùèêà êëàññîâ Multimedia äëÿ èãð (MMCSS). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "IdleDetectionCycles" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "AlwaysOn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d "10000" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "BackgroundPriority" /t REG_DWORD /d "8" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "8" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Ïðèìåíåíèå íàñòðîåê îïòèìèçàöèè äëÿ SSD äèñêîâ.%clr%[92m
@echo Ïðèìåíåíèå íàñòðîåê îïòèìèçàöèè äëÿ SSD äèñêîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port0" /v "LPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port0" /v "LPMDSTATE" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port0" /v "DIPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port1" /v "LPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port1" /v "LPMDSTATE" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port1" /v "DIPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port2" /v "LPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port2" /v "LPMDSTATE" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port2" /v "DIPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port3" /v "LPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port3" /v "LPMDSTATE" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port3" /v "DIPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port4" /v "LPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port4" /v "LPMDSTATE" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port4" /v "DIPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port5" /v "LPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port5" /v "LPMDSTATE" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\iaStor\Parameters\Port5" /v "DIPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\EnableBoottrace" /v "DIPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\I/O System" /v "CountOperations" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "DontVerifyRandomDrivers" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Ïðèìåíåíèå íàñòðîåê îïòèìèçàöèè ýëåêòðîïèòàíèÿ.%clr%[92m
@echo Ïðèìåíåíèå íàñòðîåê îïòèìèçàöèè ýëåêòðîïèòàíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "38" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "PerfCalculateActualUtilization" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "SleepReliabilityDetailedDiagnostics" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "QosManagesIdleProcessors" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableVsyncLatencyUpdate" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "DisableSensorWatchdog" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceDefault" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceFSVP" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceIdleResiliency" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyTolerancePerfOverride" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceScreenOffIR" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "LatencyToleranceVSyncEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}\{F6CC25DF-6E8F-4cf8-A242-B1343F565884}\{BDB3AF7A-F67E-4d1e-945D-E2790352BE0A}" /ve /t REG_SZ /d "{db57eb61-1aa2-4906-9396-23e8b8024c32}" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}\{F6CC25DF-6E8F-4cf8-A242-B1343F565884}\{BDB3AF7A-F67E-4d1e-945D-E2790352BE0A}" /v "Operator" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}\{F6CC25DF-6E8F-4cf8-A242-B1343F565884}\{BDB3AF7A-F67E-4d1e-945D-E2790352BE0A}" /v "Type" /t REG_DWORD /d "4157" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}\{F6CC25DF-6E8F-4cf8-A242-B1343F565884}\{BDB3AF7A-F67E-4d1e-945D-E2790352BE0A}" /v "Value" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}\{F6CC25DF-6E8F-4cf8-A242-B1343F565884}\{CD9230EE-218E-44b9-8AE5-EE7AA5DAD08F}" /ve /t REG_SZ /d "{db57eb61-1aa2-4906-9396-23e8b8024c32}" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}\{F6CC25DF-6E8F-4cf8-A242-B1343F565884}\{CD9230EE-218E-44b9-8AE5-EE7AA5DAD08F}" /v "Operator" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}\{F6CC25DF-6E8F-4cf8-A242-B1343F565884}\{CD9230EE-218E-44b9-8AE5-EE7AA5DAD08F}" /v "Type" /t REG_DWORD /d "4106" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\Profile\Events\{54533251-82be-4824-96c1-47b60b740d00}\{0DA965DC-8FCF-4c0b-8EFE-8DD5E7BC959A}\{7E01ADEF-81E6-4e1b-8075-56F373584694}\{F6CC25DF-6E8F-4cf8-A242-B1343F565884}\{CD9230EE-218E-44b9-8AE5-EE7AA5DAD08F}" /v "Value" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
powercfg -change -disk-timeout-ac 0 1>> %logfile% 2>>&1
powercfg -change -standby-timeout-ac 0 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Îòîáðàçèòü âñå ñêðûòûå ïóíêòû â ñõåìàõ óïðàâëåíèÿ ïèòàíèåì?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå îòîáðàæåíèÿ âñåõ ñêðûòûõ ïóíêòîâ â ñõåìàõ óïðàâëåíèÿ ïèòàíèåì. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Îòîáðàçèòü âñå ñêðûòûå ïóíêòû â ñõåìàõ óïðàâëåíèÿ ïèòàíèåì. 1>> %logfile%
	set timerStart=!time!
	for /f "tokens=* delims=" %%l in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings" /s /v "Attributes"^|FindStr HKEY_') do (%rga% "%%l" /v "Attributes" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1)
	@echo Îòîáðàæàòü ïîðîã ñíèæåíèÿ ïðîèçâîäèòåëüíîñòè ïðîöåññîðà. 1>> %logfile%
	powercfg -attributes SUB_PROCESSOR 12a0ab44-fe28-4fa9-b3bd-4b64f44960a6 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü ïîðîã óâåëè÷åíèÿ ïðîèçâîäèòåëüíîñòè ïðîöåññîðà. 1>> %logfile%
	powercfg -attributes SUB_PROCESSOR 06cadf0e-64ed-448a-8927-ce7bf90eb35d -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü ïîëèòèêó ðàçðåøåíèÿ ðåæèìà îòñóòñòâèÿ. 1>> %logfile%
	powercfg -attributes SUB_SLEEP 25DFA149-5DD1-4736-B5AB-E8A37B5B8187 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü ñîâìåñòíîå èñïîëüçîâàíèå ìóëüòèìåäèà. 1>> %logfile%
	powercfg -attributes 9596FB26-9850-41fd-AC3E-F7C3C00AFD4B 03680956-93BC-4294-BBA6-4E0F09BB717F -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü ðàçðåøåíèå ïîëèòèêè, òðåáóåìîé ñèñòåìîé. 1>> %logfile%
	powercfg -attributes SUB_SLEEP A4B195F5-8225-47D8-8012-9D41369786E2 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü ðàçðåøåíèå ñïÿùåãî ðåæèìà ïðè óäàëåííîì îòêðûòèè. 1>> %logfile%
	powercfg -attributes SUB_SLEEP d4c1d4c8-d5cc-43d3-b83e-fc51215cb04d -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü òàéìàóò àâòîìàòè÷åñêîãî ïåðåõîäà â ñïÿùèé ðåæèì. 1>> %logfile%
	powercfg -attributes SUB_SLEEP 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü óïðàâëåíèå ïèòàíèåì USB 3 Link. 1>> %logfile%
	powercfg -attributes 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü âðåìÿ âûáîðî÷íîé ïðèîñòàíîâêè USB-õàáà. 1>> %logfile%
	powercfg -attributes 2a737441-1930-4402-8d77-b2bebba308a3 0853a681-27c8-4100-a2fd-82013e970683 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü ðàçðåøåíèå îòîáðàæåíèÿ íåîáõîäèìîé ïîëèòèêè. 1>> %logfile%
	powercfg -attributes SUB_VIDEO A9CEB8DA-CD46-44FB-A98B-02AF69DE4623 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü äåéñòâèå ïðè çàêðûòèè êðûøêè. 1>> %logfile%
	powercfg -attributes SUB_BUTTONS 5ca83367-6e45-459f-a27b-476b1d01c936 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü äåéñòâèå ïðè îòêðûòèè êðûøêè. 1>> %logfile%
	powercfg -attributes SUB_BUTTONS 99ff10e7-23b1-4c07-a9d1-5c3206d741b4 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü óïðàâëåíèå ïèòàíèåì AHCI Link - Àäàïòèâíàÿ íàñòðîéêà. 1>> %logfile%
	powercfg -attributes SUB_DISK dab60367-53fe-4fbc-825e-521d069d2456 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü ïîðîã èãíîðèðîâàíèÿ âñïëåñêà àêòèâíîñòè äèñêà. 1>> %logfile%
	powercfg -attributes SUB_DISK 80e3c60e-bb94-4ad8-bbe0-0d3195efc663 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü óïðàâëåíèå ïèòàíèåì AHCI Link - HIPM/DIPM. 1>> %logfile%
	powercfg -attributes SUB_DISK 0b2d69d7-a2a1-449c-9680-f91c70521c60 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü ñìåùåíèå êà÷åñòâà âîñïðîèçâåäåíèÿ âèäåî. 1>> %logfile%
	powercfg -attributes 9596FB26-9850-41fd-AC3E-F7C3C00AFD4B 10778347-1370-4ee0-8bbd-33bdacaade49 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü Ïðè âîñïðîèçâåäåíèè âèäåî. 1>> %logfile%
	powercfg -attributes 9596FB26-9850-41fd-AC3E-F7C3C00AFD4B 34C7B99F-9A6D-4b3c-8DC7-B6693B78CEF4 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü íàñòðîéêè áåñïðîâîäíîãî àäàïòåðà. 1>> %logfile%
	powercfg -attributes 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü íàñòðîéêó ïîäêëþ÷åíèÿ ê ñåòè â ðåæèìå îæèäàíèÿ. 1>> %logfile%
	powercfg -attributes F15576E8-98B7-4186-B944-EAFA664402D9 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü àäàïòèâíóþ ïîäñâåòêó. 1>> %logfile%
	powercfg -attributes SUB_VIDEO aded5e82-b909-4619-9949-f5d71dac0bcc -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü òàéì-àóò áåçäåéñòâèÿ SEC NVMe. 1>> %logfile%
	powercfg -attributes SUB_DISK 6b013a00-f775-4d61-9036-a62f7e7a6a5b -ATTRIB_HIDE 1>> %logfile% 2>>&1
	@echo Îòîáðàæàòü íàñòðîéêó ÿðêîñòè çàòåìíåíèÿ ýêðàíà. 1>> %logfile%
	powercfg -attributes SUB_VIDEO f1fbfde2-a960-4165-9f88-50667911ce96 -ATTRIB_HIDE 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âûñòàâèòü ñáàëàíñèðîâàííóþ ñõåìó óïðàâëåíèÿ ïèòàíèåì.%clr%[92m
@echo Âûñòàâèòü ñáàëàíñèðîâàííóþ ñõåìó óïðàâëåíèÿ ïèòàíèåì. 1>> %logfile%
set timerStart=!time!
powercfg /setactive scheme_balanced 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Îòêëþ÷èòü Game DVR, ñëóæáû Xbox, Logitech Gaming è Razer Game Scanner.%clr%[92m
@echo Îòêëþ÷èòü Game DVR, ñëóæáû Xbox, Logitech Gaming è Razer Game Scanner. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AudioCaptureEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "CursorCaptureEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
)
%rga% "HKCU\SOFTWARE\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v "value" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\System\GameConfigStore\Children" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\System\GameConfigStore\Parents" /f 1>> %logfile% 2>>&1
call :disable_svc xbgm
call :disable_svc XblAuthManager
call :disable_svc XblGameSave
call :disable_svc XboxGipSvc
call :disable_svc XboxNetApiSvc
call :disable_task "\Microsoft\XblGameSave\XblGameSaveTask"
call :disable_task "\Microsoft\XblGameSave\XblGameSaveTaskLogon"
call :kill "GameBarPresenceWriter.exe"
call :acl_file-folders "%SystemRoot%\System32\GameBarPresenceWriter.exe"
ren %SystemRoot%\System32\GameBarPresenceWriter.exe GameBarPresenceWriter.bkp 1>> %logfile% 2>>&1
call :kill "bcastdvr.exe"
call :acl_file-folders "%SystemRoot%\System32\bcastdvr.exe"
ren %SystemRoot%\System32\bcastdvr.exe bcastdvr.bkp 1>> %logfile% 2>>&1
call :disable_svc LogiRegistryService
call :disable_svc 'Razer Game Scanner Service'
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Îòêëþ÷èòü ïîëó÷åíèå èíôîðìàöèè îá èãðàõ è îïöèÿõ èç Èíòåðíåòà.%clr%[92m
@echo Îòêëþ÷èòü ïîëó÷åíèå èíôîðìàöèè îá èãðàõ è îïöèÿõ èç Èíòåðíåòà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameUX" /v "DownloadGameInfo" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameUX" /v "GameUpdateOptions" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü Windows Hello äëÿ áèçíåñà.%clr%[92m
@echo Îòêëþ÷èòü Windows Hello äëÿ áèçíåñà. 1>> %logfile%
set timerStart=!time!
certutil.exe -DeleteHelloContainer 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\PassportForWork" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control WMI\Autologger\EventLog-Application\{23b8d46b-67dd-40a3-b636-d43e50552c6d}" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Îòêëþ÷èòü ïåðñîíàëèçàöèþ ââîäà è ñîçäàíèå îò÷åòîâ.%clr%[92m
@echo Îòêëþ÷èòü ïåðñîíàëèçàöèþ ââîäà è ñîçäàíèå îò÷åòîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Îòêëþ÷èòü Wi-Fi Sense (äàííûé ôóíêöèîíàë ïîçâîëÿåò äåëèòüñÿ äîñòóïîì ê ñâîèì ñåòÿì Wi-Fi ñî ñâîèìè êîíòàêòàìè è àâòîìàòè÷åñêè ïîäêëþ÷àòüñÿ ê ñåòÿì äðóçåé).%clr%[92m
@echo Îòêëþ÷èòü Wi-Fi Sense (äàííûé ôóíêöèîíàë ïîçâîëÿåò äåëèòüñÿ äîñòóïîì ê ñâîèì ñåòÿì Wi-Fi ñî ñâîèìè êîíòàêòàìè è àâòîìàòè÷åñêè ïîäêëþ÷àòüñÿ ê ñåòÿì äðóçåé). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "Value" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "Value" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "WiFISenseAllowed" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager" /v "wifisensecredshared" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\wcmsvc\wifinetworkmanager" /v "wifisenseopen" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
for /f "tokens=* delims=" %%l in ('reg query "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features" /s ^|FindStr HKEY_') do (%rga% "%%l" /v "FeatureStates" /t REG_DWORD /d "828" /f 1>> %logfile% 2>>&1)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Îòêëþ÷èòü ñæàòèå ïàìÿòè è ïðåäçàãðóçêó ïðèëîæåíèé â ÎÑ.%clr%[92m
@echo Îòêëþ÷èòü ñæàòèå ïàìÿòè è ïðåäçàãðóçêó ïðèëîæåíèé â ÎÑ. 1>> %logfile%
set timerStart=!time!
%PS% "Disable-MMAgent -MemoryCompression -ApplicationPreLaunch" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Èñïîëüçîâàòü ïðèîðèòåò ðåàëüíîãî âðåìåíè äëÿ csrss.exe%clr%[92m
@echo Èñïîëüçîâàòü ïðèîðèòåò ðåàëüíîãî âðåìåíè äëÿ csrss.exe 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "4" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "KernelSEHOPEnabled" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñðåäñòâà çàùèòû ïðîöåññîâ è ÿäðà.%clr%[92m
@echo Îòêëþ÷èòü ñðåäñòâà çàùèòû ïðîöåññîâ è ÿäðà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "22222222222222222002000000200000" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "20000020202022220000000000000000" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%PS% "foreach ($mit in (Get-Command -Name Set-ProcessMitigation).Parameters['Disable'].Attributes.ValidValues){Set-ProcessMitigation -System -Disable $mit.ToString().Replace(' \', '\').Replace('`n\', '\')}" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü ïàìÿòü, óïðàâëÿåìóþ ÿäðîì, îòêëþ÷èòü èñïðàâëåíèÿ Meltdown/Spectre è óäàëèòü áèáëèîòåêè îáíîâëåíèé ìèêðîêîäà ïðîöåññîðîâ.%clr%[92m
@echo Âêëþ÷èòü ïàìÿòü, óïðàâëÿåìóþ ÿäðîì, îòêëþ÷èòü èñïðàâëåíèÿ Meltdown/Spectre è óäàëèòü áèáëèîòåêè îáíîâëåíèé ìèêðîêîäà ïðîöåññîðîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
call :acl_file-folders "%SystemRoot%\System32\mcupdate_AuthenticAMD.dll"
call :acl_file-folders "%SystemRoot%\System32\mcupdate_GenuineIntel.dll"
%rf% "%SystemRoot%\System32\mcupdate_AuthenticAMD.dll" 1>> %logfile% 2>>&1
%rf% "%SystemRoot%\System32\mcupdate_GenuineIntel.dll" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Çàïðåòèòü çàãðóçêó ñèñòåìíûõ ôàéëîâ (òàêèõ êàê ÿäðî è äðàéâåðû îáîðóäîâàíèÿ) â âèðòóàëüíóþ ïàìÿòü.%clr%[92m
@echo Çàïðåòèòü çàãðóçêó ñèñòåìíûõ ôàéëîâ (òàêèõ êàê ÿäðî è äðàéâåðû îáîðóäîâàíèÿ) â âèðòóàëüíóþ ïàìÿòü. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü îáúåäèíåíèå ñòðàíèö ïàìÿòè (òàêèõ êàê ñîâìåñòíîå èñïîëüçîâàíèå ñòðàíèö äëÿ èçîáðàæåíèé, êîïèðîâàíèå ïðè çàïèñè) äëÿ ñòðàíèö äàííûõ è ñæàòèå.%clr%[92m
@echo Îòêëþ÷èòü îáúåäèíåíèå ñòðàíèö ïàìÿòè (òàêèõ êàê ñîâìåñòíîå èñïîëüçîâàíèå ñòðàíèö äëÿ èçîáðàæåíèé, êîïèðîâàíèå ïðè çàïèñè) äëÿ ñòðàíèö äàííûõ è ñæàòèå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingCombining" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü áîëüøîé ñèñòåìíûé êýø äëÿ ÎÑ, ÷òîáû èñïðàâèòü ìèêðîôðèçû.%clr%[92m
@echo Îòêëþ÷èòü áîëüøîé ñèñòåìíûé êýø äëÿ ÎÑ, ÷òîáû èñïðàâèòü ìèêðîôðèçû. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "Size" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîïîëíèòåëüíûå ñðåäñòâà çàùèòû NTFS/ReFS.%clr%[92m
@echo Îòêëþ÷èòü äîïîëíèòåëüíûå ñðåäñòâà çàùèòû NTFS/ReFS. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü âðåìåííóþ ìåòêó 0 ìñ. Äëÿ íåîïòèìèçèðîâàííûõ ñèñòåì ðåêîìåíäóåòñÿ âûñòàâèòü ïàðàìåòð 1.%clr%[92m
@echo Âêëþ÷èòü âðåìåííóþ ìåòêó 0 ìñ. Äëÿ íåîïòèìèçèðîâàííûõ ñèñòåì ðåêîìåíäóåòñÿ âûñòàâèòü ïàðàìåòð 1. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" /v "TimeStampInterval" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ðàçäåëåíèå ïðîöåññà svchost.exe â äèñïåò÷åðå çàäà÷.%clr%[92m
@echo Îòêëþ÷èòü ðàçäåëåíèå ïðîöåññà svchost.exe â äèñïåò÷åðå çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "33554432" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AppInfo" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\AudioEndpointBuilder" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\BFE" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\BrokerInfrastructure" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Browser" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\BTAGService" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\camsvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\cbdhsvc_3c9a6" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\CDPSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\CmService" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\CoreMessagingRegistrar" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\CryptSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
call :acl_registry "HKLM\SYSTEM\CurrentControlSet\Services\DcomLaunch"
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\DcomLaunch" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\DeviceAssociationService" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Dhcp" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\DispBrokerDesktopSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\DsmSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Eaphost" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\EventLog" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\EventSystem" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\FontCache" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
call :acl_registry "HKLM\SYSTEM\CurrentControlSet\Services\gpsvc"
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\gpsvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\hidserv" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\hns" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\HvHost" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\iphlpsvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\LicenseManager" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\lmhosts" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\LSM" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\mpssvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NcaSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NcbService" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\netprofm" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NetSetupSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\nsi" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\nvagent" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\PlugPlay" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\PolicyAgent" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Power" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\ProfSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\RapiMgr" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\RasMan" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\RemoteAccess" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Schedule" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SstpSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\StateRepository" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\StorSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SystemEventsBroker" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Themes" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\TokenBroker" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
call :acl_registry "HKLM\SYSTEM\CurrentControlSet\Services\TrkWks"
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\TrkWks" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\UserManager" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\W3SVC" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\WAS" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\WcesComm" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Wcmsvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Winmgmt" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\WlanSvc" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\WpnService" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\WpnUserService_83e76" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Wuauserv" /v "SvcHostSplitDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïðåäîòâðàòèòü îøèáêè ïðè îòêëþ÷åíèè äðàéâåðîâ.%clr%[92m
@echo Ïðåäîòâðàòèòü îøèáêè ïðè îòêëþ÷åíèè äðàéâåðîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\Audiosrv" /v "ErrorControl" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\fvevol" /v "ErrorControl" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{6bdd1fc6-810f-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f 1>> %logfile% 2>>&1
rem %rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e967-e325-11ce-bfc1-08002be10318}" /v "LowerFilters" /t REG_MULTI_SZ /d "" /f 1>> %logfile% 2>>&1
rem %rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "" /f 1>> %logfile% 2>>&1 :: çàòèðàåò äàííûå ñòîðîííèõ ïðèëîæåíèé, â ñâÿçè ñ ýòèì â íèõ íå îòîáðàæàëèñü ðàçäåëû äèñêîâ.
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñëóæáó Superfetch.%clr%[92m
@echo Îòêëþ÷èòü ñëóæáó Superfetch. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\EnableSuperfetch" /v "DIPM" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
call :disable_svc SysMain
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñëóæáó èíäåêñàöèè ïîèñêà.%clr%[92m
@echo Îòêëþ÷èòü ñëóæáó èíäåêñàöèè ïîèñêà. 1>> %logfile%
set timerStart=!time!
call :disable_svc WSearch
call :acl_file-folders "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb"
%rf% %ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûñòàâèòü óâåëè÷åííîå âðåìÿ îæèäàíèÿ îòâåòà îò ñëóæá (çàïóñê, ïåðåçàïóñê, çàâåðøåíèå).%clr%[92m
@echo Âûñòàâèòü óâåëè÷åííîå âðåìÿ îæèäàíèÿ îòâåòà îò ñëóæá (çàïóñê, ïåðåçàïóñê, çàâåðøåíèå). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control" /v "ServicesPipeTimeout" /t REG_DWORD /d "180000" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü èñïîëüçîâàíèå êîðçèíû. Ôàéëû áóäóò óäàëÿòüñÿ îêîí÷àòåëüíî (ïîëåçíî äëÿ SSD äèñêîâ).%clr%[92m
@echo Îòêëþ÷èòü èñïîëüçîâàíèå êîðçèíû. Ôàéëû áóäóò óäàëÿòüñÿ îêîí÷àòåëüíî (ïîëåçíî äëÿ SSD äèñêîâ). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecycleFiles" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "Confirmrfete" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óâåëè÷åíèå îáúåìà èñïîëüçóåìîé ïàìÿòè äëÿ ôàéëîâîé ñèñòåìû NTFS.%clr%[92m
@echo Óâåëè÷åíèå îáúåìà èñïîëüçóåìîé ïàìÿòè äëÿ ôàéëîâîé ñèñòåìû NTFS. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMemoryUsage" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïîñòàâùèêà àëãîðèòìîâ ïîìîùíèêà îáîðóäîâàíèÿ.%clr%[92m
@echo Îòêëþ÷èòü ïîñòàâùèêà àëãîðèòìîâ ïîìîùíèêà îáîðóäîâàíèÿ. 1>> %logfile%
set timerStart=!time!
call :disable_svc cnghwassist
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïîìîùíèêà ïî ñîâìåñòèìîñòè ïðîãðàìì, çàïèñü øàãîâ è ñáîðùèêà èíâåíòàðèçàöèè.%clr%[92m
@echo Îòêëþ÷èòü ïîìîùíèêà ïî ñîâìåñòèìîñòè ïðîãðàìì, çàïèñü øàãîâ è ñáîðùèêà èíâåíòàðèçàöèè. 1>> %logfile%
set timerStart=!time!
call :disable_svc PcaSvc
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü óäàëåííîãî ïîìîùíèêà.%clr%[92m
@echo Îòêëþ÷èòü óäàëåííîãî ïîìîùíèêà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowUnsolicited" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%PS% "Get-WindowsCapability -Online | Where-Object {$_.Name -like 'App.Support.QuickAssist*'} | Remove-WindowsCapability -Online" 1>> %logfile% 2>>&1
call :disable_task "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ðåãèñòðàöèþ äëÿ óïðàâëåíèÿ ìîáèëüíûìè óñòðîéñòâàìè (MDM).%clr%[92m
@echo Îòêëþ÷èòü ðåãèñòðàöèþ äëÿ óïðàâëåíèÿ ìîáèëüíûìè óñòðîéñòâàìè (MDM). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" /v "DisableRegistration" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü îáíîâëåíèå ãðóïïîâîé ïîëèòèêè âî âðåìÿ çàãðóçêè Windows.%clr%[92m
@echo Îòêëþ÷èòü îáíîâëåíèå ãðóïïîâîé ïîëèòèêè âî âðåìÿ çàãðóçêè Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "SynchronousUserGroupPolicy" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "SynchronousMachineGroupPolicy" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñëóæáó îò÷åòà îá îøèáêàõ.%clr%[92m
@echo Îòêëþ÷èòü ñëóæáó îò÷åòà îá îøèáêàõ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "LogEvent" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïðåäâûáîðêó äëÿ óñêîðåíèÿ çàïóñêà Windows.%clr%[92m
@echo Îòêëþ÷èòü ïðåäâûáîðêó äëÿ óñêîðåíèÿ çàïóñêà Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü TRIM îïòèìèçàöèþ SSD äèñêîâ.%clr%[92m
@echo Âêëþ÷èòü TRIM îïòèìèçàöèþ SSD äèñêîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v "Enable" /t REG_SZ /d "Y" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OptimalLayout" /v "EnableAutoLayout" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
fsutil behavior set DisableDeleteNotify 0 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü ñîçäàíèå ïîñëåäíåé óäà÷íîé êîíôèãðóðàöèè çàãðóçêè.%clr%[92m
@echo Âêëþ÷èòü ñîçäàíèå ïîñëåäíåé óäà÷íîé êîíôèãðóðàöèè çàãðóçêè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "ReportBootOk" /t REG_SZ /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïðîâåðêó äèñêà ïðè çàïóñêå Windows.%clr%[92m
@echo Îòêëþ÷èòü ïðîâåðêó äèñêà ïðè çàïóñêå Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "BootExecute" /t REG_MULTI_SZ /d "" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Àâòîìàòè÷åñêè çàâåðøàòü íå îòâå÷àþùèå ïðèëîæåíèÿ.%clr%[92m
@echo Àâòîìàòè÷åñêè çàâåðøàòü íå îòâå÷àþùèå ïðèëîæåíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "5000" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowBlockingAppsAtShutdown" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óäàëèòü ëèøíèå àïïëåòû â ðàñøèðåííîì çàïóñêå.%clr%[92m
@echo Óäàëèòü ëèøíèå àïïëåòû â ðàñøèðåííîì çàïóñêå. 1>> %logfile%
set timerStart=!time!
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad" /v "WebCheck" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "VMApplet" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü îáíàðóæåíèå UPnP óñòðîéñòâ â ñåòè.%clr%[92m
@echo Îòêëþ÷èòü îáíàðóæåíèå UPnP óñòðîéñòâ â ñåòè. 1>> %logfile%
set timerStart=!time!
call :disable_svc SSDPSRV
call :disable_svc upnphost
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü êîíòðîëü ñèñòåìíûõ ñîáûòèé.%clr%[92m
@echo Îòêëþ÷èòü êîíòðîëü ñèñòåìíûõ ñîáûòèé. 1>> %logfile%
set timerStart=!time!
call :disable_svc SENS
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü óñòàíîâêó êîìïîíåíòîâ ÿçûêîâûõ ïàêåòîâ èç èíòåðíåòà.%clr%[92m
@echo Îòêëþ÷èòü óñòàíîâêó êîìïîíåíòîâ ÿçûêîâûõ ïàêåòîâ èç èíòåðíåòà. 1>> %logfile%
set timerStart=!time!
call :disable_task "\Microsoft\Windows\LanguageComponentsInstaller\Installation"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñëóæáû äèàãíîñòèêè.%clr%[92m
@echo Îòêëþ÷èòü ñëóæáû äèàãíîñòèêè. 1>> %logfile%
set timerStart=!time!
call :disable_svc DPS
call :disable_svc WdiServiceHost
call :disable_svc WdiSystemHost
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\NetworkServiceTriggers\Triggers\bc90d167-9470-4139-a9ba-be0bbbf5b74d" /v "795B6BF9-97B6-4F89-BD8D-2F42BBBE996E" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\NetworkServiceTriggers\Triggers\bc90d167-9470-4139-a9ba-be0bbbf5b74d" /v "945693c4-3648-4966-b2aa-37d66e24495f" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü àâòîçàïóñê CD-DVD è ñúåìíûõ óñòðîéñòâ.%clr%[92m
@echo Îòêëþ÷èòü àâòîçàïóñê CD-DVD è ñúåìíûõ óñòðîéñòâ. 1>> %logfile%
set timerStart=!time!
call :disable_svc ShellHWDetection
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Íå îòîáðàæàòü ïîäðîáíûå ñîîáùåíèÿ î ñîñòîÿíèè ïðè çàïóñêå è çàâåðøåíèè ðàáîòû Windows.%clr%[92m
@echo Íå îòîáðàæàòü ïîäðîáíûå ñîîáùåíèÿ î ñîñòîÿíèè ïðè çàïóñêå è çàâåðøåíèè ðàáîòû Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñèñòåìó àâòî-âûðàâíèâàíèÿ çâóêà.%clr%[92m
@echo Îòêëþ÷èòü ñèñòåìó àâòî-âûðàâíèâàíèÿ çâóêà. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûêëþ÷èòü ôóíêöèþ Âðåìÿ ïîñëåäíåãî äîñòóïà.%clr%[92m
@echo Âûêëþ÷èòü ôóíêöèþ Âðåìÿ ïîñëåäíåãî äîñòóïà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
fsutil behavior set DisableLastAccess 1 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü øèðîêèèå êîíòåêñòíûå ìåíþ.%clr%[92m
@echo Îòêëþ÷èòü øèðîêèèå êîíòåêñòíûå ìåíþ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\FlightedFeatures" /v "ImmersiveContextMenu" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ìèíèàòþðû ñåòåâûõ ïàïîê.%clr%[92m
@echo Îòêëþ÷èòü ìèíèàòþðû ñåòåâûõ ïàïîê. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisableThumbnailsOnNetworkFolders" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïîêàçàòü áóêâû äèñêîâ ïåðåä èìåíåì äèñêîâ.%clr%[92m
@echo Ïîêàçàòü áóêâû äèñêîâ ïåðåä èìåíåì äèñêîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowDriveLettersFirst" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óâåëè÷èòü ìàêñèìàëüíîå êîëè÷åñòâî ðàáî÷èõ ïîòîêîâ.%clr%[92m
@echo Óâåëè÷èòü ìàêñèìàëüíîå êîëè÷åñòâî ðàáî÷èõ ïîòîêîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellTaskScheduler" /v "MaxWorkerThreadsPerScheduler" /t REG_DWORD /d "255" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü àâòîçàâåðøåíèå â àäðåñíîé ñòðîêå è àâòîìàòè÷åñêèé ââîä â ïîëå ïîèñêà.%clr%[92m
@echo Âêëþ÷èòü àâòîçàâåðøåíèå â àäðåñíîé ñòðîêå è àâòîìàòè÷åñêèé ââîä â ïîëå ïîèñêà. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TypeAhead" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" /v "Append Completion" /t REG_SZ /d "Yes" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñâîðà÷èâàíèå îêîí ïðè âñòðÿõèâàíèè (Aero Shake).%clr%[92m
@echo Îòêëþ÷èòü ñâîðà÷èâàíèå îêîí ïðè âñòðÿõèâàíèè (Aero Shake). 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûñòàâèòü òèï âñåõ ïàïîê êàê "Ïëèòêà".%clr%[92m
@echo Âûñòàâèòü òèï âñåõ ïàïîê êàê "Ïëèòêà". 1>> %logfile%
set timerStart=!time!
rem %rgd% "HKCU\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\Shell\Bags" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "FolderType" /t REG_SZ /d "NotSpecified" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "WFlags" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "ShowCmd" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "HotKey" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v "NavBar" /t REG_BINARY /d "000000000000000000000000000000008b000000870000003153505305d5cdd59c2e1b10939708002b2cf9ae6b0000005a000000007b00360044003800420042003300440033002d0039004400380037002d0034004100390031002d0041004200350036002d003400460033003000430046004600450046004500390046007d005f0057006900640074006800000013000000580100000000000000000000" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óñòàíîâèòü èìÿ íîâîé ïàïêè è ÿðëûêà êàê _ .%clr%[92m
@echo Óñòàíîâèòü èìÿ íîâîé ïàïêè è ÿðëûêà êàê _ . 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "RenameNameTemplate" /t REG_SZ /d "_" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "CopyNameTemplate" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "CopyNameTemplate" /t REG_SZ /d "%%s_" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Íå äîáàâëÿòü ñóôôèêñ - ßðëûê ê èìåíè ñîçäàííîãî ÿðëûêà.%clr%[92m
@echo Íå äîáàâëÿòü ñóôôèêñ - ßðëûê ê èìåíè ñîçäàííîãî ÿðëûêà. 1>> %logfile%
set timerStart=!time!
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "ShortcutNameTemplate" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "ShortcutNameTemplate" /t REG_SZ /d "%%s.lnk" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óäàëèòü ñòðåëêó ñ ÿðëûêîâ, ôàéëîâ è ñåòåâûõ ÿðëûêîâ.%clr%[92m
@echo Óäàëèòü ñòðåëêó ñ ÿðëûêîâ, ôàéëîâ è ñåòåâûõ ÿðëûêîâ. 1>> %logfile%
set timerStart=!time!
xcopy %~dp0link.ico %SystemRoot% /c /q /h /r /y 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_SZ /d "%SystemRoot%\link.ico,0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "77" /t REG_SZ /d "%SystemRoot%\link.ico,0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ðåæèì ïëàíøåòà.%clr%[92m
@echo Îòêëþ÷èòü ðåæèì ïëàíøåòà. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAppsVisibleInTabletMode" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "ConvertibleSlateModePromptPreference" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
rem call :disable_svc_sudo TabletInputService
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü æèâûå ïëèòêè.%clr%[92m
@echo Îòêëþ÷èòü æèâûå ïëèòêè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàïðîñ Êàê âû õîòèòå îòêðûòü ýòîò ôàéë.%clr%[92m
@echo Îòêëþ÷èòü çàïðîñ Êàê âû õîòèòå îòêðûòü ýòîò ôàéë. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoNewAppAlert" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïîñëåäíèå äîáàâëåííûå ïðèëîæåíèÿ.%clr%[92m
@echo Ñêðûòü ïîñëåäíèå äîáàâëåííûå ïðèëîæåíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñîçäàíèå ñïèñêîâ ïîñëåäíèõ èñïîëüçîâàííûõ ýëåìåíòîâ (MRU), òàêèõ êàê ìåíþ Ïîñëåäíèå ýëåìåíòû â ìåíþ Ïóñê, ñïèñêè ïåðåõîäîâ è ÿðëûêè â íèæíåé ÷àñòè ìåíþ Ôàéë â ïðèëîæåíèÿõ.%clr%[92m
@echo Îòêëþ÷èòü ñîçäàíèå ñïèñêîâ ïîñëåäíèõ èñïîëüçîâàííûõ ýëåìåíòîâ (MRU), òàêèõ êàê ìåíþ Ïîñëåäíèå ýëåìåíòû â ìåíþ Ïóñê, ñïèñêè ïåðåõîäîâ è ÿðëûêè â íèæíåé ÷àñòè ìåíþ Ôàéë â ïðèëîæåíèÿõ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocs" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü îíëàéí-êîíòåíò â ïðîâîäíèêå.%clr%[92m
@echo Îòêëþ÷èòü îíëàéí-êîíòåíò â ïðîâîäíèêå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoOnlinePrintsWizard" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoPublishingWizard" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWebServices" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïðåäóïðåæäåíèÿ î íåäîñòàòêå ñâîáîäíîãî ìåñòà íà äèñêå, ïîèñêà ñîîòâåòñòâèé äëÿ ÿðëûêîâ.%clr%[92m
@echo Îòêëþ÷èòü ïðåäóïðåæäåíèÿ î íåäîñòàòêå ñâîáîäíîãî ìåñòà íà äèñêå, ïîèñêà ñîîòâåòñòâèé äëÿ ÿðëûêîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïîèñê Bing â ìåíþ Ïóñê.%clr%[92m
@echo Îòêëþ÷èòü ïîèñê Bing â ìåíþ Ïóñê. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñîçäàíèå ôàéëà ïîäêà÷êè swapfile.sys äëÿ ïðèëîæåíèè è îñâîáîäèòü 256 ÌÁ äèñêîâîãî ïðîñòðàíñòâà.%clr%[92m
@echo Îòêëþ÷èòü ñîçäàíèå ôàéëà ïîäêà÷êè swapfile.sys äëÿ ïðèëîæåíèè è îñâîáîäèòü 256 ÌÁ äèñêîâîãî ïðîñòðàíñòâà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ìèíóòíîå îæèäàíèå ïðè ïåðâîì âõîäå â ñèñòåìó.%clr%[92m
@echo Îòêëþ÷èòü ìèíóòíîå îæèäàíèå ïðè ïåðâîì âõîäå â ñèñòåìó. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "FSIASleepTimeInMs" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óäàëèòü íåñóùåñòâóþùèå ÿðëûêè çàïóñêà.%clr%[92m
@echo Óäàëèòü íåñóùåñòâóþùèå ÿðëûêè çàïóñêà. 1>> %logfile%
set timerStart=!time!
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" /v "table30.exe" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" /v "fsquirt.exe" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" /v "dfshim.dll" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" /v "setup.exe" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" /v "install.exe" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" /v "cmmgr32.exe" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïðåäóïðåæäåíèå ñèñòåìû áåçîïàñíîñòè ïðè îòêðûòèè ôàéëîâ èç èíòåðíåòà.%clr%[92m
@echo Îòêëþ÷èòü ïðåäóïðåæäåíèå ñèñòåìû áåçîïàñíîñòè ïðè îòêðûòèè ôàéëîâ èç èíòåðíåòà. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "Flags" /t REG_DWORD /d "219" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Environment" /v "SEE_MASK_NOZONECHECKS" /t REG_SZ /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "SEE_MASK_NOZONECHECKS" /t REG_SZ /d "1" /f 1>> %logfile% 2>>&1
setx SEE_MASK_NOZONECHECKS 1 /m 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü îòîáðàæåíèå ãðàôè÷åñêîãî ïàðîëÿ.%clr%[92m
@echo Îòêëþ÷èòü îòîáðàæåíèå ãðàôè÷åñêîãî ïàðîëÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "BlockDomainPicturePassword" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü èñòîðèþ àêòèâíîñòè â Ïðåäñòàâëåíèè çàäà÷.%clr%[92m
@echo Îòêëþ÷èòü èñòîðèþ àêòèâíîñòè â Ïðåäñòàâëåíèè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü èñòîðèþ íåäàâíèõ äîêóìåíòîâ è ÷àñòî èñïîëüçóåìûõ ïàïîê.%clr%[92m
@echo Îòêëþ÷èòü èñòîðèþ íåäàâíèõ äîêóìåíòîâ è ÷àñòî èñïîëüçóåìûõ ïàïîê. 1>> %logfile%
set timerStart=!time!
if "%arch%"=="x64" (
	%rgd% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3936E9E4-D92C-4EEE-A85A-BC16D5EA0819}" /f 1>> %logfile% 2>>&1
)
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3936E9E4-D92C-4EEE-A85A-BC16D5EA0819}" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü USB ïîðò ïîñëå áåçîïàñíîãî îòêëþ÷åíèÿ USB-óñòðîéñòâà.%clr%[92m
@echo Îòêëþ÷èòü USB ïîðò ïîñëå áåçîïàñíîãî îòêëþ÷åíèÿ USB-óñòðîéñòâà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\StorageDevicePolicies" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\usbhub\HubG" /v "DisableOnSoftRemove" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableRemovableDriveIndexing" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óäàëèòü Kernel èç ÷åðíîãî ñïèñêà ãðàôè÷åñêèõ äðàéâåðîâ.%clr%[92m
@echo Óäàëèòü Kernel èç ÷åðíîãî ñïèñêà ãðàôè÷åñêèõ äðàéâåðîâ. 1>> %logfile%
set timerStart=!time!
%rgd% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\BlockList\Kernel" /va /reg:64 /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü DPC Watchdog.%clr%[92m
@echo Îòêëþ÷èòü DPC Watchdog. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DpcWatchdogProfileOffset" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DpcTimeout" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IdealDpcRate" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MaximumDpcQueueDepth" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MinimumDpcRate" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ThreadDpcEnable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "AdjustDpcThreshold" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "DpcWatchdogPeriod" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ýêðàí áëîêèðîâêè.%clr%[92m
@echo Îòêëþ÷èòü ýêðàí áëîêèðîâêè. 1>> %logfile%
set timerStart=!time!
call :kill "LockApp.exe"
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" /v "AllowLockScreen" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableLockScreenAppNotifications" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Íàñòðîèòü êîìïüþòåð íà ïîëíîå âûêëþ÷åíèå.%clr%[92m
@echo Íàñòðîèòü êîìïüþòåð íà ïîëíîå âûêëþ÷åíèå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogon" /v "PowerdownAfterShutdown" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü àâòîìàòè÷åñêîå îáñëóæèâàíèå ñèñòåìû.%clr%[92m
@echo Îòêëþ÷èòü àâòîìàòè÷åñêîå îáñëóæèâàíèå ñèñòåìû. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Çàïðåòèòü èñïîëüçîâàíèå áèîìåòðèè.%clr%[92m
@echo Çàïðåòèòü èñïîëüçîâàíèå áèîìåòðèè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Biometrics\Credential Provider" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
call :disable_svc WbioSrvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê îòñëåæèâàíèþ çà äâèæåíèÿìè.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê îòñëåæèâàíèþ çà äâèæåíèÿìè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\sensors.custom" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê èíôîðìàöèè îá àêêàóíòå.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê èíôîðìàöèè îá àêêàóíòå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /t REG_SZ /v "Value" /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïðèëîæåíèÿì äîñòóï ê óâåäîìëåíèÿì.%clr%[92m
@echo Îòêëþ÷èòü ïðèëîæåíèÿì äîñòóï ê óâåäîìëåíèÿì. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" /t REG_SZ /v "Value" /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê êàëåíäàðþ.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê êàëåíäàðþ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /t REG_SZ /v "Value" /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê èñòîðèè çâîíêîâ.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê èñòîðèè çâîíêîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" /t REG_SZ /v "Value" /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê çàäà÷àì.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê çàäà÷àì. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê âèäåî.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê âèäåî. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ðàçðåøèòü äîñòóï ïðèëîæåíèÿì ê êàìåðå.%clr%[92m
@echo Ðàçðåøèòü äîñòóï ïðèëîæåíèÿì ê êàìåðå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /t REG_SZ /d "Allow" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê íåñîïðÿæåííûì óñòðîéñòâàì Bluetooth.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê íåñîïðÿæåííûì óñòðîéñòâàì Bluetooth. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê êîíòàêòàì.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê êîíòàêòàì. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" /t REG_SZ /v "Value" /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê äèàãíîñòèêå.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê äèàãíîñòèêå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê äîêóìåíòàì.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê äîêóìåíòàì. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê èçîáðàæåíèÿì.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê èçîáðàæåíèÿì. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê ðàäèî è îòêëþ÷èòü ñëóæáó Â ñàìîëåòå.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê ðàäèî è îòêëþ÷èòü ñëóæáó Â ñàìîëåòå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
call :disable_svc RmSvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê ïî÷òå.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê ïî÷òå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ðàçðåøèòü äîñòóï ïðèëîæåíèÿì ê ôàéëîâîé ñèñòåìå.%clr%[92m
@echo Ðàçðåøèòü äîñòóï ïðèëîæåíèÿì ê ôàéëîâîé ñèñòåìå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /v "Value" /t REG_SZ /d "Allow" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê ââîäó âçãëÿäîì.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê ââîäó âçãëÿäîì. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê ãåîëîêàöèè.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê ãåîëîêàöèè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê îáìåíó ñîîáùåíèÿìè.%clr%[92m
@echo Îòêëþ÷èòü äîñòóï ïðèëîæåíèÿì ê îáìåíó ñîîáùåíèÿìè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{21157C1F-2651-4CC1-90CA-1F28B02263F6}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ðàçðåøèòü äîñòóï ïðèëîæåíèÿì ê ìèêðîôîíó.%clr%[92m
@echo Ðàçðåøèòü äîñòóï ïðèëîæåíèÿì ê ìèêðîôîíó. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Allow" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ýêñïåðèìåíòû íàä ñèñòåìîé.%clr%[92m
@echo Îòêëþ÷èòü ýêñïåðèìåíòû íàä ñèñòåìîé. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation" /v "value" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System\AllowExperimentation" /v "value" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü èñòîðèþ ôàéëîâ.%clr%[92m
@echo Îòêëþ÷èòü èñòîðèþ ôàéëîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\FileHistory" /v "Disabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûêëþ÷èòü ãèáåðíàöèþ è îòêëþ÷èòü áûñòðûé çàïóñê.%clr%[92m %clr%[7;31mÏðèìå÷àíèå:%clr%[0m%clr%[36m%clr%[92m ïðè âêëþ÷åíèè áûñòðîãî çàïóñêà ïðîïàäàåò âîçìîæíîñòü âûêëþ÷åíèÿ ÏÊ. Îòêëþ÷åíèå ãèáåðíàöèè ïîëåçíî äëÿ äîëãîâå÷íîñòè SSD íàêîïèòåëåé.
@echo Âûêëþ÷èòü ãèáåðíàöèþ è îòêëþ÷èòü áûñòðûé çàïóñê. Ïðèìå÷àíèå: ïðè âêëþ÷åíèè áûñòðîãî çàïóñêà ïðîïàäàåò âîçìîæíîñòü âûêëþ÷åíèÿ ÏÊ. Îòêëþ÷åíèå ãèáåðíàöèè ïîëåçíî äëÿ äîëãîâå÷íîñòè SSD íàêîïèòåëåé. 1>> %logfile%
set timerStart=!time!
powercfg /h off 1>> %logfile% 2>>&1
wmic pagefileset where name="%SystemDrive%\\pagefile.sys" delete 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HiberFileSizePercent" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowHibernateOption" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñïÿùèé ðåæèì è êíîïêó Sleep íà êëàâèàòóðå.%clr%[92m
@echo Îòêëþ÷èòü ñïÿùèé ðåæèì è êíîïêó Sleep íà êëàâèàòóðå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowSleepOption" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
powercfg /X standby-timeout-ac 0 1>> %logfile% 2>>&1
powercfg /X standby-timeout-dc 0 1>> %logfile% 2>>&1
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 0 1>> %logfile% 2>>&1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 0 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïðåäëîæåíèå ñðåäñòâà óäàëåíèÿ âðåäîíîñíûõ ïðîãðàìì ÷åðåç Öåíòð îáíîâëåíèÿ Windows.%clr%[92m
@echo Îòêëþ÷èòü ïðåäëîæåíèå ñðåäñòâà óäàëåíèÿ âðåäîíîñíûõ ïðîãðàìì ÷åðåç Öåíòð îáíîâëåíèÿ Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü àâòîìàòè÷åñêóþ ïåðåçàãðóçêó ïðè ñáîå ñèñòåìû (BSOD).%clr%[92m
@echo Îòêëþ÷èòü àâòîìàòè÷åñêóþ ïåðåçàãðóçêó ïðè ñáîå ñèñòåìû (BSOD). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûñòàâèòü íèçêèé óðîâåíü UAC (êîíòðîëü ó÷åòíûõ çàïèñåé).%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m ïîëíîå îòêëþ÷åíèå ïðèâåäåò ê ïîëîìêå íåêîòîðûõ ïðèëîæåíèé.
@echo Âûñòàâèòü íèçêèé óðîâåíü UAC (êîíòðîëü ó÷åòíûõ çàïèñåé). Ïðåäóïðåæäåíèå: ïîëíîå îòêëþ÷åíèå ïðèâåäåò ê ïîëîìêå íåêîòîðûõ ïðèëîæåíèé. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïðåäîòâðàùåíèå âûïîëíåíèÿ äàííûõ (DEP) äëÿ Internet Explorer.%clr%[92m
@echo Îòêëþ÷èòü ïðåäîòâðàùåíèå âûïîëíåíèÿ äàííûõ (DEP) äëÿ Internet Explorer. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "DEPOff" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïðîâåðêó îòçûâà ñåðòèôèêàòîâ è âêëþ÷èòü èõ ïðîçðà÷íîñòü ïðè çàïóñêå ïðèëîæåíèè.%clr%[92m
@echo Îòêëþ÷èòü ïðîâåðêó îòçûâà ñåðòèôèêàòîâ è âêëþ÷èòü èõ ïðîçðà÷íîñòü ïðè çàïóñêå ïðèëîæåíèè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers" /v "authenticodeenabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers" /v "TransparentEnabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü îáðàòíóþ ñâÿçü ñ ïåðîì.%clr%[92m
@echo Îòêëþ÷èòü îáðàòíóþ ñâÿçü ñ ïåðîì. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\TabletPC" /v "TurnOffPenFeedback" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàäåðæêó çàïóñêà Windows.%clr%[92m
@echo Îòêëþ÷èòü çàäåðæêó çàïóñêà Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óñêîðèòü âõîä â ñèñòåìó.%clr%[92m
@echo Óñêîðèòü âõîä â ñèñòåìó. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\AppEvents\Schemes" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DelayedDesktopSwitchTimeout" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Îòêëþ÷èòü îòïðàâêó è ñèíõðîíèçàöèþ ôàéëîâ ñ îáëàêîì.%clr%[92m
@echo Îòêëþ÷èòü îòïðàâêó è ñèíõðîíèçàöèþ ôàéëîâ ñ îáëàêîì. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "EnableBackupForWin8Apps" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t Reg_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableAppSyncSettingSync" /t Reg_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableAppSyncSettingSyncUserOverride" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSync" /t Reg_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSyncUserOverride" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSync" /t Reg_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSyncUserOverride" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSync" /t Reg_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSyncUserOverride" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSync" /t Reg_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSyncUserOverride" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSync" /t Reg_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSyncUserOverride" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSync" /t Reg_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSyncUserOverride" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSync" /t Reg_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSyncUserOverride" /t Reg_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\AppSync" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\DesktopTheme" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\PackageState" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\StartLayout" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t Reg_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t Reg_DWORD /d "5" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Îòêëþ÷èòü ôàéåðâîë?%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m ïîñëå îòêëþ÷åíèÿ âîçìîæíî íå áóäåò ðàáîòàòü ôàéåðâîë â ñòîðîííåé àíòèâèðóñíîé ïðîãðàììå.
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÎòêëþ÷åíèå ôàéåðâîëà. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Îòêëþ÷åíèå ôàéåðâîëà. Ïðåäóïðåæäåíèå: ïîñëå îòêëþ÷åíèÿ âîçìîæíî íå áóäåò ðàáîòàòü ôàéåðâîë â ñòîðîííåé àíòèâèðóñíîé ïðîãðàììå. 1>> %logfile%
	set timerStart=!time!
	%rga% "HKLM\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	netsh advfirewall firewall set rule group="Network Discovery" new enable=No 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /f 1>> %logfile% 2>>&1
	netsh advfirewall set allprofiles state off 1>> %logfile% 2>>&1
	call :disable_svc MpsSvc
	call :disable_svc mpsdrv
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
set fwname="Block appvlp.exe"
netsh advfirewall firewall show rule name=all | findstr /r %fwname% >nul
if errorlevel 1 (
	@echo %clr%[36m Äîáàâèòü äîïîëíèòåëüíûå ïðàâèëà ôàéåðâîëà äëÿ óñèëåíèÿ çàùèòû ÎÑ?%clr%[92m
	choice /c yn /n /t %autoChoose% /d y /m %keySelY%
	if !errorlevel!==1 (
		@echo %clr%[0m %clr%[93mÄîáàâëåíèå äîïîëíèòåëüíûõ ïðàâèë ôàéåðâîëà äëÿ óñèëåíèÿ çàùèòû ÎÑ. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
		@echo Äîáàâëåíèå äîïîëíèòåëüíûõ ïðàâèë ôàéåðâîëà äëÿ óñèëåíèÿ çàùèòû ÎÑ. 1>> %logfile%
		set timerStart=!time!
		netsh advfirewall firewall add rule name="Block appvlp.exe" program="%ProgramFiles%\Microsoft Office\root\client\AppVLP.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block appvlp.exe" program="%ProgramFiles(x86)%\Microsoft Office\root\client\AppVLP.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block At.exe" program="%SystemRoot%\System32\At.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block At.exe" program="%SystemRoot%\SysWOW64\At.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Attrib.exe" program="%SystemRoot%\System32\Attrib.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Attrib.exe" program="%SystemRoot%\SysWOW64\Attrib.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Atbroker.exe" program="%SystemRoot%\System32\Atbroker.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Atbroker.exe" program="%SystemRoot%\SysWOW64\Atbroker.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block bash.exe" program="%SystemRoot%\System32\bash.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block bash.exe" program="%SystemRoot%\SysWOW64\bash.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block bitsadmin.exe" program="%SystemRoot%\System32\bitsadmin.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block bitsadmin.exe" program="%SystemRoot%\SysWOW64\bitsadmin.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block calc.exe" program="%SystemRoot%\System32\calc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block calc.exe" program="%SystemRoot%\SysWOW64\calc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block certreq.exe" program="%SystemRoot%\System32\certreq.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block certreq.exe" program="%SystemRoot%\SysWOW64\certreq.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block certutil.exe" program="%SystemRoot%\System32\certutil.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block certutil.exe" program="%SystemRoot%\SysWOW64\certutil.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block cmdkey.exe" program="%SystemRoot%\System32\cmdkey.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block cmdkey.exe" program="%SystemRoot%\SysWOW64\cmdkey.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block cmstp.exe" program="%SystemRoot%\System32\cmstp.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block cmstp.exe" program="%SystemRoot%\SysWOW64\cmstp.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block CompatTelRunner.exe" program="%SystemRoot%\System32\CompatTelRunner.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block CompatTelRunner.exe" program="%SystemRoot%\SysWOW64\CompatTelRunner.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ConfigSecurityPolicy.exe" program="%ProgramData%\Microsoft\Windows Defender\Platform\4.18.2008.9-0\ConfigSecurityPolicy.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block control.exe" program="%SystemRoot%\System32\control.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block control.exe" program="%SystemRoot%\SysWOW64\control.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Csc.exe" program="%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\Csc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Csc.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\Csc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block cscript.exe" program="%SystemRoot%\System32\cscript.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block cscript.exe" program="%SystemRoot%\SysWOW64\cscript.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ctfmon.exe" program="%SystemRoot%\System32\ctfmon.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ctfmon.exe" program="%SystemRoot%\SysWOW64\ctfmon.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block curl.exe" program="%SystemRoot%\System32\curl.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block curl.exe" program="%SystemRoot%\SysWOW64\curl.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block desktopimgdownldr.exe" program="%SystemRoot%\System32\desktopimgdownldr.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block DeviceDisplayObjectProvider.exe" program="%SystemRoot%\System32\DeviceDisplayObjectProvider.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block DeviceDisplayObjectProvider.exe" program="%SystemRoot%\SysWOW64\DeviceDisplayObjectProvider.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Dfsvc.exe" program="%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\Dfsvc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Dfsvc.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\Dfsvc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block diskshadow.exe" program="%SystemRoot%\SysWOW64\diskshadow.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block diskshadow.exe" program="%SystemRoot%\System32\diskshadow.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Dnscmd.exe" program="%SystemRoot%\SysWOW64\Dnscmd.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Dnscmd.exe" program="%SystemRoot%\System32\Dnscmd.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block dwm.exe" program="%SystemRoot%\SysWOW64\dwm.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block dwm.exe" program="%SystemRoot%\System32\dwm.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block eventvwr.exe" program="%SystemRoot%\SysWOW64\eventvwr.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block eventvwr.exe" program="%SystemRoot%\System32\eventvwr.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block esentutl.exe" program="%SystemRoot%\SysWOW64\esentutl.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block esentutl.exe" program="%SystemRoot%\System32\esentutl.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block eventvwr.exe" program="%SystemRoot%\SysWOW64\eventvwr.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block eventvwr.exe" program="%SystemRoot%\SysWOW64\eventvwr.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Expand.exe" program="%SystemRoot%\System32\Expand.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Expand.exe" program="%SystemRoot%\SysWOW64\Expand.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block explorer.exe" program="%SystemRoot%\System32\explorer.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block explorer.exe" program="%SystemRoot%\SysWOW64\explorer.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Extexport.exe" program="%ProgramFiles%\Internet Explorer\Extexport.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Extexport.exe" program="%ProgramFiles(x86)%\Internet Explorer\Extexport.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block extrac32.exe" program="%SystemRoot%\System32\extrac32.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block extrac32.exe" program="%SystemRoot%\SysWOW64\extrac32.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block findstr.exe" program="%SystemRoot%\System32\findstr.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block findstr.exe" program="%SystemRoot%\SysWOW64\findstr.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block forfiles.exe" program="%SystemRoot%\System32\forfiles.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block forfiles.exe" program="%SystemRoot%\SysWOW64\forfiles.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ftp.exe" program="%SystemRoot%\System32\ftp.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ftp.exe" program="%SystemRoot%\SysWOW64\ftp.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block gpscript.exe" program="%SystemRoot%\System32\gpscript.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block gpscript.exe" program="%SystemRoot%\SysWOW64\gpscript.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block hh.exe" program="%SystemRoot%\System32\hh.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block hh.exe" program="%SystemRoot%\SysWOW64\hh.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ie4uinit.exe" program="%SystemRoot%\System32\ie4uinit.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ie4uinit.exe" program="%SystemRoot%\SysWOW64\ie4uinit.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ieexec.exe" program="%SystemRoot%\Microsoft.NET\Framework\v2.0.50727\ieexec.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ieexec.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v2.0.50727\ieexec.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ilasm.exe" program="%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\ilasm.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ilasm.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\ilasm.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Infdefaultinstall.exe" program="%SystemRoot%\System32\Infdefaultinstall.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Infdefaultinstall.exe" program="%SystemRoot%\SysWOW64\Infdefaultinstall.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block InstallUtil.exe" program="%SystemRoot%\Microsoft.NET\Framework\v2.0.50727\InstallUtil.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block InstallUtil.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v2.0.50727\InstallUtil.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block InstallUtil.exe" program="%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block InstallUtil.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Jsc.exe" program="%SystemRoot%\Microsoft.NET\Framework\v2.0.50727\Jsc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Jsc.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v2.0.50727\Jsc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Jsc.exe" program="%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\Jsc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Jsc.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\Jsc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block lsass.exe" program="%SystemRoot%\System32\lsass.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block lsass.exe" program="%SystemRoot%\SysWOW64\lsass.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block makecab.exe" program="%SystemRoot%\System32\makecab.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block makecab.exe" program="%SystemRoot%\SysWOW64\makecab.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block mavinject.exe" program="%SystemRoot%\System32\mavinject.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block mavinject.exe" program="%SystemRoot%\SysWOW64\mavinject.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Microsoft.Workflow.Compiler.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\Microsoft.Workflow.Compiler.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block mmc.exe" program="%SystemRoot%\SysWOW64\mmc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block mmc.exe" program="%SystemRoot%\System32\mmc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block MpCmdRun.exe" program="%ProgramData%\Microsoft\Windows Defender\Platform\4.18.2008.4-0\MpCmdRun.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block MpCmdRun.exe" program="%ProgramData%\Microsoft\Windows Defender\Platform\4.18.2008.7-0\MpCmdRun.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block MpCmdRun.exe" program="%ProgramData%\Microsoft\Windows Defender\Platform\4.18.2008.9-0\MpCmdRun.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Msbuild.exe" program="%SystemRoot%\Microsoft.NET\Framework\v2.0.50727\Msbuild.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Msbuild.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v2.0.50727\Msbuild.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Msbuild.exe" program="%SystemRoot%\Microsoft.NET\Framework\v3.5\Msbuild.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Msbuild.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v3.5\Msbuild.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Msbuild.exe" program="%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\Msbuild.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Msbuild.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\Msbuild.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block msconfig.exe" program="%SystemRoot%\System32\msconfig.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Msdt.exe" program="%SystemRoot%\System32\Msdt.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Msdt.exe" program="%SystemRoot%\SysWOW64\Msdt.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block mshta.exe" program="%SystemRoot%\System32\mshta.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block mshta.exe" program="%SystemRoot%\SysWOW64\mshta.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block msiexec.exe" program="%SystemRoot%\System32\msiexec.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block msiexec.exe" program="%SystemRoot%\SysWOW64\msiexec.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Netsh.exe" program="%SystemRoot%\System32\Netsh.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Netsh.exe" program="%SystemRoot%\SysWOW64\Netsh.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block notepad.exe" program="%SystemRoot%\system32\notepad.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block notepad.exe " program="%SystemRoot%\SysWOW64\notepad.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block odbcconf.exe" program="%SystemRoot%\System32\odbcconf.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block odbcconf.exe" program="%SystemRoot%\SysWOW64\odbcconf.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block pcalua.exe" program="%SystemRoot%\System32\pcalua.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block pcalua.exe" program="%SystemRoot%\SysWOW64\pcalua.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block pcwrun.exe" program="%SystemRoot%\System32\pcwrun.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block pcwrun.exe" program="%SystemRoot%\SysWOW64\pcwrun.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block pktmon.exe" program="%SystemRoot%\System32\pktmon.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block pktmon.exe" program="%SystemRoot%\SysWOW64\pktmon.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block powershell.exe" program="%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block powershell.exe" program="%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block powershell_ise.exe" program="%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell_ise.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block powershell_ise.exe" program="%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell_ise.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Presentationhost.exe" program="%SystemRoot%\System32\Presentationhost.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Presentationhost.exe" program="%SystemRoot%\SysWOW64\Presentationhost.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block print.exe" program="%SystemRoot%\System32\print.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block print.exe" program="%SystemRoot%\SysWOW64\print.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block psr.exe" program="%SystemRoot%\System32\psr.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block psr.exe" program="%SystemRoot%\SysWOW64\psr.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block rasautou.exe" program="%SystemRoot%\System32\rasautou.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block rasautou.exe" program="%SystemRoot%\SysWOW64\rasautou.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block reg.exe" program="%SystemRoot%\System32\reg.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block reg.exe" program="%SystemRoot%\SysWOW64\reg.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regasm.exe" program="%SystemRoot%\Microsoft.NET\Framework\v2.0.50727\regasm.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regasm.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v2.0.50727\regasm.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regasm.exe" program="%SystemRoot%\Microsoft.NET\Framework\v4.0.30319\regasm.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regasm.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\regasm.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regedit.exe" program="%SystemRoot%\System32\regedit.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regedit.exe" program="%SystemRoot%\SysWOW64\regedit.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regini.exe" program="%SystemRoot%\System32\regini.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regini.exe" program="%SystemRoot%\SysWOW64\regini.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Register-cimprovider.exe" program="%SystemRoot%\System32\Register-cimprovider.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block Register-cimprovider.exe" program="%SystemRoot%\SysWOW64\Register-cimprovider.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regsvcs.exe" program="%SystemRoot%\System32\regsvcs.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regsvcs.exe" program="%SystemRoot%\SysWOW64\regsvcs.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regsvr32.exe" program="%SystemRoot%\System32\regsvr32.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block regsvr32.exe" program="%SystemRoot%\SysWOW64\regsvr32.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block replace.exe" program="%SystemRoot%\System32\replace.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block replace.exe" program="%SystemRoot%\SysWOW64\replace.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block rpcping.exe" program="%SystemRoot%\System32\rpcping.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block rpcping.exe" program="%SystemRoot%\SysWOW64\rpcping.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block rundll32.exe" program="%SystemRoot%\System32\rundll32.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block rundll32.exe" program="%SystemRoot%\SysWOW64\rundll32.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block runonce.exe" program="%SystemRoot%\System32\runonce.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block runonce.exe" program="%SystemRoot%\SysWOW64\runonce.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block services.exe" program="%SystemRoot%\System32\services.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block services.exe" program="%SystemRoot%\SysWOW64\services.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block sc.exe" program="%SystemRoot%\System32\sc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block sc.exe" program="%SystemRoot%\SysWOW64\sc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block schtasks.exe" program="%SystemRoot%\System32\schtasks.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block schtasks.exe" program="%SystemRoot%\SysWOW64\schtasks.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block scriptrunner.exe" program="%SystemRoot%\System32\scriptrunner.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block scriptrunner.exe" program="%SystemRoot%\SysWOW64\scriptrunner.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block SyncAppvPublishingServer.exe" program="%SystemRoot%\System32\SyncAppvPublishingServer.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block SyncAppvPublishingServer.exe" program="%SystemRoot%\SysWOW64\SyncAppvPublishingServer.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block telnet.exe" program="%SystemRoot%\System32\telnet.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block telnet.exe" program="%SystemRoot%\SysWOW64\telnet.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block tftp.exe" program="%SystemRoot%\System32\tftp.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block tftp.exe" program="%SystemRoot%\SysWOW64\tftp.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ttdinject.exe" program="%SystemRoot%\System32\ttdinject.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block ttdinject.exe" program="%SystemRoot%\SysWOW64\ttdinject.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block tttracer.exe" program="%SystemRoot%\System32\tttracer.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block tttracer.exe" program="%SystemRoot%\SysWOW64\tttracer.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block vbc.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v4.0.30319\vbc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block vbc.exe" program="%SystemRoot%\Microsoft.NET\Framework64\v3.5\vbc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block verclsid.exe" program="%SystemRoot%\System32\verclsid.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block verclsid.exe" program="%SystemRoot%\SysWOW64\verclsid.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wab.exe" program="%ProgramFiles%\Windows Mail\wab.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wab.exe" program="%ProgramFiles(x86)%\Windows Mail\wab.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block WerFault.exe" program="%SystemRoot%\SysWOW64\WerFault.exe" protocol=any dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block WerFault.exe" program="%SystemRoot%\SysWOW64\WerFault.exe" protocol=any dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wininit.exe" program="%SystemRoot%\System32\wininit.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wininit.exe" program="%SystemRoot%\SysWOW64\wininit.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block winlogon.exe" program="%SystemRoot%\System32\winlogon.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block winlogon.exe" program="%SystemRoot%\SysWOW64\winlogon.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wmic.exe" program="%SystemRoot%\System32\wbem\wmic.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wmic.exe" program="%SystemRoot%\SysWOW64\wbem\wmic.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wordpad.exe" program="%ProgramFiles%\Windows NT\accessories\wordpad.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wordpad.exe" program="%ProgramFiles(x86)%\Windows NT\accessories\wordpad.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wscript.exe" program="%SystemRoot%\System32\wscript.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wscript.exe" program="%SystemRoot%\SysWOW64\wscript.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wsreset.exe" program="%SystemRoot%\System32\wsreset.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block wsreset.exe" program="%SystemRoot%\SysWOW64\wsreset.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block xwizard.exe" program="%SystemRoot%\System32\xwizard.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block xwizard.exe" program="%SystemRoot%\SysWOW64\xwizard.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block FancyCcV.exe" program="%ProgramFiles(x86)%\PrimoCache\FancyCcV.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block fcsetup.exe" program="%ProgramFiles(x86)%\PrimoCache\fcsetup.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="Block rxpcc.exe" program="%ProgramFiles(x86)%\PrimoCache\rxpcc.exe" dir=out enable=yes action=block profile=any 1>> %logfile% 2>>&1
		rem Áëîêèðîâêà òåëåìåòðèè
		netsh advfirewall firewall add rule name="telemetry_vortex.data.microsoft.com" dir=out action=block remoteip=191.232.139.254 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_telecommand.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.92 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_oca.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.63 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_sqm.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.93 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_watson.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.43,65.52.108.29 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_redir.metaservices.microsoft.com" dir=out action=block remoteip=194.44.4.200,194.44.4.208 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_choice.microsoft.com" dir=out action=block remoteip=157.56.91.77 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.7 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_reports.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.91 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.93 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_services.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.92 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_sqm.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.94 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.9 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_watson.ppe.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.11 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_telemetry.appex.bing.net" dir=out action=block remoteip=168.63.108.233 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_telemetry.urs.microsoft.com" dir=out action=block remoteip=157.56.74.250 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_settings-sandbox.data.microsoft.com" dir=out action=block remoteip=111.221.29.177 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_vortex-sandbox.data.microsoft.com" dir=out action=block remoteip=64.4.54.32 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_survey.watson.microsoft.com" dir=out action=block remoteip=207.68.166.254 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_watson.live.com" dir=out action=block remoteip=207.46.223.94 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_watson.microsoft.com" dir=out action=block remoteip=65.55.252.71 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_statsfe2.ws.microsoft.com" dir=out action=block remoteip=64.4.54.22 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_corpext.msitadfs.glbdns2.microsoft.com" dir=out action=block remoteip=131.107.113.238 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_compatexchange.cloudapp.net" dir=out action=block remoteip=23.99.10.11 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_cs1.wpc.v0cdn.net" dir=out action=block remoteip=68.232.34.200 enable=no profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_a-0001.a-msedge.net" dir=out action=block remoteip=204.79.197.200 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_statsfe2.update.microsoft.com.akadns.net" dir=out action=block remoteip=64.4.54.22 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_sls.update.microsoft.com.akadns.net" dir=out action=block remoteip=157.56.77.139 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_fe2.update.microsoft.com.akadns.net" dir=out action=block remoteip=134.170.58.121,134.170.58.123,134.170.53.29,66.119.144.190,134.170.58.189,134.170.58.118,134.170.53.30,134.170.51.190 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_diagnostics.support.microsoft.com" dir=out action=block remoteip=157.56.121.89 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_corp.sts.microsoft.com" dir=out action=block remoteip=131.107.113.238 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_statsfe1.ws.microsoft.com" dir=out action=block remoteip=134.170.115.60 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_pre.footprintpredict.com" dir=out action=block remoteip=204.79.197.200 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_i1.services.social.microsoft.com" dir=out action=block remoteip=104.82.22.249 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_feedback.windows.com" dir=out action=block remoteip=134.170.185.70 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_feedback.microsoft-hohm.com" dir=out action=block remoteip=64.4.6.100,65.55.39.10 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_feedback.search.microsoft.com" dir=out action=block remoteip=157.55.129.21 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_rad.msn.com" dir=out action=block remoteip=207.46.194.25 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_preview.msn.com" dir=out action=block remoteip=23.102.21.4 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_dart.l.doubleclick.net" dir=out action=block remoteip=173.194.113.220,173.194.113.219,216.58.209.166 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_ads.msn.com" dir=out action=block remoteip=157.56.91.82,157.56.23.91,104.82.14.146,207.123.56.252,185.13.160.61,8.254.209.254 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_a.ads1.msn.com" dir=out action=block remoteip=198.78.208.254,185.13.160.61 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_global.msads.net.c.footprint.net" dir=out action=block remoteip=185.13.160.61,8.254.209.254,207.123.56.252 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_az361816.vo.msecnd.net" dir=out action=block remoteip=68.232.34.200 enable=no profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_oca.telemetry.microsoft.com.nsatc.net" dir=out action=block remoteip=65.55.252.63 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_reports.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.91 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.7 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_cs1.wpc.v0cdn.net" dir=out action=block remoteip=68.232.34.200 enable=no profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_vortex-sandbox.data.microsoft.com" dir=out action=block remoteip=64.4.54.32 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_pre.footprintpredict.com" dir=out action=block remoteip=204.79.197.200 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_i1.services.social.microsoft.com" dir=out action=block remoteip=104.82.22.249 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_ssw.live.com" dir=out action=block remoteip=207.46.101.29 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_statsfe1.ws.microsoft.com" dir=out action=block remoteip=134.170.115.60 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_msnbot-65-55-108-23.search.msn.com" dir=out action=block remoteip=65.55.108.23 enable=yes profile=any 1>> %logfile% 2>>&1
		netsh advfirewall firewall add rule name="telemetry_a23-218-212-69.deploy.static.akamaitechnologies.com" dir=out action=block remoteip=23.218.212.69 enable=yes profile=any 1>> %logfile% 2>>&1
		set timerEnd=!time!
		call :timer
		@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
		echo. 1>> %logfile%
	)
)
@echo %clr%[36m Óñòàíîâèòü ôàéë Hosts îò Energized Spark, áëîêèðóþùèé ðåêëàìó, òåëåìåòðèþ, ïîðíîñàéòû è âðåäîíîñíûå õîñòû?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÓñòàíîâêà ôàéëà Hosts îò Energized Spark, áëîêèðóþùèé ðåêëàìó, òåëåìåòðèþ, ïîðíîñàéòû è âðåäîíîñíûå õîñòû. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Óñòàíîâêà ôàéëà Hosts îò Energized Spark, áëîêèðóþùèé ðåêëàìó, òåëåìåòðèþ, ïîðíîñàéòû è âðåäîíîñíûå õîñòû. 1>> %logfile%
	set timerStart=!time!
	copy "%SystemRoot%\System32\drivers\etc\hosts" "%~dp0..\..\Backup\Backup_hosts_file_%daytime%.txt" 1>> %logfile% 2>>&1
	::curl -fSLo "%SystemRoot%\System32\drivers\etc\hosts" "https://block.energized.pro/spark/formats/hosts.txt"
	%PS% "Invoke-WebRequest https://block.energized.pro/spark/formats/hosts.txt -OutFile $Env:SystemRoot\System32\drivers\etc\hosts" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Äîáàâèòü ÷åðíûé ñïèñîê òåëåìåòðèè â ôàéë hosts è ïðàâèëà ôàéåðâîëà?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÄîáàâëåíèå ÷åðíîãî ñïèñêà òåëåìåòðèè â ôàéë hosts è ïðàâèëà ôàéåðâîëà. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Äîáàâëåíèå ÷åðíîãî ñïèñêà òåëåìåòðèè â ôàéë hosts è ïðàâèëà ôàéåðâîëà. 1>> %logfile%
	set timerStart=!time!
	%PS% "%~dp0BlacklistTelemetry.ps1" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Äîáàâèòü AdGuard DoH ïðîâàéäåðû äëÿ ôèëüòðàöèè ðåêëàìû? DoH ïðîòîêîë îáëàäàåò áîëåå âûñîêîé íàä¸æíîñòüþ ïî ñðàâíåíèþ ñ DNSCrypt.%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÄîáàâëåíèå AdGuard DoH ïðîâàéäåðîâ äëÿ ôèëüòðàöèè ðåêëàìû. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Äîáàâëåíèå AdGuard DoH ïðîâàéäåðîâ äëÿ ôèëüòðàöèè ðåêëàìû. DoH ïðîòîêîë îáëàäàåò áîëåå âûñîêîé íàä¸æíîñòüþ ïî ñðàâíåíèþ ñ DNSCrypt. 1>> %logfile%
	set timerStart=!time!
	netsh dns add encryption server=94.140.14.14 dohtemplate=https://dns.adguard.com/dns-query 1>> %logfile% 2>>&1
	netsh dns add encryption server=94.140.15.15 dohtemplate=https://dns.adguard.com/dns-query 1>> %logfile% 2>>&1
	netsh dns add encryption server=2a10:50c0::ad1:ff dohtemplate=https://dns.adguard.com/dns-query 1>> %logfile% 2>>&1
	netsh dns add encryption server=2a10:50c0::ad2:ff dohtemplate=https://dns.adguard.com/dns-query 1>> %logfile% 2>>&1
	rem netsh dns add encryption server=94.140.14.15 dohtemplate=https://dns-family.adguard.com/dns-query 1>> %logfile% 2>>&1
	rem netsh dns add encryption server=94.140.15.16 dohtemplate=https://dns-family.adguard.com/dns-query 1>> %logfile% 2>>&1
	rem netsh dns add encryption server=2a10:50c0::bad1:ff dohtemplate=https://dns-family.adguard.com/dns-query 1>> %logfile% 2>>&1
	rem netsh dns add encryption server=2a10:50c0::bad2:ff dohtemplate=https://dns-family.adguard.com/dns-query 1>> %logfile% 2>>&1
	rem netsh dns add encryption server=94.140.14.140 dohtemplate=https://dns-unfiltered.adguard.com/dns-query 1>> %logfile% 2>>&1
	rem netsh dns add encryption server=94.140.14.141 dohtemplate=https://dns-unfiltered.adguard.com/dns-query 1>> %logfile% 2>>&1
	rem netsh dns add encryption server=2a10:50c0::1:ff dohtemplate=https://dns-unfiltered.adguard.com/dns-query 1>> %logfile% 2>>&1
	rem netsh dns add encryption server=2a10:50c0::2:ff dohtemplate=https://dns-unfiltered.adguard.com/dns-query 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Îòêëþ÷èòü ôîðìèðîâàíèå îòçûâîâ.%clr%[92m
@echo Îòêëþ÷èòü ôîðìèðîâàíèå îòçûâîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f 1>> %logfile% 2>>&1
call :disable_task "\Microsoft\Windows\Feedback\Siuf\DmClient"
call :disable_task "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Çàïðåòèòü ïðèëîæåíèÿì íà äðóãèõ óñòðîéñòâàõ çàïóñêàòü ïðèëîæåíèÿ è îòïðàâëÿòü ñîîáùåíèÿ íà ýòîì óñòðîéñòâå.%clr%[92m
@echo Çàïðåòèòü ïðèëîæåíèÿì íà äðóãèõ óñòðîéñòâàõ çàïóñêàòü ïðèëîæåíèÿ è îòïðàâëÿòü ñîîáùåíèÿ íà ýòîì óñòðîéñòâå. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v "RomeSdkChannelUserAuthzPolicy" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Íå ïðåäëàãàòü ñïîñîá çàâåðøåíèÿ íàñòðîéêè óñòðîéñòâà.%clr%[92m
@echo Íå ïðåäëàãàòü ñïîñîá çàâåðøåíèÿ íàñòðîéêè óñòðîéñòâà. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Íå ïðåäëàãàòü èíäèâèäóàëüíûé ïîäõîä, îñíîâàííûé íà íàñòðîéêàõ äèàãíîñòè÷åñêèõ äàííûõ.%clr%[92m
@echo Íå ïðåäëàãàòü èíäèâèäóàëüíûé ïîäõîä, îñíîâàííûé íà íàñòðîéêàõ äèàãíîñòè÷åñêèõ äàííûõ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïîêàçàòü çíà÷îê «Ýòîò êîìïüþòåð» íà ðàáî÷åì ñòîëå.%clr%[92m
@echo Ïîêàçàòü çíà÷îê «Ýòîò êîìïüþòåð» íà ðàáî÷åì ñòîëå. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïîêàçàòü ðàñøèðåíèÿ äëÿ ôàéëîâ.%clr%[92m
@echo Ïîêàçàòü ðàñøèðåíèÿ äëÿ ôàéëîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" /v "CheckedValue" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïîêàçàòü êîíôëèêòû ñëèÿíèÿ ïàïîê.%clr%[92m
@echo Ïîêàçàòü êîíôëèêòû ñëèÿíèÿ ïàïîê. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideMergeConflicts" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Çàïðåòèòü ñìåíó ðåãèñòðà èìåí ôàéëîâ â ïðîâîäíèêå.%clr%[92m
@echo Çàïðåòèòü ñìåíó ðåãèñòðà èìåí ôàéëîâ â ïðîâîäíèêå. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DontPrettyPath" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óäàëèòü «Áèáëèîòåêè» èç ïàíåëè íàâèãàöèè ïðîâîäíèêà.%clr%[92m
@echo Óäàëèòü «Áèáëèîòåêè» èç ïàíåëè íàâèãàöèè ïðîâîäíèêà. 1>> %logfile%
set timerStart=!time!
%rgd% "HKCU\SOFTWARE\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}" /v "System.IsPinnedToNameSpaceTree" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü âîññòàíîâëåíèå îòêðûòûõ îêîí ïðîâîäíèêà ïðè âõîäå â ñèñòåìó.%clr%[92m
@echo Âêëþ÷èòü âîññòàíîâëåíèå îòêðûòûõ îêîí ïðîâîäíèêà ïðè âõîäå â ñèñòåìó. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "PersistBrowsers" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü êíîïêó «Ëþäè» íà ïàíåëè çàäà÷.%clr%[92m
@echo Ñêðûòü êíîïêó «Ëþäè» íà ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïîêàçûâàòü ñåêóíäû íà ÷àñàõ ïàíåëè çàäà÷.%clr%[92m
@echo Ïîêàçûâàòü ñåêóíäû íà ÷àñàõ ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSecondsInSystemClock" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòîáðàæàòü ìàëåíüêèå çíà÷êè íà ïàíåëè çàäà÷.%clr%[92m
@echo Îòîáðàæàòü ìàëåíüêèå çíà÷êè íà ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêðûâàòü ïðîâîäíèê äëÿ «Ýòîò êîìïüþòåð».%clr%[92m
@echo Îòêðûâàòü ïðîâîäíèê äëÿ «Ýòîò êîìïüþòåð». 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Çàïóñêàòü îêíà ïðîâîäíèêà êàê îòäåëüíûå ïðîöåññû.%clr%[92m
@echo Çàïóñêàòü îêíà ïðîâîäíèêà êàê îòäåëüíûå ïðîöåññû. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü ïðåäâàðèòåëüíûé ïðîñìîòð ðàáî÷åãî ñòîëà íà êíîïêå «Ñâåðíóòü».%clr%[92m
@echo Âêëþ÷èòü ïðåäâàðèòåëüíûé ïðîñìîòð ðàáî÷åãî ñòîëà íà êíîïêå «Ñâåðíóòü». 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisablePreviewDesktop" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü êíîïêó «Ïðåäñòàâëåíèå çàäà÷».%clr%[92m
@echo Ñêðûòü êíîïêó «Ïðåäñòàâëåíèå çàäà÷». 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü ïðîçðà÷íîñòü ìåíþ Ïóñê, ïàíåëè çàäà÷.%clr%[92m
@echo Âêëþ÷èòü ïðîçðà÷íîñòü ìåíþ Ïóñê, ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óâåëè÷èòü ïðîçðà÷íîñòü ïàíåëè çàäà÷.%clr%[92m
@echo Óâåëè÷èòü ïðîçðà÷íîñòü ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "UseOLEDTaskbarTransparency" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü ïðîçðà÷íîñòü êîìàíäíîé ñòðîêè è Powershell.%clr%[92m
@echo Âêëþ÷èòü ïðîçðà÷íîñòü êîìàíäíîé ñòðîêè è Powershell. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\Console" /v "WindowAlpha" /t REG_DWORD /d "206" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "WindowAlpha" /t REG_DWORD /d "206" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Console\%%SystemRoot%%_System32_WindowsPowerShell_v1.0_powershell.exe" /v "WindowAlpha" /t REG_DWORD /d "206" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Console\%%SystemRoot%%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" /v "WindowAlpha" /t REG_DWORD /d "206" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïîêàçàòü âñå ïàïêè íà ïàíåëè ïðîâîäíèêà.%clr%[92m
@echo Ïîêàçàòü âñå ïàïêè íà ïàíåëè ïðîâîäíèêà. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneShowAllFolders" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêðûâàòü ïîñëåäíåå àêòèâíîå îêíî íà ïàíåëè çàäà÷.%clr%[92m
@echo Îòêðûâàòü ïîñëåäíåå àêòèâíîå îêíî íà ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LastActiveClick" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïàíåëü ìåíþ â ïðîâîäíèêå.%clr%[92m
@echo Ñêðûòü ïàíåëü ìåíþ â ïðîâîäíèêå. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "AlwaysShowMenus" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïîñëåäíèå îòêðûòûå ýëåìåíòû â ìåíþ Ïóñê è ïàíåëè çàäà÷.%clr%[92m
@echo Ñêðûòü ïîñëåäíèå îòêðûòûå ýëåìåíòû â ìåíþ Ïóñê è ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòîáðàæàòü ìàëåíüêèå èêîíêè â ìåíþ Ïóñê.%clr%[92m
@echo Îòîáðàæàòü ìàëåíüêèå èêîíêè â ìåíþ Ïóñê. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_LargeMFUIcons" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óâåëè÷èòü êýø ïàìÿòè äëÿ âèäà ïàïîê.%clr%[92m
@echo Óâåëè÷èòü êýø ïàìÿòè äëÿ âèäà ïàïîê. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell" /v "BagMRU Size" /t REG_DWORD /d "20000" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïàïêó «Âèäåî» èç «Ýòîò êîìïüþòåð».%clr%[92m
@echo Ñêðûòü ïàïêó «Âèäåî» èç «Ýòîò êîìïüþòåð». 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïàïêó «Äîêóìåíòû» èç «Ýòîò êîìïüþòåð».%clr%[92m
@echo Ñêðûòü ïàïêó «Äîêóìåíòû» èç «Ýòîò êîìïüþòåð». 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïàïêó «Çàãðóçêè» èç «Ýòîò êîìïüþòåð».%clr%[92m
@echo Ñêðûòü ïàïêó «Çàãðóçêè» èç «Ýòîò êîìïüþòåð». 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïàïêó «Èçîáðàæåíèÿ» èç «Ýòîò êîìïüþòåð».%clr%[92m
@echo Ñêðûòü ïàïêó «Èçîáðàæåíèÿ» èç «Ýòîò êîìïüþòåð». 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïàïêó «Ìóçûêà» èç «Ýòîò êîìïüþòåð».%clr%[92m
@echo Ñêðûòü ïàïêó «Ìóçûêà» èç «Ýòîò êîìïüþòåð». 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïàïêó «Ðàáî÷èé ñòîë» èç «Ýòîò êîìïüþòåð».%clr%[92m
@echo Ñêðûòü ïàïêó «Ðàáî÷èé ñòîë» èç «Ýòîò êîìïüþòåð». 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïàïêó «3D-îáúåêòû» èç «Ýòîò êîìïüþòåð».%clr%[92m
@echo Ñêðûòü ïàïêó «3D-îáúåêòû» èç «Ýòîò êîìïüþòåð». 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óäàëèòü âñå ïàïêè èç ìåíþ «Ýòîò êîìïüþòåð».%clr%[92m
@echo Óäàëèòü âñå ïàïêè èç ìåíþ «Ýòîò êîìïüþòåð». 1>> %logfile%
set timerStart=!time!
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ëåíòó â ïðîâîäíèêå.%clr%[92m
@echo Ñêðûòü ëåíòó â ïðîâîäíèêå. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v "MinimizedStateTabletModeOff" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óäàëèòü ïóíêòû êîíòåêñòíîãî ìåíþ «Çàêðåïèòü íà íà÷àëüíîì ýêðàíå», «Çàêðåïèòü íà ïàíåëè áûñòðîãî äîñòóïà», «Îòïðàâèòü» (ïîäåëèòüñÿ).%clr%[92m
@echo Óäàëèòü ïóíêòû êîíòåêñòíîãî ìåíþ «Çàêðåïèòü íà íà÷àëüíîì ýêðàíå», «Çàêðåïèòü íà ïàíåëè áûñòðîãî äîñòóïà», «Îòïðàâèòü» (ïîäåëèòüñÿ). 1>> %logfile%
set timerStart=!time!
%rgd% "HKCR\Folder\shellex\ContextMenuHandlers\Library Location" /f 1>> %logfile% 2>>&1
%rgd% "HKCR\Folder\shellex\ContextMenuHandlers\PintoStartScreen" /f 1>> %logfile% 2>>&1
call :trusted_app %rgd% HKCR\Launcher.AllAppsDesktopApplication\shellex\ContextMenuHandlers\PintoStartScreen /f
call :trusted_app %rgd% HKCR\Launcher.Computer\shellex\ContextMenuHandlers\PintoStartScreen /f
call :trusted_app %rgd% HKCR\Launcher.DesktopPackagedApplication\shellex\ContextMenuHandlers\PintoStartScreen /f
%rgd% "HKCR\Launcher.DualModeApplication\shellex\ContextMenuHandlers\PintoStartScreen" /f 1>> %logfile% 2>>&1
call :trusted_app %rgd% HKCR\Launcher.ImmersiveApplication\shellex\ContextMenuHandlers\PintoStartScreen /f
call :trusted_app %rgd% HKCR\Launcher.SystemSettings\shellex\ContextMenuHandlers\PintoStartScreen /f
%rgd% "HKCR\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen" /f 1>> %logfile% 2>>&1
%rgd% "HKCR\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" /f 1>> %logfile% 2>>&1
%rgd% "HKCR\exefile\shellex\ContextMenuHandlers\PintoStartScreen" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\exefile\shellex\ContextMenuHandlers\PintoStartScreen" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\Library Location" /f 1>> %logfile% 2>>&1
call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Launcher.AllAppsDesktopApplication\shellex\ContextMenuHandlers\PintoStartScreen /f
call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Launcher.Computer\shellex\ContextMenuHandlers\PintoStartScreen /f
call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Launcher.DesktopPackagedApplication\shellex\ContextMenuHandlers\PintoStartScreen /f
%rgd% "HKLM\SOFTWARE\Classes\Launcher.DualModeApplication\shellex\ContextMenuHandlers\PintoStartScreen" /f 1>> %logfile% 2>>&1
call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Launcher.ImmersiveApplication\shellex\ContextMenuHandlers\PintoStartScreen /f
call :trusted_app %rgd% HKLM\SOFTWARE\Classes\Launcher.SystemSettings\shellex\ContextMenuHandlers\PintoStartScreen /f
%rgd% "HKLM\SOFTWARE\Classes\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" /f 1>> %logfile% 2>>&1
call :trusted_app %rgd% HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Windows.PinToHome /f
call :trusted_app %rgd% HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Windows.pintostartscreen /f
%rgd% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Windows.PinToHome" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Windows.pintostartscreen" /f 1>> %logfile% 2>>&1
%rgd% "HKCR\Folder\shell\pintohome" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\Folder\shell\pintohome" /f 1>> %logfile% 2>>&1
%rgd% "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\*\shellex\ContextMenuHandlers\ModernSharing" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âñåãäà îòîáðàæàòü äèàëîãîâîå îêíî ïåðåäà÷è ôàéëîâ â ïîäðîáíîì ðåæèìå.%clr%[92m
@echo Âñåãäà îòîáðàæàòü äèàëîãîâîå îêíî ïåðåäà÷è ôàéëîâ â ïîäðîáíîì ðåæèìå. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ïàíåëü áûñòðîãî äîñòóïà â ïðîâîäíèêå.%clr%[92m
@echo Ñêðûòü ïàíåëü áûñòðîãî äîñòóïà â ïðîâîäíèêå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü ÷àñòî èñïîëüçóåìûå ïàïêè è ôàéëû â ìåíþ áûñòðîãî äîñòóïà.%clr%[92m
@echo Ñêðûòü ÷àñòî èñïîëüçóåìûå ïàïêè è ôàéëû â ìåíþ áûñòðîãî äîñòóïà. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" /f 1>> %logfile% 2>>&1
if not "%arch%"=="x86" (
    %rgd% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïîìîùíèêà ïî ïðèâÿçêå íà ïàíåëè çàäà÷.%clr%[92m
@echo Îòêëþ÷èòü ïîìîùíèêà ïî ïðèâÿçêå íà ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SnapAssist" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü êíîïêó «Ïîèñê» íà ïàíåëè çàäà÷.%clr%[92m
@echo Ñêðûòü êíîïêó «Ïîèñê» íà ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü êíîïêó «Windows Ink Workspace» íà ïàíåëè çàäà÷.%clr%[92m
@echo Ñêðûòü êíîïêó «Windows Ink Workspace» íà ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" /v "PenWorkspaceButtonDesiredVisibility" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü êíîïêó «Mail» íà ïàíåëè çàäà÷.%clr%[92m
@echo Ñêðûòü êíîïêó «Mail» íà ïàíåëè çàäà÷. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Taskband\AuxilliaryPins" /v "MailPin" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband\AuxilliaryPins" /v "MailPin" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü çíà÷îê «MeetNow» â îáëàñòè óâåäîìëåíèé.%clr%[92m
@echo Ñêðûòü çíà÷îê «MeetNow» â îáëàñòè óâåäîìëåíèé. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòîáðàæàòü çíà÷êè Êîìïüþòåð è Ïàíåëü óïðàâëåíèÿ íà ðàáî÷åì ñòîëå äëÿ âñåõ ïîëüçîâàòåëåé.%clr%[92m
@echo Îòîáðàæàòü çíà÷êè Êîìïüþòåð è Ïàíåëü óïðàâëåíèÿ íà ðàáî÷åì ñòîëå äëÿ âñåõ ïîëüçîâàòåëåé. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûñòàâèòü ïðîñìîòð çíà÷êîâ ïàíåëè óïðàâëåíèÿ ïî êàòåãîðèÿì.%clr%[92m
@echo Âûñòàâèòü ïðîñìîòð çíà÷êîâ ïàíåëè óïðàâëåíèÿ ïî êàòåãîðèÿì. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" /v "AllItemsIconView" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel" /v "StartupPage" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü àíèìàöèþ ïåðâîãî âõîäà ïîñëå îáíîâëåíèÿ.%clr%[92m
@echo Ñêðûòü àíèìàöèþ ïåðâîãî âõîäà ïîñëå îáíîâëåíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableFirstLogonAnimation" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "EnableFirstLogonAnimation" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûñòàâèòü ìàêñèìàëüíîå êà÷åñòâî îáîåâ äëÿ ðàáî÷åãî ñòîëà â ôîðìàòå JPEG.%clr%[92m
@echo Âûñòàâèòü ìàêñèìàëüíîå êà÷åñòâî îáîåâ äëÿ ðàáî÷åãî ñòîëà â ôîðìàòå JPEG. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñäåëàòü ðàáî÷èé ñòîë îòçûâ÷èâûì.%clr%[92m
@echo Ñäåëàòü ðàáî÷èé ñòîë îòçûâ÷èâûì. 1>> %logfile%
set timerStart=!time!
%rga% "HKU\.DEFAULT\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_SZ /d "186" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Accessibility\MouseKeys" /v "MaximumSpeed" /t REG_SZ /d "40" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Accessibility\MouseKeys" /v "TimeToMaximumSpeed" /t REG_SZ /d "3000" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Accessibility\TimeOut" /v "Flags" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Desktop" /v "ForegroundLockTimeout" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "50" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Desktop" /v "MouseWheelRouting" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v "CompositionPolicy" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Accessibility\HighContrast" /v "Flags" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_SZ /d "186" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Accessibility\MouseKeys" /v "MaximumSpeed" /t REG_SZ /d "40" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Accessibility\MouseKeys" /v "TimeToMaximumSpeed" /t REG_SZ /d "3000" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Accessibility\SoundSentry" /v "Flags" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Accessibility\TimeOut" /v "Flags" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Desktop" /v "ForegroundLockTimeout" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "50" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Desktop" /v "MouseWheelRouting" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "CompositionPolicy" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Íàñòðîèòü çàïóñê äèñïåò÷åðà çàäà÷ â ðàçâåðíóòîì ðåæèìå.%clr%[92m
@echo Íàñòðîèòü çàïóñê äèñïåò÷åðà çàäà÷ â ðàçâåðíóòîì ðåæèìå. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager" /v "Preferences" /t REG_BINARY /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü êîíòðîëü çà ñâîáîäíûì ïðîñòðàíñòâîì æåñòêèõ äèñêîâ.%clr%[92m
@echo Îòêëþ÷èòü êîíòðîëü çà ñâîáîäíûì ïðîñòðàíñòâîì æåñòêèõ äèñêîâ. 1>> %logfile%
set timerStart=!time!
call :disable_task "Microsoft\Windows\DiskFootprint\StorageSense"
%PS% "Remove-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Recurse" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óäàëÿòü íå èñïîëüçóåìûå âðåìåííûå ôàéëû. Áóäåò ïðèìåíÿòüñÿ, åñëè âêëþ÷åí êîíòðîëü çà ñâîáîäíûì ïðîñòðàíñòâîì.%clr%[92m
@echo Óäàëÿòü íå èñïîëüçóåìûå âðåìåííûå ôàéëû. Áóäåò ïðèìåíÿòüñÿ, åñëè âêëþ÷åí êîíòðîëü çà ñâîáîäíûì ïðîñòðàíñòâîì. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v "04" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü ïóòè NTFS äëèíîé áîëåå 260 ñèìâîëîâ.%clr%[92m
@echo Âêëþ÷èòü ïóòè NTFS äëèíîé áîëåå 260 ñèìâîëîâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòîáðàæàòü èíôîðìàöèþ î Stop îøèáêàõ íà BSOD.%clr%[92m
@echo Îòîáðàæàòü èíôîðìàöèþ î Stop îøèáêàõ íà BSOD. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü îïòèìèçàöèþ äîñòàâêè.%clr%[92m
@echo Îòêëþ÷èòü îïòèìèçàöèþ äîñòàâêè. 1>> %logfile%
set timerStart=!time!
%rga% "HKU\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Çàìåíèòü ìåòîä ââîäà ïî óìîë÷àíèþ íà àíãëèéñêèé.%clr%[92m
@echo Çàìåíèòü ìåòîä ââîäà ïî óìîë÷àíèþ íà àíãëèéñêèé. 1>> %logfile%
set timerStart=!time!
%PS% "Set-WinDefaultInputMethodOverride -InputTip '0409:00000409'" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Çàïðîñ ïîäòâåðæäåíèÿ ïåðåä çàïóñêîì ñðåäñòâà óñòðàíåíèÿ íåïîëàäîê.%clr%[92m
@echo Çàïðîñ ïîäòâåðæäåíèÿ ïåðåä çàïóñêîì ñðåäñòâà óñòðàíåíèÿ íåïîëàäîê. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\WindowsMitigation" /v "UserPreference" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàïóñêà ýêðàííîãî äèêòîðà è ôóíêöèè ðàñïîçíàâàíèÿ ãîëîñà.%clr%[92m
@echo Îòêëþ÷èòü çàïóñêà ýêðàííîãî äèêòîðà è ôóíêöèè ðàñïîçíàâàíèÿ ãîëîñà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Narrator.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\sapisvr.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SpeechUXWiz.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ñêðûòü èíñàéäåðñêóþ ñòðàíèöó.%clr%[92m
@echo Ñêðûòü èíñàéäåðñêóþ ñòðàíèöó. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility" /v "HideInsiderPage" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü è óäàëèòü çàðåçåðâèðîâàííîå õðàíèëèùå (òîëüêî äëÿ ñáîðîê 20H1 è âûøå).%clr%[92m
@echo Îòêëþ÷èòü è óäàëèòü çàðåçåðâèðîâàííîå õðàíèëèùå (òîëüêî äëÿ ñáîðîê 20H1 è âûøå). 1>> %logfile%
set timerStart=!time!
dism /online /Set-ReservedStorageState /State:Disabled 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü àêòèâàöèþ óñòðîéñòâ ðàñøèðåííîãî õðàíèëèùà.%clr%[92m
@echo Îòêëþ÷èòü àêòèâàöèþ óñòðîéñòâ ðàñøèðåííîãî õðàíèëèùà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\EnhancedStorageDevices" /v "TCGSecurityActivationDisabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü êëàâèøó ñïðàâêè F1 â ïðîâîäíèêå, íà ðàáî÷åì ñòîëå è îáðàòíóþ ñâÿçü ñî ñïðàâêîé.%clr%[92m
@echo Îòêëþ÷èòü êëàâèøó ñïðàâêè F1 â ïðîâîäíèêå, íà ðàáî÷åì ñòîëå è îáðàòíóþ ñâÿçü ñî ñïðàâêîé. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" /v "(default)" /t REG_BINARY /d "" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoExplicitFeedback" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoImplicitFeedback" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoOnlineAssist" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoActiveHelp" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïîêàçàòü ïîëíûé ïóòü ê êàòàëîãó â ñòðîêå çàãîëîâêà ïðîâîäíèêà.%clr%[92m
@echo Ïîêàçàòü ïîëíûé ïóòü ê êàòàëîãó â ñòðîêå çàãîëîâêà ïðîâîäíèêà. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" /v "FullPath" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü Num Lock ïðè çàïóñêå.%clr%[92m
@echo Âêëþ÷èòü Num Lock ïðè çàïóñêå. 1>> %logfile%
set timerStart=!time!
%rga% "HKU\.DEFAULT\Control Panel\Keyboard" /v "InitialKeyboardIndicators" /t REG_SZ /d "2147483650" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàëèïàíèå êëàâèø ïîñëå 5òè êðàòíîãî íàæàòèÿ êëàâèøè Shift.%clr%[92m
@echo Îòêëþ÷èòü çàëèïàíèå êëàâèø ïîñëå 5òè êðàòíîãî íàæàòèÿ êëàâèøè Shift. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "122" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "58" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "122" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f 1>> %logfile% 2>>&1
%rga% "HKU\.DEFAULT\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "58" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü àâòîçàïóñê äëÿ âñåõ íîñèòåëåé è óñòðîéñòâ.%clr%[92m
@echo Îòêëþ÷èòü àâòîçàïóñê äëÿ âñåõ íîñèòåëåé è óñòðîéñòâ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d "255" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü àâòîçàïóñê íå çàêðûòûõ ïðèëîæåíèé ïîñëå ïåðåçàãðóçêè èëè îáíîâëåíèÿ.%clr%[92m
@echo Âêëþ÷èòü àâòîçàïóñê íå çàêðûòûõ ïðèëîæåíèé ïîñëå ïåðåçàãðóçêè èëè îáíîâëåíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "RestartApps" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
for /f "tokens=* skip=1" %%n in ('wmic useraccount where "name='%username%'" get SID ^| findstr "."') do (set SID=%%n)
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\%SID%" /v "OptOut" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü àâòîíàñòðîéêó ÷àñîâ àêòèâíîñòè â çàâèñèìîñòè îò åæåäíåâíîãî èñïîëüçîâàíèÿ.%clr%[92m
@echo Îòêëþ÷èòü àâòîíàñòðîéêó ÷àñîâ àêòèâíîñòè â çàâèñèìîñòè îò åæåäíåâíîãî èñïîëüçîâàíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "SmartActiveHoursState" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïåðåçàãðóçêó äëÿ óñòàíîâêè îáíîâëåíèÿ.%clr%[92m
@echo Îòêëþ÷èòü ïåðåçàãðóçêó äëÿ óñòàíîâêè îáíîâëåíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "IsExpedited" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Âêëþ÷èòü ðåæèì ðàçðàáîò÷èêà?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå ðåæèìà ðàçðàáîò÷èêà. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå ðåæèìà ðàçðàáîò÷èêà. 1>> %logfile%
	set timerStart=!time!
	for /f "tokens=1 delims=" %%a in ('dism /Online /Get-Capabilities /Format:Table /English^| findstr /i /c:"Tools.DeveloperMode.Core"^| findstr /l "Not Persent"') do (dism /Online /Add-Capability /CapabilityName:"Tools.DeveloperMode.Core~~~~0.0.1.0" 1>> %logfile% 2>>&1)
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /v "AllowAllTrustedApps" /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /v "AllowDevelopmentWithoutDevLicense" /d "1" /f 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Çàãðóçèòü è óñòàíîâèòü NET Framework 3.5 âåðñèè?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÇàãðóçêà è óñòàíîâêà NET Framework 3.5 âåðñèè. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Çàãðóçêà è óñòàíîâêà NET Framework 3.5 âåðñèè. 1>> %logfile%
	set timerStart=!time!
	rem curl -fSLo "%~dp0dotnetcoresdk.exe" "https://download.visualstudio.microsoft.com/download/pr/674a9f7d-862e-4f92-91b6-f1cf3fed03ce/e07db4de77ada8da2c23261dfe9db138/dotnet-sdk-5.0.103-win-x64.exe"
	%PS% "Invoke-WebRequest 'https://download.visualstudio.microsoft.com/download/pr/674a9f7d-862e-4f92-91b6-f1cf3fed03ce/e07db4de77ada8da2c23261dfe9db138/dotnet-sdk-5.0.103-win-x64.exe' -OutFile '%~dp0dotnetcoresdk.exe'" 1>> %logfile% 2>>&1
	start /wait %~dp0dotnetcoresdk.exe /install /quiet /norestart
	%rf% "%~dp0dotnetcoresdk.exe" 1>> %logfile% 2>>&1
	rem curl -fSLo "%~dp0microsoft-windows-netfx3.zip" "https://dotnetbinaries.blob.core.windows.net/dockerassets/microsoft-windows-netfx3-1909.zip"
	%PS% "Invoke-WebRequest 'https://dotnetbinaries.blob.core.windows.net/dockerassets/microsoft-windows-netfx3-1909.zip' -OutFile '%~dp0microsoft-windows-netfx3.zip'" 1>> %logfile% 2>>&1
	%PS% "Expand-Archive -Force '%~dp0microsoft-windows-netfx3.zip' '%~dp0'" 1>> %logfile% 2>>&1
	%rf% "%~dp0microsoft-windows-netfx3.zip" 1>> %logfile% 2>>&1
	dism /Online /Enable-Feature /featurename:"NetFx3" /All /Source:"%~dp0microsoft-windows-netfx3-ondemand-package~31bf3856ad364e35~amd64~~.cab" /LimitAccess /norestart 1>> %logfile% 2>>&1
	%rf% "%~dp0microsoft-windows-netfx3-ondemand-package~31bf3856ad364e35~amd64~~.cab" 1>> %logfile% 2>>&1
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Windows-Identity-Foundation -NoRestart -All" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âêëþ÷èòü êîìïîíåíòû ïðåæíèõ âåðñèè?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå êîìïîíåíòîâ ïðåæíèõ âåðñèè. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå êîìïîíåíòîâ ïðåæíèõ âåðñèè. 1>> %logfile%
	set timerStart=!time!
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName LegacyComponents -NoRestart -All" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âêëþ÷èòü ïåñî÷íèöó?%clr%[92m
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå ïåñî÷íèöû. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå ïåñî÷íèöû. 1>> %logfile%
	set timerStart=!time!
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Containers -NoRestart -All" 1>> %logfile% 2>>&1
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM -NoRestart -All" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âêëþ÷èòü ïîäñèñòåìó Linux?%clr%[92m
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå ïîäñèñòåìû Linux. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå ïîäñèñòåìû Linux. 1>> %logfile%
	set timerStart=!time!
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -All" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âêëþ÷èòü ïëàòôîðìó âèðòóàëüíîé ìàøèíû?%clr%[92m
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå ïëàòôîðìû âèðòóàëüíîé ìàøèíû. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå ïëàòôîðìû âèðòóàëüíîé ìàøèíû. 1>> %logfile%
	set timerStart=!time!
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -All" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âêëþ÷èòü âèðòóàëüíóþ ïëàòôîðìó Hyper-V?%clr%[92m
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå âèðòóàëüíîé ïëàòôîðìû Hyper-V. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå âèðòóàëüíîé ïëàòôîðìû Hyper-V. 1>> %logfile%
	set timerStart=!time!
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName HypervisorPlatform -NoRestart -All" 1>> %logfile% 2>>&1
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart -All" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âêëþ÷èòü êîìïîíåíòû DirectPlay?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå êîìïîíåíòîâ DirectPlay. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå êîìïîíåíòîâ DirectPlay. 1>> %logfile%
	set timerStart=!time!
	%PS% "Enable-WindowsOptionalFeature -Online -FeatureName DirectPlay -NoRestart -All" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âêëþ÷èòü êîìïîíåíòû DirectX?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå êîìïîíåíòîâ DirectX. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå êîìïîíåíòîâ DirectX. 1>> %logfile%
	set timerStart=!time!
	for /f "tokens=1 delims=" %%a in ('dism /Online /Get-Capabilities /Format:Table /English^| findstr /i /c:"Tools.Graphics.DirectX"^| findstr /l "Not Persent"') do (
		dism /Online /Add-Capability /CapabilityName:"DirectX.Configuration.Database~~~~0.0.1.0" 1>> %logfile% 2>>&1
		dism /Online /Add-Capability /CapabilityName:"Tools.Graphics.DirectX~~~~0.0.1.0" 1>> %logfile% 2>>&1
	)
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âêëþ÷èòü êîìïîíåíòû äëÿ ðàáîòû ñ ìóëüòèìåäèà?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂêëþ÷åíèå êîìïîíåíòîâ äëÿ ðàáîòû ñ ìóëüòèìåäèà. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Âêëþ÷åíèå êîìïîíåíòîâ äëÿ ðàáîòû ñ ìóëüòèìåäèà. 1>> %logfile%
	set timerStart=!time!
	for /f "tokens=1 delims=" %%a in ('dism /Online /Get-Capabilities /Format:Table /English^| findstr /i /c:"MediaFeaturePack"^| findstr /l "Not Persent"') do (dism /Online /Add-Capability /CapabilityName:"Media.MediaFeaturePack~~~~0.0.1.0" 1>> %logfile% 2>>&1)
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Îòêëþ÷èòü óñòàðåâøèé ïðîòîêîë SMB 1.0 è Samba ñåðâåð?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÎòêëþ÷èòü óñòàðåâøèé íåáåçîïàñíûé ïðîòîêîë SMB 1.0 è Samba ñåðâåð. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Îòêëþ÷èòü óñòàðåâøèé íåáåçîïàñíûé ïðîòîêîë SMB 1.0 è Samba ñåðâåð. 1>> %logfile%
	set timerStart=!time!
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart" 1>> %logfile% 2>>&1
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Client -NoRestart" 1>> %logfile% 2>>&1
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Server -NoRestart" 1>> %logfile% 2>>&1
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol-Deprecation -NoRestart" 1>> %logfile% 2>>&1
	%PS% "Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force" 1>> %logfile% 2>>&1
	%PS% "Set-SmbServerConfiguration -EnableSMB2Protocol $true -Force" 1>> %logfile% 2>>&1
	call :delayed_svc mrxsmb
	call :disable_svc Mrxsmb10
	call :delayed_svc Mrxsmb20
	call :delayed_svc srv2
	%~dp0nvspbind_%arch%.exe /d * ms_server 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Îòêëþ÷èòü ñðåäñòâî çàïèñè XPS äîêóìåíòîâ, ïå÷àòü â PDF, êëèåíò ðàáî÷èõ ïàïîê è ñëóæáó ôàêñà?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÎòêëþ÷åíèå ñðåäñòâà çàïèñè XPS äîêóìåíòîâ, ïå÷àòü â PDF, êëèåíòà ðàáî÷èõ ïàïîê è ñëóæáû ôàêñà. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Îòêëþ÷åíèå ñðåäñòâà çàïèñè XPS äîêóìåíòîâ, ïå÷àòü â PDF, êëèåíòà ðàáî÷èõ ïàïîê è ñëóæáû ôàêñà. 1>> %logfile%
	set timerStart=!time!
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName Printing-XPSServices-Features -NoRestart -Remove" 1>> %logfile% 2>>&1
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName Printing-PrintToPDFServices-Features -NoRestart -Remove" 1>> %logfile% 2>>&1
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName WorkFolders-Client -NoRestart -Remove" 1>> %logfile% 2>>&1
	call :disable_svc workfolderssvc
	%PS% "Disable-WindowsOptionalFeature -Online -FeatureName FaxServicesClientPackage -NoRestart -Remove" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Óñòàíîâèòü áèáëèîòåêè Microsoft .NET è VC â ñèñòåìó äëÿ ïîääåðæêè ðàáîòû íåêîòîðûõ UWP ïðèëîæåíèè.%clr%[92m
@echo Óñòàíîâèòü áèáëèîòåêè Microsoft .NET è VC â ñèñòåìó äëÿ ïîääåðæêè ðàáîòû íåêîòîðûõ UWP ïðèëîæåíèè. 1>> %logfile%
set timerStart=!time!
	%PS% "Add-AppxPackage -Path '%~dp0Redist\Microsoft.NET.Native.Framework.1.7_1.7.27413.0_%arch%__8wekyb3d8bbwe.Appx'" 1>> %logfile% 2>>&1
	%PS% "Add-AppxPackage -Path '%~dp0Redist\Microsoft.NET.Native.Runtime.1.7_1.7.27422.0_%arch%__8wekyb3d8bbwe.Appx'" 1>> %logfile% 2>>&1
	%PS% "Add-AppxPackage -Path '%~dp0Redist\Microsoft.Services.Store.Engagement_10.0.19011.0_%arch%__8wekyb3d8bbwe.Appx'" 1>> %logfile% 2>>&1
	%PS% "Add-AppxPackage -Path '%~dp0Redist\Microsoft.Microsoft.VCLibs.140.00.UWPDesktop_14.0.30704.0_%arch%__8wekyb3d8bbwe.Appx'" 1>> %logfile% 2>>&1
	%PS% "Add-AppxPackage -Path '%~dp0Redist\Microsoft.VCLibs.140.00_14.0.30704.0_%arch%__8wekyb3d8bbwe.Appx'" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óñòàíîâèòü êîäåê äëÿ âîñïðîèçâåäåíèÿ âèäåî â ôîðìàòå High Efficiency Video Coding (HEVC) â ëþáîì âèäåîïðèëîæåíèè.%clr%[92m
@echo Óñòàíîâèòü êîäåê äëÿ âîñïðîèçâåäåíèÿ âèäåî â ôîðìàòå High Efficiency Video Coding (HEVC) â ëþáîì âèäåîïðèëîæåíèè. 1>> %logfile%
set timerStart=!time!
%PS% "Add-AppxPackage -Path '%~dp0Codecs\Microsoft.HEVCVideoExtension_1.0.50361.0_%arch%__8wekyb3d8bbwe.Appx'" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óñòàíîâèòü êîäåê äëÿ îòêðûòèÿ èçîáðàæåíèé èëè ìåäèàêîíòåéíåðîâ â ôîðìàòå High Efficiency Image File Format (HEIF) â ëþáîì ôîòîðåäàêòîðå.%clr%[92m
@echo Óñòàíîâèòü êîäåê äëÿ îòêðûòèÿ èçîáðàæåíèé èëè ìåäèàêîíòåéíåðîâ â ôîðìàòå High Efficiency Image File Format (HEIF) â ëþáîì ôîòîðåäàêòîðå. 1>> %logfile%
set timerStart=!time!
%PS% "Add-AppxPackage -Path '%~dp0Codecs\Microsoft.HEIFImageExtension_1.0.50272.0_%arch%__8wekyb3d8bbwe.Appx'" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü àóäèò ñîáûòèé, ãåíåðèðóåìûõ ïðè ñîçäàíèè èëè çàïóñêà ïðîöåññà.%clr%[92m
@echo Îòêëþ÷èòü àóäèò ñîáûòèé, ãåíåðèðóåìûõ ïðè ñîçäàíèè èëè çàïóñêà ïðîöåññà. 1>> %logfile%
set timerStart=!time!
auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Íå âêëþ÷àòü êîìàíäíóþ ñòðîêó â ñîáûòèÿ ñîçäàíèÿ ïðîöåññà.%clr%[92m
@echo Íå âêëþ÷àòü êîìàíäíóþ ñòðîêó â ñîáûòèÿ ñîçäàíèÿ ïðîöåññà. 1>> %logfile%
set timerStart=!time!
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" /v "ProcessCreationIncludeCmdLine_Enabled" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óäàëèòü ñîçäàíèå ñòðîêè Ñîçäàíèå ïðîöåññà â ïëàíèðîâùèêå ñîáûòèé.%clr%[92m
@echo Óäàëèòü ñîçäàíèå ñòðîêè Ñîçäàíèå ïðîöåññà â ïëàíèðîâùèêå ñîáûòèé. 1>> %logfile%
set timerStart=!time!
%PS% "Remove-Item -Path $env:ProgramData\'Microsoft\Event Viewer\Views\ProcessCreation.xml' -Force" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü âåäåíèå æóðíàëà äëÿ âñåõ ìîäóëåé Windows PowerShell.%clr%[92m
@echo Îòêëþ÷èòü âåäåíèå æóðíàëà äëÿ âñåõ ìîäóëåé Windows PowerShell. 1>> %logfile%
set timerStart=!time!
%rgd% "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging" /v "EnableModuleLogging" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v "EnableScriptBlockLogging" /f 1>> %logfile% 2>>&1
%PS% "Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames' -Name * -Force" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü äèñïåò÷åð âëîæåíèé, ïîìå÷àþùèé ôàéëû, çàãðóæåííûå èç Èíòåðíåòà, êàê íåáåçîïàñíûå.%clr%[92m
@echo Îòêëþ÷èòü äèñïåò÷åð âëîæåíèé, ïîìå÷àþùèé ôàéëû, çàãðóæåííûå èç Èíòåðíåòà, êàê íåáåçîïàñíûå. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /T REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "HideZoneInfoOnProperties" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Associations" /v "LowRiskFileTypes" /t REG_SZ /d ".zip;.rar;.nfo;.txt;.exe;.bat;.com;.cmd;.reg;.msi;.htm;.html;.gif;.bmp;.jpg;.avi;.mpg;.mpeg;.mov;.mp3;.m3u;.wav;" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü ïîääåðæêó TLS 1.2 äëÿ ñòàðûõ âåðñèé .NET Framework (äëÿ 4.6 è áîëåå ïîçäíèõ âåðñèé ïî óìîë÷àíèþ âêëþ÷åíî).%clr%[92m
@echo Âêëþ÷èòü ïîääåðæêó TLS 1.2 äëÿ ñòàðûõ âåðñèé .NET Framework (äëÿ 4.6 è áîëåå ïîçäíèõ âåðñèé ïî óìîë÷àíèþ âêëþ÷åíî). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" /v "SchUseStrongCrypto" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü Ìàãàçèí Windows. Íåîáõîäèì äëÿ ïîääåðæêè íåêîòîðûõ èãð è ïðèëîæåíèé.%clr%[92m
@echo Âêëþ÷èòü Ìàãàçèí Windows. Íåîáõîäèì äëÿ ïîääåðæêè íåêîòîðûõ èãð è ïðèëîæåíèé. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "DisableStoreApps" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "StoreAppsOnTaskbar" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Çàãðóæàòü îáíîâëåíèÿ Windows òîëüêî ñ óçëîâ ëîêàëüíîé ñåòè è ñåðâåðîâ Microsoft.%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m ïîëíîå îòêëþ÷åíèå ïðèâîäèò ê îøèáêå ïðè çàãðóçêå ñ ìàãàçèíà Windows.
@echo Çàãðóæàòü îáíîâëåíèÿ Windows òîëüêî ñ óçëîâ ëîêàëüíîé ñåòè è ñåðâåðîâ Microsoft. Ïðåäóïðåæäåíèå: ïîëíîå îòêëþ÷åíèå ïðèâîäèò ê îøèáêå ïðè çàãðóçêå ñ ìàãàçèíà Windows. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïðîåöèðîâàíèå (ïîäêëþ÷åíèå) ê óñòðîéñòâó è çàïðîñà ïèí-êîäà äëÿ ñîïðÿæåíèÿ.%clr%[92m
@echo Îòêëþ÷èòü ïðîåöèðîâàíèå (ïîäêëþ÷åíèå) ê óñòðîéñòâó è çàïðîñà ïèí-êîäà äëÿ ñîïðÿæåíèÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "AllowProjectionToPC" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "RequirePinForPairing" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\WirelessDisplay" /v "EnforcePinBasedPairing" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\PresentationSettings" /v "NoPresentationSettings" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü Windows Spotlight äëÿ îáåñïå÷åíèÿ êîíôèäåíöèàëüíîñòè (âêëþ÷àåò ñëó÷àéíûå îáîè íà ýêðàíå áëîêèðîâêè).%clr%[92m
@echo Îòêëþ÷èòü Windows Spotlight äëÿ îáåñïå÷åíèÿ êîíôèäåíöèàëüíîñòè (âêëþ÷àåò ñëó÷àéíûå îáîè íà ýêðàíå áëîêèðîâêè). 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "ConfigureWindowsSpotlight" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableThirdPartySuggestions" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnActionCenter" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightWindowsWelcomeExperience" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "IncludeEnterpriseSpotlight" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûñòàâèòü ñåðâåðà pool.ntp.org äëÿ ñèíõðîíèçàöèè âðåìåíè.%clr%[92m
@echo Âûñòàâèòü ñåðâåðà pool.ntp.org äëÿ ñèíõðîíèçàöèè âðåìåíè. 1>> %logfile%
set timerStart=!time!
call :delayed_svc w32time
w32tm /config /manualpeerlist:"0.pool.ntp.org ntp1.stratum1.ru ntp1.vniiftri.ru ntp01.sixtopia.net" /syncfromflags:manual /update 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\W32time\Parameters" /v "Type" /t REG_SZ /d "NTP" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "CrossSiteSyncFlags" /t REG_DWORD /d "2" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "EventLogFlags" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "ResolvePeerBackoffMaxTimes" /t REG_DWORD /d "7" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "ResolvePeerBackoffMinutes" /t REG_DWORD /d "15" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "SpecialPollInterval" /t REG_DWORD /d "1024" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü èíñòðóìåíò îòñëåæèâàíèÿ ïðîèçâîäèòåëüíîñòè.%clr%[92m
@echo Îòêëþ÷èòü èíñòðóìåíò îòñëåæèâàíèÿ ïðîèçâîäèòåëüíîñòè. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Âûïîëíèòü ïîëíîå óäàëåíèå OneDrive.%clr%[92m
@echo Âûïîëíèòü ïîëíîå óäàëåíèå OneDrive. 1>> %logfile%
set timerStart=!time!
call :kill "OneDrive.exe"
set OneDr_x86=%SystemRoot%\System32\OneDriveSetup.exe
set OneDr_x64=%SystemRoot%\SysWOW64\OneDriveSetup.exe
if exist %OneDr_x64% (%OneDr_x64% /uninstall 1>> %logfile% 2>>&1) else (%OneDr_x86% /uninstall 1>> %logfile% 2>>&1)
if "%arch%"=="x86" (
	call :acl_file-folders "%OneDr_x86%"
	%rf% "%OneDr_x86%" 1>> %logfile% 2>>&1
)
if "%arch%"=="x64" (
	call :acl_file-folders "%OneDr_x64%"
	%rf% "%OneDr_x64%" 1>> %logfile% 2>>&1
	%rga% "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rgd% "HKCU\SOFTWARE\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\Onedrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\Onedrive" /v "DisableLibrariesDefaultSaveToOneDrive" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\Onedrive" /v "DisableMeteredNetworkFileSync" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
)
call :acl_file-folders "%LocalAppData%\Microsoft\OneDrive"
%rf% "%LocalAppData%\Microsoft\OneDrive\OneDriveStandaloneUpdater.exe" 1>> %logfile% 2>>&1
rmdir /s /q "%UserProfile%\OneDrive" "%ProgramData%\Microsoft OneDrive" "%LocalAppData%\Microsoft\OneDrive" "%SystemDrive%\OneDriveTemp" 1>> %logfile% 2>>&1
%rf% "%AppData%\Microsoft\Windows\Start Menu\Programs\Microsoft OneDrive.lnk" 1>> %logfile% 2>>&1
%rf% "%AppData%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" 1>> %logfile% 2>>&1
for /f "tokens=3* delims=\" %%i in ('schtasks /query /fo list ^| find /i "OneDrive"') do call :disable_task \%%i
%rga% "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f 1>> %logfile% 2>>&1
call :trusted_ps "foreach ($item in (Get-ChildItem $Env:SystemRoot\WinSxS\*onedrive*)) {Remove-Item -Recurse -Force $item.FullName}"
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\SkyDrive" /v "DisableFileSync" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\OneDrive" /v "DisablePersonalSync" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableMeteredNetworkFileSync" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableLibrariesDefaultSaveToOneDrive" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\Environment" /v "OneDrive" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f 1>> %logfile% 2>>&1
%rgd% "HKU\.DEFAULT\Environment" /v "OneDrive" /f 1>> %logfile% 2>>&1
%rgd% "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f 1>> %logfile% 2>>&1
%rgd% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f 1>> %logfile% 2>>&1
rem Äðàéâåð ôèëüòðà îáëà÷íûõ ôàéëîâ OneDrive.
call :disable_svc CldFlt
rem Ñëóæáà ïëàòôîðìû ïîäêëþ÷åííûõ ïîëüçîâàòåëüñêèõ óñòðîéñòâ è ñöåíàðèåâ Universal Glass.
call :disable_svc CDPUserSvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Óäàëèòü ïîèñê Windows.%clr%[92m
@echo Óäàëèòü ïîèñê Windows. 1>> %logfile%
set timerStart=!time!
Dism /online /Disable-Feature /FeatureName:"SearchEngine-Client-Package" /Remove /norestart 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Óäàëèòü UWP ïðèëîæåíèÿ.%clr%[92m
@echo Óäàëèòü UWP ïðèëîæåíèÿ. 1>> %logfile%
set timerStart=!time!
call :remove_uwp Microsoft.3dbuilder
call :remove_uwp Microsoft.Microsoft3DViewer
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.3ds\Shell\3D Print" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.3mf\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.3mf\Shell\3D Print" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.dae\Shell\3D Print" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.dxf\Shell\3D Print" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.fbx\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.glb\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jfif\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpe\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.obj\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.obj\Shell\3D Print" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.ply\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.ply\Shell\3D Print" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.stl\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.stl\Shell\3D Print" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tif\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tiff\Shell\3D Edit" /f 1>> %logfile% 2>>&1
%rgd% "HKLM\SOFTWARE\Classes\SystemFileAssociations\.wrl\Shell\3D Print" /f 1>> %logfile% 2>>&1
call :remove_uwp Microsoft.BingFinance
call :remove_uwp Microsoft.BingTranslator
call :remove_uwp Microsoft.BingFoodAndDrink
call :remove_uwp Microsoft.BingHealthAndFitness
call :remove_uwp Microsoft.BingTravel
call :remove_uwp feedback
call :remove_uwp Microsoft.MicrosoftPowerBIForWindows
call :remove_uwp Microsoft.Wallet
call :remove_uwp Microsoft.WindowsReadingList
call :remove_uwp Microsoft.WindowsAlarms
call :remove_uwp Microsoft.Asphalt8Airborne
call :remove_uwp Microsoft.WindowsCamera
call :remove_uwp Microsoft.DrawboardPDF
call :remove_uwp Microsoft.GetHelp
call :remove_uwp Microsoft.GetStarted
call :remove_uwp Microsoft.WindowsMaps
call :remove_uwp Microsoft.Messaging
call :remove_uwp Microsoft.Advertising.Xaml
call :remove_uwp Microsoft.BingNews
call :remove_uwp Microsoft.MicrosoftSolitaireCollection
call :remove_uwp Microsoft.People
call :remove_uwp Todos
call :remove_uwp Microsoft.Whiteboard
call :remove_uwp MinecraftUWP
call :remove_uwp Microsoft.MixedReality.Portal
call :remove_uwp Microsoft.OneConnect
call :remove_uwp Microsoft.NetworkSpeedTest
call :remove_uwp Microsoft.MicrosoftOfficeHub
call :remove_uwp Office.Lens
call :remove_uwp Office.OneNote
call :remove_uwp Office.Sway
call :remove_uwp Microsoft.Office.Todo.List
call :remove_uwp WindowsPhone
call :remove_uwp CommsPhone
call :remove_uwp Microsoft.Print3D
call :remove_uwp WindowsScan
call :remove_uwp Microsoft.SkypeApp
call :remove_uwp Microsoft.MicrosoftStickyNotes
call :remove_uwp Microsoft.Getstarted
call :remove_uwp Microsoft.WindowsSoundRecorder
call :remove_uwp Microsoft.BingWeather
call :remove_uwp Microsoft.YourPhone
call :remove_uwp Microsoft.ZuneMusic
call :remove_uwp Microsoft.ZuneVideo
call :remove_uwp Microsoft.XboxApp
call :remove_uwp Microsoft.XboxGameOverlay
call :remove_uwp Microsoft.XboxGamingOverlay
call :remove_uwp Microsoft.XboxSpeechToTextOverlay
rem Äðóãèå ïðèëîæåíèÿ
call :remove_uwp PicsArt-PhotoStudio
call :remove_uwp ActiproSoftwareLLC
call :remove_uwp AdobePhotoshopExpress
call :remove_uwp AutodeskSketchBook
call :remove_uwp Microsoft.BingSports
call :remove_uwp candycrush
call :remove_uwp DolbyAccess
call :remove_uwp empires
call :remove_uwp Facebook
call :remove_uwp FarmHeroesSaga
call :remove_uwp PandoraMediaInc
call :remove_uwp spotify
call :remove_uwp Shazam
call :remove_uwp Twitter
call :remove_uwp Yandex.Music
call :remove_uwp xing
call :remove_uwp EclipseManager
call :remove_uwp Netflix
call :remove_uwp PolarrPhotoEditorAcademicEdition
call :remove_uwp Wunderlist
call :remove_uwp LinkedInforWindows
call :remove_uwp DisneyMagicKingdoms
call :remove_uwp MarchofEmpires
call :remove_uwp Plex
call :remove_uwp iHeartRadio
call :remove_uwp FarmVille2CountryEscape
call :remove_uwp Duolingo-LearnLanguagesforFree
call :remove_uwp CyberLinkMediaSuiteEssentials
call :remove_uwp DrawboardPDF
call :remove_uwp FitbitCoach
call :remove_uwp Flipboard
call :remove_uwp Asphalt8Airborne
call :remove_uwp KeeperSecurityInc.Keeper
call :remove_uwp NORDCURRENT.COOKINGFEVER
call :remove_uwp CaesarsSlotsFreeCasino
call :remove_uwp SlingTV
call :remove_uwp SpotifyMusic
call :remove_uwp PhototasticCollage
call :remove_uwp WinZipUniversal
call :remove_uwp RoyalRevolt2
call :remove_uwp king.com
call :remove_uwp king.com.BubbleWitch3Saga
call :remove_uwp king.com.CandyCrushSaga
call :remove_uwp king.com.CandyCrushSodaSaga
rem Ïðèíóäèòåëüíîå óäàëåíèå ïðèëîæåíèé
call :remove_uwp_hard InputApp
call :remove_uwp_hard People
rem call :remove_uwp_hard Microsoft.AAD.BrokerPlugin (Íàðóøàåò ïðîâåðêó ïîäëèííîñòè ïðèëîæåíèÿ Office)
call :remove_uwp_hard Microsoft.BioEnrollment
call :remove_uwp_hard Microsoft.CredDialogHost
call :remove_uwp_hard Microsoft.ECApp
call :remove_uwp_hard Microsoft.EdgeDevtoolsPlugin
call :remove_uwp_hard Microsoft.MicrosoftEdge
call :remove_uwp_hard Microsoft.MicrosoftEdgeDevToolsClient
call :remove_uwp_hard Microsoft.PPIProjection
rem Microsoft.Windows.Apprep.ChxApp (×àñòü äåôåíäåðà è Edge. Ìíîæåñòâî íàñòðîåê â Ïàðàìåòðàõ è î÷åíü ìíîãî â ÃÏ.)
call :remove_uwp_hard Microsoft.Windows.AssignedAccessLockApp
call :remove_uwp_hard Microsoft.Windows.CallingShellApp
call :remove_uwp_hard Microsoft.Windows.CapturePicker
rem call :remove_uwp_hard Microsoft.Windows.CloudExperienceHost (Èñïîëüçóåòñÿ îáëà÷íûìè ïðèëîæåíèÿìè)
call :remove_uwp_hard Microsoft-Windows-ContactSupport
call :remove_uwp_hard Microsoft.Windows.ContentDeliveryManager
call :remove_uwp_hard Microsoft.Windows.Cortana
call :remove_uwp_hard Microsoft.Windows.NarratorQuickStart
call :remove_uwp_hard Microsoft.Windows.OOBENetworkCaptivePortal
call :remove_uwp_hard Microsoft.Windows.OOBENetworkConnectionFlow
call :remove_uwp_hard Microsoft.Windows.ParentalControls
call :remove_uwp_hard Microsoft.Windows.PeopleExperienceHost
call :remove_uwp_hard Microsoft.Windows.PinningConfirmationDialog
call :remove_uwp_hard Microsoft.Windows.SecHealthUI
rem call :remove_uwp_hard Microsoft.Windows.SecureAssessmentBrowser (Íàðóøàåò ðàáîòó Microsoft Intune/Graph)
rem call :remove_uwp_hard Microsoft.Windows.XGpuEjectDialog (Áåçîïàñíîå èçâëå÷åíèå óñòðîéñòâà)
call :remove_uwp_hard Microsoft-Windows-Help
call :remove_uwp_hard Microsoft.WindowsFeedback
call :remove_uwp_hard Microsoft.WindowsFeedbackHub
call :remove_uwp_hard microsoft.windowscommunicationsapps
call :remove_uwp_hard Microsoft-Windows-Internet-Browser-Package
call :remove_uwp_hard Windows.CBSPreview
call :remove_uwp_hard Windows.ContactSupport
call :remove_uwp_hard Windows.Devices.PointOfService
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Èñïîëüçîâàòü Windows Photo Viewer.%clr%[92m
@echo Èñïîëüçîâàòü Windows Photo Viewer. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Classes\.jpg" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\.jpeg" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\.gif" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\.png" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\.bmp" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\.tiff" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Classes\.ico" /ve /t REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ìîíèòîðèíã èñïîëüçîâàíèÿ ñåòåâûõ äàííûõ.%clr%[92m
@echo Îòêëþ÷èòü ìîíèòîðèíã èñïîëüçîâàíèÿ ñåòåâûõ äàííûõ. 1>> %logfile%
set timerStart=!time!
call :disable_svc Ndu
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñëóæáó WAP Push óâåäîìëåíèé äëÿ óïðàâëåíèÿ óñòðîéñòâàìè.%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m ñëóæáà íåîáõîäèìà äëÿ âçàèìîäåéñòâèÿ ñ Microsoft Intune.
@echo Îòêëþ÷èòü ñëóæáó WAP Push óâåäîìëåíèé äëÿ óïðàâëåíèÿ óñòðîéñòâàìè. Ïðåäóïðåæäåíèå: ñëóæáà íåîáõîäèìà äëÿ âçàèìîäåéñòâèÿ ñ Microsoft Intune. 1>> %logfile%
set timerStart=!time!
call :disable_svc dmwappushservice
call :disable_svc dmwappushsvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü âîçìîæíîñòè ïîäêëþ÷åííîãî ïîëüçîâàòåëÿ è òåëåìåòðèþ (ðàíåå íàçûâàâøóþñÿ ñëóæáîé îòñëåæèâàíèÿ äèàãíîñòèêè) è çàáëîêèðîâàòü ñîåäèíåíèå åäèíîé òåëåìåòðèè ÷åðåç ïðàâèëà áðàíäìàóýðà äëÿ èñõîäÿùåãî òðàôèêà.%clr%[92m
@echo Îòêëþ÷èòü âîçìîæíîñòè ïîäêëþ÷åííîãî ïîëüçîâàòåëÿ è òåëåìåòðèþ (ðàíåå íàçûâàâøóþñÿ ñëóæáîé îòñëåæèâàíèÿ äèàãíîñòèêè) è çàáëîêèðîâàòü ñîåäèíåíèå åäèíîé òåëåìåòðèè ÷åðåç ïðàâèëà áðàíäìàóýðà äëÿ èñõîäÿùåãî òðàôèêà. 1>> %logfile%
set timerStart=!time!
call :disable_svc DiagTrack
call :disable_svc diagnosticshub.standardcollector.service
call :disable_svc diagsvc
%PS% "Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled False -Action Block" 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "Disabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "DisableAutomaticTelemetryKeywordReporting" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "TelemetryServiceDisabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TestHooks" /v "DisableAsimovUpLoad" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñîâìåñòèìîñòü îöåíùèêà.%clr%[92m
@echo Îòêëþ÷èòü ñîâìåñòèìîñòü îöåíùèêà. 1>> %logfile%
set timerStart=!time!
call :disable_task "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñáîðùèê äèñêîâûõ äàííûõ.%clr%[92m
@echo Îòêëþ÷èòü ñáîðùèê äèñêîâûõ äàííûõ. 1>> %logfile%
set timerStart=!time!
call :disable_task "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
call :disable_task "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü îáñëóæèâàíèå ïàìÿòè âî âðåìÿ ïðîñòîÿ è ïðè îøèáêàõ.%clr%[92m
@echo Îòêëþ÷èòü îáñëóæèâàíèå ïàìÿòè âî âðåìÿ ïðîñòîÿ è ïðè îøèáêàõ. 1>> %logfile%
set timerStart=!time!
call :disable_task "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
call :disable_task "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnostic"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü àíàëèç ýíåðãîïîòðåáëåíèÿ ñèñòåìû.%clr%[92m
@echo Îòêëþ÷èòü àíàëèç ýíåðãîïîòðåáëåíèÿ ñèñòåìû. 1>> %logfile%
set timerStart=!time!
call :disable_task "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàïëàíèðîâàííóþ äåôãàðìåíòàöèþ äèñêîâ.%clr%[92m
@echo Îòêëþ÷èòü çàïëàíèðîâàííóþ äåôãàðìåíòàöèþ äèñêîâ. 1>> %logfile%
set timerStart=!time!
call :disable_task "\Microsoft\Windows\Defrag\ScheduledDefrag"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Ïîëíîå îòêëþ÷åíèå âñåõ âèäîâ òåëåìåòðèè Windows.%clr%[92m
@echo Ïîëíîå îòêëþ÷åíèå âñåõ âèäîâ òåëåìåòðèè Windows. 1>> %logfile%
set timerStart=!time!
setx DOTNET_CLI_TELEMETRY_OPTOUT 1 | break
setx POWERSHELL_TELEMETRY_OPTOUT 1 | break
if "%arch%"=="x64" (
	%rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
)
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\SQMClient" /v "CorporateSQMURL" /t REG_SZ /d "0.0.0.0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Assistance\Client\1.0\Settings" /v "ImplicitFeedback" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" /v "AllowLinguisticDataCollection" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
call :acl_file-folders "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
%rf% %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Troubleshooter" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Inventory" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Telemetry" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Steps-Recorder" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\PerfTrack" /v "Disabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DeviceCensus.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v Debugger /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
for /f "tokens=2*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v "LastLoggedOnUserSID" 2^>nul') do (set UID=%%b)
%rga% "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\features\%UID%" /v "FeatureStates" /t REG_SZ /d "828" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer" /v "AllowServicePoweredQSA" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" /v "AutoSuggest" /t REG_SZ /d "no" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Infodelivery\Restrictions" /v "NoUpdateCheck" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "Use FormSuggest" /t REG_SZ /d "no" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "DoNotTrack" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "FormSuggest Passwords" /t REG_SZ /d "no" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\SearchScopes" /v "ShowSearchSuggestionsGlobal" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /v "Value" /t REG_SZ /d "Deny" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredUI" /v "DisablePasswordReveal" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
call :disable_task "\Microsoft\Windows\Customer Experience Improvement Program\HypervisorFlightingTask"
call :disable_task "\Microsoft\Windows\Autochk\Proxy"
rem call :disable_task "\Microsoft\Windows\AppID\SmartScreenSpecific"
call :enable_task "\Microsoft\Windows\TextServicesFramework\MsCtfMonitor" rem Âîññòàíîâëåíèå ÿçûêîâîé ïàíåëè â òðåå
call :disable_task "\Microsoft\Windows\Application Experience\AitAgent"
call :disable_task "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
call :disable_task "\Microsoft\Windows\Application Experience\StartupAppTask"
call :disable_task "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
call :disable_task "\Microsoft\Windows\DiskFootprint\Diagnostics"
call :disable_task "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan"
call :disable_task "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery"
call :disable_task "\Microsoft\Windows\FileHistory\File History (maintenance mode)"
call :disable_task "\Microsoft\Windows\File Classification Infrastructure\Property Definition Sync"
call :disable_task "\Microsoft\Windows\Maintenance\WinSAT"
call :disable_task "\Microsoft\Windows\Management\Provisioning\Logon"
call :disable_task "\Microsoft\Windows\NetCfg\BindingWorkItemQueueHandler"
call :disable_task "\Microsoft\Windows\NetTrace\GatherNetworkInfo"
call :disable_task "\Microsoft\Windows\NlaSvc\WiFiTask"
call :disable_task "\Microsoft\Windows\Offline Files\Background Synchronization"
call :disable_task "\Microsoft\Windows\Offline Files\Logon Synchronization"
call :disable_task "\Microsoft\Windows\PI\Sqm-Tasks"
call :disable_task "\Microsoft\Windows\Ras\MobilityManager"
call :disable_task "\Microsoft\Windows\Shell\FamilySafetyMonitor"
call :disable_task "\Microsoft\Windows\Shell\FamilySafetyRefresh"
call :disable_task "\Microsoft\Windows\Shell\FamilySafetyUpload"
call :disable_task "\Microsoft\Windows\Shell\FamilySafetyMonitorToastTask"
call :disable_task "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"
call :disable_task "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance"
call :disable_task "\Microsoft\Windows\WindowsUpdate\Automatic App Update"
call :disable_task "\Microsoft\Windows\License Manager\TempSignedLicenseExchange"
call :disable_task "\Microsoft\Windows\Clip\License Validation"
call :disable_task "\Microsoft\Windows\ApplicationData\CleanupTemporaryState"
call :disable_task "\Microsoft\Windows\ApplicationData\DsSvcCleanup"
call :disable_task "\Microsoft\Windows\PushToInstall\LoginCheck"
call :disable_task "\Microsoft\Windows\PushToInstall\Registration"
call :disable_task "\Microsoft\Windows\Subscription\EnableLicenseAcquisition"
call :disable_task "\Microsoft\Windows\Subscription\LicenseAcquisition"
call :disable_task "\Microsoft\Windows\Diagnosis\RecommendedTroubleshootingScanner"
call :disable_task "\Microsoft\Windows\Diagnosis\Scheduled"
call :disable_task "\Microsoft\Windows\DiskCleanup\SilentCleanup"
call :disable_task "\Microsoft\Windows\Maps\MapsUpdateTask"
call :disable_task "\Microsoft\Windows\Maps\MapsToastTask"
call :disable_task "\Microsoft\Windows\Chkdsk\ProactiveScan"
call :disable_task_sudo "\Microsoft\Windows\Chkdsk\SyspartRepair"
call :disable_task_sudo "\Microsoft\Windows\Device Setup\Metadata Refresh"
call :disable_task "\Microsoft\Windows\Flighting\OneSettings\RefreshCache"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\HandleCommand"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\HandleWnsCommand"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\IntegrityCheck"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\LocateCommandUserSession"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceAccountChange"
call :disable_task "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceConnectedToNetwork"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceLocationRightsChange"
call :disable_task "\Microsoft\Windows\DeviceDirectoryClient\RegisterDevicePeriodic1"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\RegisterDevicePeriodic24"
call :disable_task "\Microsoft\Windows\DeviceDirectoryClient\RegisterDevicePeriodic6"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\RegisterDevicePolicyChange"
call :disable_task "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceScreenOnOff"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceSettingChange"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\RegisterDeviceProtectionStateChanged"
call :disable_task_sudo "\Microsoft\Windows\DeviceDirectoryClient\RegisterUserDevice"
call :disable_task "\Microsoft\Windows\HelloFace\FODCleanupTask"
call :disable_task "\Microsoft\Windows\Location\Notifications"
call :disable_task "\Microsoft\Windows\Location\WindowsActionDialog"
call :disable_task "\Microsoft\Windows\Management\Provisioning\Cellular"
call :disable_task "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
call :disable_task "\Microsoft\Windows\Multimedia\SystemSoundsService"
call :disable_task "\Microsoft\Windows\RetailDemo\CleanupOfflineContent"
call :disable_task "\Microsoft\Windows\Servicing\StartComponentCleanup"
call :disable_task "\Microsoft\Windows\Setup\SetupCleanupTask"
call :disable_task_sudo "\Microsoft\Windows\WaaSMedic\PerformRemediation"
call :disable_task "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"
call :disable_task "\Microsoft\Windows\Work Folders\Work Folders Logon Synchronization"
call :disable_task "\Microsoft\Windows\Work Folders\Work Folders Maintenance Work"
call :disable_task "\Microsoft\Windows\WDI\ResolutionHost"
call :disable_task "\Microsoft\Windows\ApplicationData\appuriverifierinstall"
call :disable_task "\Microsoft\Windows\ApplicationData\appuriverifierdaily"
call :disable_task "\Microsoft\Windows\Device Information\Device"
call :disable_task "\Microsoft\Windows\DUSM\dusmtask"
call :disable_task "\Microsoft\Windows\SpacePort\SpaceAgentTask"
call :disable_task "\Microsoft\Windows\SpacePort\SpaceManagerTask"
call :disable_task "\Microsoft\Windows\Speech\SpeechModelDownloadTask"
call :disable_task "\Microsoft\Windows\TPM\Tpm-HASCertRetr"
call :disable_task "\Microsoft\Windows\TPM\Tpm-Maintenance"
call :disable_task "\Microsoft\Windows\User Profile Service\HiveUploadTask"
call :disable_task "\Microsoft\Windows\WCM\WiFiTask"
call :disable_task "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
call :disable_task "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"
call :disable_task "\Microsoft\Windows\Wininet\CacheTask"
call :disable_task "\Microsoft\Windows\Workplace Join\Automatic-Device-Join"
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\EventLog-AirSpaceChannel" /v "Start" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\AirSpaceChannel" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rf% "%SystemRoot%\System32\Winevt\Logs\AirSpaceChannel.etl" 1>> %logfile% 2>>&1
auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü áåñïîëåçíûå ñëóæáû.%clr%[92m
@echo Îòêëþ÷èòü áåñïîëåçíûå ñëóæáû. 1>> %logfile%
set timerStart=!time!
rem Ïîëüçîâàòåëüñêàÿ ñëóæáà Push-óâåäîìëåíèé. Èìåííî îíà îòâå÷àåò çà öåíòð óâåäîìëåíèé.
rem call :disable_svc WpnUserService
rem Ñëóæáà ñèñòåìû push-óâåäîìëåíèé Windows.
rem call :disable_svc WpnService
rem Ïðîãðàììà àðõèâàöèè äàííûõ.
call :disable_svc SDRSVC
rem Ñëóæáà ïðîñòðàíñòâåííûõ äàííûõ.
call :disable_svc SharedRealitySvc
rem Ïðîâåðêà ïîäëèííîñòè íà îñíîâå ôèçè÷åñêèõ ïàðàìåòðîâ.
call :disable_svc NaturalAuthentication
rem Ñëóæáà àâòîìàòè÷åñêîãî îáíàðóæåíèÿ âåá-ïðîêñè WinHTTP.
call :disable_svc_sudo WinHttpAutoProxySvc
rem Ìîäóëü çàïóñêà ñëóæáû Windows Media Center.
call :disable_svc ehstart
rem Ñëóæáà ïëàíèðîâùèêà Windows Media Center.
call :disable_svc ehSched
rem Ñëóæáà ðåñèâåðà Windows Media Center.
call :disable_svc ehRecvr
rem Ñëóæáà ìåäèàïðèñòàâêè Windows Media Center.
call :disable_svc Mcx2Svc
rem Âåá-êëèåíò.
call :disable_svc WebClient
rem Ëîâóøêà SNMP.
call :disable_svc SNMPTRAP
rem Ñëóæáà ïåðå÷èñëèòåëÿ ïåðåíîñíûõ óñòðîéñòâ.
call :disable_svc WPDBusEnum
rem Àâòîíîìíûå ôàéëû.
call :disable_svc CscService
rem Ñåòåâîé âõîä â ñèñòåìó.
call :disable_svc NetLogon
rem Ñëóæáà îáùåãî äîñòóïà ê ïîðòàì Net.Tcp.
call :disable_svc NetTcpPortSharing
rem Ïóáëèêàöèÿ ðåñóðñîâ îáíàðóæåíèÿ ôóíêöèè.
call :disable_svc FDResPub
rem Õîñò ïîñòàâùèêà ôóíêöèè îáíàðóæåíè.
call :disable_svc fdPHost
rem Ñëóæáà ôàêñîâ.
call :disable_svc Fax
rem Êîîðäèíàòîð ðàñïðåäåëåííûõ òðàíçàêöèé.
call :disable_svc MSDTC
rem Êëèåíò îòñëåæèâàíèÿ èçìåíèâøèõñÿ ñâÿçåé.
call :disable_svc TrkWks
rem Ðàñïðîñòðàíåíèå ñåðòèôèêàòà.
call :disable_svc CertPropSvc
rem Ñëóæáà øëþçà óðîâíÿ ïðèëîæåíèÿ.
call :disable_svc ALG
rem Ñëóæáà çàëèâàåò â îáëàêî âñå äàííûå îò ïðèëîæåíèé.
call :disable_svc DcpSvc
rem Ñëóæáà êîøåëüêà.
call :disable_svc WalletService
rem Ñëóæáà ïîääåðæêè ñîâìåñòèìîñòè ïðîãðàìì.
call :disable_svc PcaSvc
rem Ñëóæáà ïðåäâàðèòåëüíîé îöåíêè Windows Insider.
call :disable_svc wisvc
rem Ñëóæáà äåìîíñòðàöèè ìàãàçèíà.
call :disable_svc RetailDemo
rem Óïðàâëåíèå ïðîôèëÿìè è ó÷åòíûìè çàïèñÿìè íà íàñòðîåííîì óñòðîéñòâå ñ îáùèì ÏÊ.
call :disable_svc shpamsvc
rem Ðåêîìåíäîâàííàÿ ñëóæáà óñòðàíåíèÿ íåïîëàäîê.
call :disable_svc TroubleshootingSvc
rem Cëóæáà äëÿ ñèíõðîíèçàöèè ïî÷òû, êîíòàêòîâ, êàëåíäàðÿ è íåêîòîðûõ äðóãèõ ïîëüçîâàòåëüñêèõ äàííûõ.
call :disable_svc OneSyncSvc
rem Ñëóæáà, îòâå÷àþùàÿ çà ðàáîòó ïðèëîæåíèÿ Ñîîáùåíèÿ, êîòîðîå âû ñèíõðîíèçèðóåòå ìåæäó ñâîèì óñòðîéñòâîì.
call :disable_svc MessagingService
rem Cëóæáà èíäåêñàöèè ïîèñêà ïî êîíòàêòàì íà ìîáèëüíûõ óñòðîéñòâàõ.
call :disable_svc PimIndexMaintenanceSvc
rem Ñëóæáà äîñòóïà ê äàííûì ïîëüçîâàòåëÿ (UserDataSvc), êîòîðàÿ ïîçâîëÿåò ïðèëîæåíèÿì â ïåñî÷íèöå ïîëó÷àòü äîñòóï ê äàííûì ïîëüçîâàòåëÿ, âêëþ÷àÿ êîíòàêòíóþ èíôîðìàöèþ, êàëåíäàðè, ñîîáùåíèÿ è äðóãîå ñîäåðæèìîå.
call :disable_svc UserDataSvc
rem Cëóæáà õðàíåíèÿ ïîëüçîâàòåëüñêèõ äàííûõ, òàêèõ êàê êîíòàêòû, êàëåíäàðè, ñîîáùåíèÿ.
call :disable_svc UnistoreSvc
rem Ïîëüçîâàòåëüñêàÿ ñëóæáà DVR äëÿ èãð è òðàíñëÿöèè.
call :disable_svc_sudo BcastDVRUserService
rem Áðîêåð ìîíèòîðà âðåìåíè âûïîëíåíèÿ System Guard.
call :disable_svc_sudo Sgrmbroker
rem Ïîëüçîâàòåëüñêàÿ ñëóæáà áóôåðà îáìåíà.
call :disable_svc cbdhsvc
rem Ñìàðò-êàðòû äëÿ Windows.
call :disable_svc SCardSvr
rem Ñëóæáà ïåðå÷èñëåíèÿ óñòðîéñòâ ÷òåíèÿ ñìàðò-êàðò.
call :disable_svc ScDeviceEnum
rem Ñìàðò-êàðòû äëÿ Windows.
call :disable_svc SCPolicySvc
rem Ñèñòåìà óïðàâëåíèÿ èäåíòèôèêàöèåé.
call :disable_svc idsvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñåðâèñ óëó÷øåíèÿ êà÷åñòâà îáñëóæèâàíèÿ êëèåíòîâ (CEIP/SQM).%clr%[92m
@echo Îòêëþ÷èòü ñåðâèñ óëó÷øåíèÿ êà÷åñòâà îáñëóæèâàíèÿ êëèåíòîâ (CEIP/SQM). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
call :disable_task "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM"
call :disable_task "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
call :disable_task "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
call :disable_task "\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
call :disable_task "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü êëþ÷ SQM OS.%clr%[92m
@echo Îòêëþ÷èòü êëþ÷ SQM OS. 1>> %logfile%
set timerStart=!time!
if "%arch%"=="x86" (
    %rga% "HKLM\SOFTWARE\Microsoft\VSCommon\14.0\SQM" /v "OptIn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
    %rga% "HKLM\SOFTWARE\Microsoft\VSCommon\15.0\SQM" /v "OptIn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
    %rga% "HKLM\SOFTWARE\Microsoft\VSCommon\16.0\SQM" /v "OptIn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
) else (
    %rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\14.0\SQM" /v "OptIn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
    %rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\15.0\SQM" /v "OptIn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
    %rga% "HKLM\SOFTWARE\Wow6432Node\Microsoft\VSCommon\16.0\SQM" /v "OptIn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü òåëåìåòðèþ ëèöåíçèé.%clr%[92m
@echo Îòêëþ÷èòü òåëåìåòðèþ ëèöåíçèé. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàäà÷è òåëåìåòðèè ÌåäèàÖåíòðà.%clr%[92m
@echo Îòêëþ÷èòü çàäà÷è òåëåìåòðèè ÌåäèàÖåíòðà. 1>> %logfile%
set timerStart=!time!
call :disable_task "\Microsoft\Windows\media center\activateWindowssearch"
call :disable_task "\Microsoft\Windows\media center\configureinternettimeservice"
call :disable_task "\Microsoft\Windows\media center\dispatchrecoverytasks"
call :disable_task "\Microsoft\Windows\media center\ehdrminit"
call :disable_task "\Microsoft\Windows\media center\installplayready"
call :disable_task "\Microsoft\Windows\media center\mcupdate"
call :disable_task "\Microsoft\Windows\media center\mediacenterrecoverytask"
call :disable_task "\Microsoft\Windows\media center\objectstorerecoverytask"
call :disable_task "\Microsoft\Windows\media center\ocuractivate"
call :disable_task "\Microsoft\Windows\media center\ocurdiscovery"
call :disable_task "\Microsoft\Windows\media center\pbdadiscovery"
call :disable_task "\Microsoft\Windows\media center\pbdadiscoveryw1"
call :disable_task "\Microsoft\Windows\media center\pbdadiscoveryw2"
call :disable_task "\Microsoft\Windows\media center\pvrrecoverytask"
call :disable_task "\Microsoft\Windows\media center\pvrscheduletask"
call :disable_task "\Microsoft\Windows\media center\registersearch"
call :disable_task "\Microsoft\Windows\media center\reindexsearchroot"
call :disable_task "\Microsoft\Windows\media center\sqlliterecoverytask"
call :disable_task "\Microsoft\Windows\media center\updaterecordpath"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàäà÷è òåëåìåòðèè ñèíõðîíèçàöèè íàñòðîåê.%clr%[92m
@echo Îòêëþ÷èòü çàäà÷è òåëåìåòðèè ñèíõðîíèçàöèè íàñòðîåê. 1>> %logfile%
set timerStart=!time!
call :disable_task_sudo "\Microsoft\Windows\SettingSync\BackgroundUpLoadTask"
call :disable_task "\Microsoft\Windows\SettingSync\BackupTask"
call :disable_task "\Microsoft\Windows\SettingSync\NetworkStateChangeTask"
%rf% "%SystemRoot%\SysNative\Tasks\Microsoft\Windows\SettingSync\*" 1>> %logfile% 2>>&1
%rf% "%SystemRoot%\System32\Tasks\Microsoft\Windows\SettingSync\*" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàäà÷è òåëåìåòðèè Microsoft Office.%clr%[92m
@echo Îòêëþ÷èòü çàäà÷è òåëåìåòðèè Microsoft Office. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\15.0\OSM" /v "enablelogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\15.0\OSM" /v "enableupload" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\Feedback" /v "IncludeScreenshot" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\General" /v "NoTrack" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\General" /v "OptinDisable" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\General" /v "ShownFirstrunOptin" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\General" /v "SkyDriveSigninOption" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\OfficeUpdate" /v "OnlineRepair" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\OfficeUpdate" /v "Fallbacktocdn" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\Services\fax" /v "NoFax" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\SignIn" /v "SigninOptions" /t REG_DWORD /d "3" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Common\PtWatson" /v "PtwOptin" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Firstrun" /v "Bootedrtm" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\Firstrun" /v "DisableMovie" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM" /v "EnableFileObfuscation" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM" /v "EnableLogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM" /v "EnableUpload" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedApplications" /v "accesssolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedApplications" /v "olksolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedApplications" /v "onenotesolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedApplications" /v "pptsolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedApplications" /v "projectsolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedApplications" /v "publishersolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedApplications" /v "visiosolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedApplications" /v "wdsolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedApplications" /v "xlsolution" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedSolutionTypes" /v "agave" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedSolutionTypes" /v "appaddins" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedSolutionTypes" /v "comaddins" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedSolutionTypes" /v "documentfiles" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\OSM\PreventedSolutionTypes" /v "templatefiles" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\ClickToRun\OverRide" /v "DisableLogManagement" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" /v "TimerInterval" /t REG_SZ /d "900000" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\15.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\16.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "VerboseLogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v "VerboseLogging" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\15.0\Common" /v "QMEnable" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\16.0\Common" /v "QMEnable" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
call :disable_task "\Microsoft\Office\Office ClickToRun Service Monitor"
call :disable_task "\Microsoft\Office\OfficeTelemetryAgentFallBack2016"
call :disable_task "\Microsoft\Office\OfficeTelemetryAgentLogOn2016"
call :disable_task "\Microsoft\Office\OfficeTelemetry\AgentFallBack2016"
call :disable_task "\Microsoft\Office\OfficeTelemetry\OfficeTelemetryAgentLogOn2016"
call :disable_task "\Microsoft\Office\Office 15 Subscription Heartbeat"
call :disable_task "\Microsoft\Office\OfficeTelemetryAgentFallBack"
call :disable_task "\Microsoft\Office\OfficeTelemetryAgentLogOn"
call :auto_svc ClickToRunSvc
rem %rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\OfficeClickToRun.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1 :: Ñëóæáà íåîáõîæèìà äëÿ íîðìàëüíîé ðàáîòû MS Office
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàäà÷è òåëåìåòðèè NVIDIA.%clr%[92m
@echo Îòêëþ÷èòü çàäà÷è òåëåìåòðèè NVIDIA. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\NVIDIA Corporation\Global\Startup\SendTelemetryData" /v "@" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\services\NvTelemetryContainer" /v "Start" /t REG_DWORD /d "4" /f 1>> %logfile% 2>>&1
if exist "%ProgramFiles%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL" (
    rundll32 "%ProgramFiles%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetryContainer 1>> %logfile% 2>>&1
    rundll32 "%ProgramFiles%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetry 1>> %logfile% 2>>&1
)
%rf% "%SystemRoot%\System32\DriverStore\FileRepository\NvTelemetry*" 1>> %logfile% 2>>&1
rd /s /q "%ProgramFiles(x86)%\NVIDIA Corporation\NvTelemetry" 1>> %logfile% 2>>&1
rd /s /q "%ProgramFiles%\NVIDIA Corporation\NvTelemetry" 1>> %logfile% 2>>&1
call :disable_svc NvTelemetryContainer
for /f "tokens=3* delims=\" %%i in ('schtasks /query /fo list ^| find /i "NvTmRep_CrashReport"') do call :disable_task \%%i
for /f "tokens=3* delims=\" %%i in ('schtasks /query /fo list ^| find /i "NvTmMon"') do call :disable_task \%%i
for /f "tokens=3* delims=\" %%i in ('schtasks /query /fo list ^| find /i "NvTmRep"') do call :disable_task \%%i
for /f "tokens=3* delims=\" %%i in ('schtasks /query /fo list ^| find /i "NvTmRepOnLogon"') do call :disable_task \%%i
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü çàäà÷è òåëåìåòðèè Intel.%clr%[92m
@echo Îòêëþ÷èòü çàäà÷è òåëåìåòðèè Intel. 1>> %logfile%
set timerStart=!time!
for /f "tokens=3* delims=\" %%i in ('schtasks /query /fo list ^| find /i "IntelSURQC"') do call :disable_task \%%i
call :disable_svc IntelTA
call :disable_task "\Intel PTT EK Recertification"
call :disable_task "\USER_ESRV_SVC_QUEENCREEK"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü òåëåìåòðèþ Mozilla Firefox.%clr%[92m
@echo Îòêëþ÷èòü òåëåìåòðèþ Mozilla Firefox. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableTelemetry" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v "DisableDefaultBrowserAgent" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
for /f "tokens=3* delims=\" %%i in ('schtasks /query /fo list ^| find /i "Firefox"') do call :disable_task "\Mozilla\%%i"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü Software Reporter Tool è ñåðâèñ îáíîâëåíèÿ Google Chrome.%clr%[92m
@echo Îòêëþ÷èòü Software Reporter Tool è ñåðâèñ îáíîâëåíèÿ Google Chrome. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ChromeCleanupEnabled" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ChromeCleanupReportingEnabled" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Policies\Google\Chrome" /v "MetricsReportingEnabled" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
icacls "%localappdata%\Google\Chrome\User Data\SwReporter" /inheritance:r /deny "*S-1-1-0:(OI)(CI)(F)" "*S-1-5-7:(OI)(CI)(F)" 1>> %logfile% 2>>&1
cacls "%localappdata%\Google\Chrome\User Data\SwReporter" /e /c /d %username% 1>> %logfile% 2>>&1
%rga% "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "DisallowRun" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "1" /t REG_SZ /d "software_reporter_tool.exe" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\software_reporter_tool.exe" /v "Debugger" /t REG_SZ /d "%SystemRoot%\Tools\Empty.exe" /f 1>> %logfile% 2>>&1
call :disable_task "\GoogleUpdateTaskMachineCore"
call :disable_task "\GoogleUpdateTaskMachineUA"
call :disable_svc gupdate
call :disable_svc gupdatem
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûñòàâèòü çàïóñê ïî òðåáîâàíèþ äëÿ ïîìîùíèêà ïî âõîäó â ó÷åòíóþ çàïèñü Ìàéêðîñîôò.%clr%[92m
@echo Âûñòàâèòü çàïóñê ïî òðåáîâàíèþ äëÿ ïîìîùíèêà ïî âõîäó â ó÷åòíóþ çàïèñü Ìàéêðîñîôò. 1>> %logfile%
set timerStart=!time!
call :demand_svc wlidsvc
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Âêëþ÷èòü ïåðå÷èñëèòåëü âèðòóàëüíûõ äèñêîâ.%clr%[92m
@echo Âêëþ÷èòü ïåðå÷èñëèòåëü âèðòóàëüíûõ äèñêîâ. 1>> %logfile%
set timerStart=!time!
call :auto_svc vdrvroot
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü èíôðàñòðóêòóðó âèðòóàëèçàöèè Hyper-V.%clr%[92m
@echo Âêëþ÷èòü èíôðàñòðóêòóðó âèðòóàëèçàöèè Hyper-V. 1>> %logfile%
set timerStart=!time!
call :auto_svc Vid
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü ïåðå÷èñëèòåëü âèðòóàëüíûõ ñåòåâûõ êàðò.%clr%[92m
@echo Âêëþ÷èòü ïåðå÷èñëèòåëü âèðòóàëüíûõ ñåòåâûõ êàðò. 1>> %logfile%
set timerStart=!time!
call :delayed_svc NdisVirtualBus
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü ñîñòàâíóþ øèíó.%clr%[92m
@echo Âêëþ÷èòü ñîñòàâíóþ øèíó. 1>> %logfile%
set timerStart=!time!
call :auto_svc CompositeBus
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü UMBus.%clr%[92m
@echo Âêëþ÷èòü UMBus. 1>> %logfile%
set timerStart=!time!
call :auto_svc umbus
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷èòü øèíó RDP è ñëóæáû óäàëåííîãî ðàáî÷åãî ñòîëà.%clr%[92m
@echo Âêëþ÷èòü øèíó RDP. 1>> %logfile%
set timerStart=!time!
rem Øèíà RDP.
call :delayed_svc rdpbus
rem Ñëóæáà óäàë¸ííûõ ðàáî÷èõ ñòîëîâ.
call :auto_svc TermService
rem Ïåðåíàïðàâèòåëü ïîðòîâ ïîëüçîâàòåëüñêîãî ðåæèìà ñëóæá óäàëåííûõ ðàáî÷èõ ñòîëîâ.
call :auto_svc UmRdpService
rem Ñëóæáà íàñòðîéêè ñåðâåðà óäàëåííûõ ðàáî÷èõ ñòîëîâ.
call :auto_svc SessionEnv
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ìíîãîàäðåñíîå ðàçðåøåíèå ëîêàëüíûõ èìåí (LLMNR).%clr%[92m
@echo Îòêëþ÷èòü ìíîãîàäðåñíîå ðàçðåøåíèå ëîêàëüíûõ èìåí (LLMNR). 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Âêëþ÷èòü âîññòàíîâëåíèå ñèñòåìû è ñáðîñ äî çàâîäñêèõ íàñòðîåê (Windows RE).%clr%[92m
@echo Âêëþ÷èòü âîññòàíîâëåíèå ñèñòåìû è ñáðîñ äî çàâîäñêèõ íàñòðîåê (Windows RE). 1>> %logfile%
set timerStart=!time!
reagentc /enable 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ïîâûøåííóþ òî÷íîñòü óêàçàòåëÿ.%clr%[92m
@echo Îòêëþ÷èòü ïîâûøåííóþ òî÷íîñòü óêàçàòåëÿ. 1>> %logfile%
set timerStart=!time!
%rga% "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "0000000000000000c0cc0c0000000000809919000000000040662600000000000033330000000000" /f 1>> %logfile% 2>>&1
%rga% "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "0000000000000000000038000000000000007000000000000000a800000000000000e00000000000" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Óñòàíîâèòü íîâûå âîçìîæíîñòè îò Windows 10X (òîëüêî äëÿ ñáîðîê 20H1 è âûøå).%clr%[92m
@echo Óñòàíîâèòü íîâûå âîçìîæíîñòè îò Windows 10X (òîëüêî äëÿ ñáîðîê 20H1 è âûøå). 1>> %logfile%
set timerStart=!time!
rem Disk Management in Settings
"%~dp0ViVeTool.exe" addconfig 23257398 2 1>> %logfile% 2>>&1
rem Windows 10X Touch Keyboard
"%~dp0ViVeTool.exe" addconfig 20438551 2 1>> %logfile% 2>>&1
rem Theme-aware Live Tiles
"%~dp0ViVeTool.exe" addconfig 23615618 2 1>> %logfile% 2>>&1
rem Media Controls in Volume Flyout
"%~dp0ViVeTool.exe" addconfig 23403403 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 23674478 2 1>> %logfile% 2>>&1
rem About Page in Settings
"%~dp0ViVeTool.exe" addconfig 25175482 2 1>> %logfile% 2>>&1
rem Theme-aware Splashscreens
"%~dp0ViVeTool.exe" addconfig 25936164 2 1>> %logfile% 2>>&1
rem Meet Now Integration
"%~dp0ViVeTool.exe" addconfig 28170999 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 28582629 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 28758888 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 28622680 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 28622690 0 1>> %logfile% 2>>&1
rem GPU Information in Settings About Page
"%~dp0ViVeTool.exe" addconfig 27974039 2 1>> %logfile% 2>>&1
rem Split Layout for Windows 10X
"%~dp0ViVeTool.exe" addconfig 23881110 2 1>> %logfile% 2>>&1
rem Profile Header in Settings
"%~dp0ViVeTool.exe" addconfig 18299130 0 1>> %logfile% 2>>&1
rem Windows 10X OOBE
"%~dp0ViVeTool.exe" addconfig 26336822 2 1>> %logfile% 2>>&1
rem App Archival
"%~dp0ViVeTool.exe" addconfig 21206371 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 28384772 2 1>> %logfile% 2>>&1
rem Advanced Settings for Colour
"%~dp0ViVeTool.exe" addconfig 10834416 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 12259052 2 1>> %logfile% 2>>&1
rem New UI for the Battery Settings Page
"%~dp0ViVeTool.exe" addconfig 27296756 2 1>> %logfile% 2>>&1
rem New UI for the Touch Keyboard
"%~dp0ViVeTool.exe" addconfig 23324166 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30024318 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 27154708 2 1>> %logfile% 2>>&1
rem Acrylic Blur on the Input Switcher
"%~dp0ViVeTool.exe" addconfig 13140185 2 1>> %logfile% 2>>&1
rem Settings Enhancements and Rejuvenation
"%~dp0ViVeTool.exe" addconfig 30206630 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 31010280 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30204574 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 29449858 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30204206 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 31197890 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 29643556 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30381770 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 29734477 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30580687 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30380766 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30030725 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 29896902 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 31291312 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 29739067 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 29029980 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30331247 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30832672 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 25977668 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 31198568 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 31199967 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 31401318 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 31065128 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30095024 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 29241208 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 29241309 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 25810627 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 29673992 2 1>> %logfile% 2>>&1
rem Acrylic Task View in Timeline
"%~dp0ViVeTool.exe" addconfig 12520383 2 1>> %logfile% 2>>&1
rem Device Health Improvements
"%~dp0ViVeTool.exe" addconfig 30091733 2 1>> %logfile% 2>>&1
rem Modern Animations for Input View
"%~dp0ViVeTool.exe" addconfig 29650567 2 1>> %logfile% 2>>&1
rem TLS 1.3 for EAP
"%~dp0ViVeTool.exe" addconfig 31308504 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 31308502 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 31308506 2 1>> %logfile% 2>>&1
rem New Bluetooh Inbound Pairing UI
"%~dp0ViVeTool.exe" addconfig 23402385 2 1>> %logfile% 2>>&1
rem Bluetooth Flyout
"%~dp0ViVeTool.exe" addconfig 23673487 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 19919111 2 1>> %logfile% 2>>&1
rem Display Sleep Power Settings
"%~dp0ViVeTool.exe" addconfig 31026792 2 1>> %logfile% 2>>&1
rem FIDO 2.1
"%~dp0ViVeTool.exe" addconfig 27870272 2 1>> %logfile% 2>>&1
rem Modern Search
"%~dp0ViVeTool.exe" addconfig 20383964 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 21206249 2 1>> %logfile% 2>>&1
rem New Devices Flow Connect UI
"%~dp0ViVeTool.exe" addconfig 23673473 2 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 20447509 2 1>> %logfile% 2>>&1
rem Optimised Window Position and Size Updates
"%~dp0ViVeTool.exe" addconfig 30134375 2 1>> %logfile% 2>>&1
rem Redirect Programs and Features to UWP Settings
"%~dp0ViVeTool.exe" addconfig 26003950 2 1>> %logfile% 2>>&1
rem Thumbnail Cache Updates
"%~dp0ViVeTool.exe" addconfig 19173096 2 1>> %logfile% 2>>&1
rem New Search and Cortana
"%~dp0ViVeTool.exe" addconfig 19263623 0 1>> %logfile% 2>>&1
rem Modern UX for Voice Typing
"%~dp0ViVeTool.exe" addconfig 24781215 2 1>> %logfile% 2>>&1
rem Expand Voice Typing Supported Language
"%~dp0ViVeTool.exe" addconfig 29609459 2 1>> %logfile% 2>>&1
rem Windows Spotlight v3
"%~dp0ViVeTool.exe" addconfig 11024039 2 1>> %logfile% 2>>&1
rem Device Usage Settings Page
"%~dp0ViVeTool.exe" addconfig 25810627 2 1>> %logfile% 2>>&1
rem Deferred Contexts for D3D11on12
"%~dp0ViVeTool.exe" 13815251 2 1>> %logfile% 2>>&1
rem DirectX Core System File Mappings
"%~dp0ViVeTool.exe" 22765950 2 1>> %logfile% 2>>&1
rem DXGI Buffer Upgrades
"%~dp0ViVeTool.exe" 25957903 2 1>> %logfile% 2>>&1
rem DXGI Windowed Swap Effect Upgrades
"%~dp0ViVeTool.exe" 23990563 2 1>> %logfile% 2>>&1
rem News and Interests
"%~dp0ViVeTool.exe" addconfig 29947361 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 27833282 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 27368843 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 28247353 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 27371092 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 27371152 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30803283 0 1>> %logfile% 2>>&1
"%~dp0ViVeTool.exe" addconfig 30213886 0 1>> %logfile% 2>>&1
rem Windows 10X Boot Animation
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\BootControl" /v "BootProgressAnimation" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
rem Windows Rounded UI
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\Flighting" /v "ImmersiveSearch" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\Flighting\Override" /v "ImmersiveSearchFull" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search\Flighting\Override" /v "CenterScreenRoundedCornerRadius" /t REG_DWORD /d "9" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Óñòàíîâèòü ðàñøèðåííîå êîíòåêñòíîå ìåíþ?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÓñòàíîâêà ðàñøèðåííîãî êîíòåêñòíîãî ìåíþ. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Óñòàíîâêà ðàñøèðåííîãî êîíòåêñòíîãî ìåíþ. 1>> %logfile%
	set timerStart=!time!
	md "%SystemRoot%\Tools" 1>> %logfile% 2>>&1
	xcopy "%~dp0\..\Tools\*.*" "%SystemRoot%\Tools\*.*" /e /c /i /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0devxexec.exe" "%SystemRoot%\System32" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0devxexec.exe" "%SystemRoot%\SysWOW64" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0hidcon.exe" "%SystemRoot%\System32" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0nircmdc_%arch%.exe" "%SystemRoot%\System32\nircmdc.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0subinacl.exe" "%SystemRoot%\System32" /c /q /h /r /y 1>> %logfile% 2>>&1
	if "%arch%"=="x64" (
		xcopy "%~dp0comctl32.ocx" "%SystemRoot%\SysWOW64" /c /q /h /r /y 1>> %logfile% 2>>&1
		xcopy "%~dp0mscomctl.ocx" "%SystemRoot%\SysWOW64" /c /q /h /r /y 1>> %logfile% 2>>&1
		regsvr32 /s %SystemRoot%\SysWOW64\comctl32.ocx 1>> %logfile% 2>>&1
		regsvr32 /s %SystemRoot%\SysWOW64\mscomctl.ocx 1>> %logfile% 2>>&1
	)
	if "%arch%"=="x86" (
		xcopy "%~dp0comctl32.ocx" "%SystemRoot%\System32" /c /q /h /r /y 1>> %logfile% 2>>&1
		xcopy "%~dp0mscomctl.ocx" "%SystemRoot%\System32" /c /q /h /r /y 1>> %logfile% 2>>&1
		regsvr32 /s %SystemRoot%\System32\comctl32.ocx 1>> %logfile% 2>>&1
		regsvr32 /s %SystemRoot%\System32\mscomctl.ocx 1>> %logfile% 2>>&1
	)
	start "" /wait %~dp0\..\Installers\ComIntRep.exe
	start "" /wait %~dp0\..\Installers\CompatibilityManager.exe
	start "" /wait %~dp0\..\Installers\DriveCleanup.exe
	start "" /wait %~dp0\..\Installers\DriveTidy.exe
	start "" /wait %~dp0\..\Installers\EasyServicesOptimizer.exe
	start "" /wait %~dp0\..\Installers\EjectFlash.exe
	start "" /wait %~dp0\..\Installers\Everything.exe
	start "" /wait %~dp0\..\Installers\FixPrintSpooler.exe
	start "" /wait %~dp0\..\Installers\FixWin.exe
	start "" /wait %~dp0\..\Installers\GoPing.exe
	start "" /wait %~dp0\..\Installers\herdProtect.exe
	start "" /wait %~dp0\..\Installers\KeyFreeze.exe
	start "" /wait %~dp0\..\Installers\NTFS_Stream_Explorer.exe
	start "" /wait %~dp0\..\Installers\ReduceMemory.exe
	start "" /wait %~dp0\..\Installers\RegistryFirstAid.exe
	start "" /wait %~dp0\..\Installers\ReIcon.exe
	start "" /wait %~dp0\..\Installers\RunBlock.exe
	start "" /wait %~dp0\..\Installers\Scanner.exe
	start "" /wait %~dp0\..\Installers\TopMost.exe
	start "" /wait %~dp0\..\Installers\UpdateTime.exe
	start "" /wait %~dp0\..\Installers\WebCam.exe
	rem Âûñòàâèòü ãðóïïèðîâêó ïî òèïó ôàéëîâîé ñèñòåìû â Ìîé Êîìïüþòåð
	set __COMPAT_LAYER=RunAsInvoker & for /f "tokens=* delims=" %%l in ('reg query "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /s /v "GroupByKey:FMTID"^|FindStr HKEY_') do (
		set __COMPAT_LAYER=RunAsInvoker & %rga% "%%l" /v "GroupByKey:FMTID" /t REG_SZ /d "{9B174B35-40FF-11D2-A27E-00C04FC30871}" /f 1>> %logfile% 2>>&1
		set __COMPAT_LAYER=RunAsInvoker & %rga% "%%l" /v "ColInfo" /t REG_BINARY /d "00000000000000000000000000000000FDDFDFFD1000000000000000000000000500000018000000354B179BFF40D211A27E00C04FC30871040000007800000030F125B7EF471A10A5F102608C9EEBAC0A000000A000000030F125B7EF471A10A5F102608C9EEBAC04000000C8000000354B179BFF40D211A27E00C04FC308710300000080000000354B179BFF40D211A27E00C04FC308710200000080000000" /f 1>> %logfile% 2>>&1
		set __COMPAT_LAYER=RunAsInvoker & %rga% "%%l" /v "GroupByKey:FMTID" /t REG_SZ /d "{9B174B35-40FF-11D2-A27E-00C04FC30871}" /f 1>> %logfile% 2>>&1
		set __COMPAT_LAYER=RunAsInvoker & %rga% "%%l" /v "GroupByKey:PID" /t REG_DWORD /d "4" /f 1>> %logfile% 2>>&1
		set __COMPAT_LAYER=RunAsInvoker & %rga% "%%l" /v "GroupView" /t REG_DWORD /d "4294967295" /f 1>> %logfile% 2>>&1
	)
	%rga% "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /v "MRUListEx" /t REG_BINARY /d "02000000060000000500000004000000010000000000000003000000FFFFFFFF" /f 1>> %logfile% 2>>&1
	rem %rga% "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Notifications\Data" /v "418A073AA3BC3475" /t REG_BINARY /d "7D410000000000000400040001020D00000000000E0000001C390B010100000030E82B010400000059B50501F40000006B507E00030000008A8385003200000090A6A101030000009829B7001200000099CBDC0025460000A19F5E0075000000DBB4EF0002000000F1D9A30008000000F4A4C30004000000F848B1000E0001000000AF010000007D7500040000000868E30006000000186565013E000000187DC700950000003DD734010B50000056737D005C0800006B507E000E00000085CAA9008C0000008A8385004801000090D5D000500000009829B7009D020000A6751801592C0000B087B4005C080000E6C531000500050000002A0000004F871A011200000096390B01340100009FC8CA000A000000A9B2DB0010000000C221D100020008000000C89B6328025FB500153A970F59B50501010009000000DC6200008A8385000500640000004800000014E8B700E5020000421D0B01CA050000461D0B016E934D00E79EB500C5A70100FF9EB5000E0065000000329A00001C955C00F4BA50002FBDB7005871070046BDB700A014000065A69E003A000000779B93004F01000090D5D000F40200009CA6B40071D10000A205060048000000BAA6B70015050000C46B81002F070000CABCB700CE49D500E6C5310082AF0200F0E0B60055020000F7125E00050066000000A221490046BDB700372C000065A69E00E506000074AFB7003A000000779B9300A57B0000A2050600040067000000C89B6328025FB500FA27000046BDB7005800000065A69E000C160000A2050600020068000000C1160000A2050600139C0100CABCB700020069000000BD110000025FB5009C20000065A69E0003006A000000E9000000025FB50048000000680FB80097040000E79EB50002006B00000067030000025FB5007200000065A69E0001006C000000B2060000A205060001006D00000004000000A205060002006E00000083040000CABCB700EF220300E79EB50001006F00000004000000A20506000200700000003A10000065A69E003B240100A2050600020071000000E800000065A69E0001010000A20506000100720000005E930000A2050600010073000000471B000065A69E000100750000001900000065A69E00010076000000A902000065A69E00010077000000ED02000065A69E000100780000007802000065A69E000100790000003763000065A69E0001007B0000001900000065A69E0001007D000000CE17000065A69E0001007F000000811C000065A69E000100810000002B0B000065A69E0001009700000025080000BEB3EF000100C0010000080000001FC87500" /f 1>> %logfile% 2>>&1
	rem Ñòàòü âëàäåëüöåì ïî ïðàâîé êíîïêå ìûøè
	%rga% "HKCR\*\shell\TakeOwn" /v "MUIVerb" /t REG_SZ /d "Ñìåíà ïðàâ è âëàäåëüöà" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\*\shell\TakeOwn" /v "SubCommands" /t REG_SZ /d "file_takeown_trust;file_takeown_sys;file_takeown_adm;file_takeown_usr" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\*\shell\TakeOwn" /v "Icon" /t REG_SZ /d "imageres.dll,117" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\*\shell\TakeOwn" /v "NoWorkingDirectory" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\*\shell\TakeOwn" /v "Position" /t REG_SZ /d "middle" /f 1>> %logfile% 2>>&1
	rem Äîáàâëåíèå ìåíþ äëÿ ïàïîê
	%rga% "HKCR\Directory\shell\TakeOwn" /v "MUIVerb" /t REG_SZ /d "Ñìåíà ïðàâ è âëàäåëüöà" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\TakeOwn" /v "SubCommands" /t REG_SZ /d "folder_takeown_trust;folder_takeown_sys;folder_takeown_adm;folder_takeown_usr" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\TakeOwn" /v "Icon" /t REG_SZ /d "imageres.dll,117" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\TakeOwn" /v "NoWorkingDirectory" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\TakeOwn" /v "Position" /t REG_SZ /d "middle" /f 1>> %logfile% 2>>&1
	rem Äîáàâëåíèå ìåíþ äëÿ äèñêîâ
	%rga% "HKCR\Drive\shell\TakeOwn" /v "MUIVerb" /t REG_SZ /d "Ñìåíà ïðàâ è âëàäåëüöà" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\TakeOwn" /v "SubCommands" /t REG_SZ /d "folder_takeown_trust;folder_takeown_sys;folder_takeown_adm;folder_takeown_usr" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\TakeOwn" /v "Icon" /t REG_SZ /d "imageres.dll,117" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\TakeOwn" /v "NoWorkingDirectory" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\TakeOwn" /v "Position" /t REG_SZ /d "middle" /f 1>> %logfile% 2>>&1
	rem Íàçâàíèå ïóíêòà ìåíþ óñòàíîâêè âëàäåëüöà TrustedInstaller äëÿ ôàéëîâ
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_trust" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_trust" /ve /t REG_SZ /d "Ïðåäîñòàâèòü äëÿ TrustedInstaller" /f 1>> %logfile% 2>>&1
	rem Êîìàíäà óñòàíîâêè âëàäåëüöà TrustedInstaller äëÿ ôàéëîâ
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_trust\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464 /grant=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464=f" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_trust\command" /v "IsolatedCommand" /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464 /grant=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464=f" /f 1>> %logfile% 2>>&1
	rem Íàçâàíèå ïóíêòà ìåíþ óñòàíîâêè âëàäåëüöà Ñèñòåìà äëÿ ôàéëîâ
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_sys" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_sys" /ve /t REG_SZ /d "Ïðåäîñòàâèòü äëÿ Ñèñòåìà" /f 1>> %logfile% 2>>&1
	rem Êîìàíäà óñòàíîâêè âëàäåëüöà Ñèñòåìà äëÿ ôàéëîâ
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_sys\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-18 /grant=S-1-5-18=f" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_sys\command" /v "IsolatedCommand" /t REG_SZ /d "nircmdc elevate cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-18 /grant=S-1-5-18=f" /f 1>> %logfile% 2>>&1
	rem Íàçâàíèå ïóíêòà ìåíþ óñòàíîâêè âëàäåëüöà Àäìèíèñòðàòîðû äëÿ ôàéëîâ
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_adm" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_adm" /ve /t REG_SZ /d "Ïðåäîñòàâèòü äëÿ Àäìèíèñòðàòîðû" /f 1>> %logfile% 2>>&1
	rem Êîìàíäà óñòàíîâêè âëàäåëüöà Àäìèíèñòðàòîðû äëÿ ôàéëîâ
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_adm\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-32-544 /grant=S-1-5-32-544=f" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_adm\command" /v "IsolatedCommand" /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-32-544 /grant=S-1-5-32-544=f" /f 1>> %logfile% 2>>&1
	rem Íàçâàíèå ïóíêòà ìåíþ óñòàíîâêè âëàäåëüöà Ïîëüçîâàòåëü äëÿ ôàéëîâ
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_usr" /ve /t REG_SZ /d "Ïðåäîñòàâèòü äëÿ %username%" /f 1>> %logfile% 2>>&1
	rem Êîìàíäà óñòàíîâêè âëàäåëüöà Ïîëüçîâàòåëü äëÿ ôàéëîâ
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_usr\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=%username% /grant=%username%=f" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\file_takeown_usr\command" /v "IsolatedCommand" /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=%username% /grant=%username%=f" /f 1>> %logfile% 2>>&1
	rem Íàçâàíèå ïóíêòà ìåíþ óñòàíîâêè âëàäåëüöà TrustedInstaller äëÿ ôàéëîâ, äèñêîâ è ïàïîê
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_trust" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_trust" /ve /t REG_SZ /d "Ïðåäîñòàâèòü äëÿ TrustedInstaller" /f 1>> %logfile% 2>>&1
	rem Êîìàíäà óñòàíîâêè âëàäåëüöà TrustedInstaller äëÿ ôàéëîâ, äèñêîâ è ïàïîê
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_trust\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464 /grant=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464=f & subinacl /subdirectories \"%%1\*.*\" /setowner=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464 /grant=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464=f" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_trust\command" /v "IsolatedCommand" /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464 /grant=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464=f & subinacl /subdirectories \"%%1\*.*\" /setowner=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464 /grant=S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464=f" /f 1>> %logfile% 2>>&1
	rem Íàçâàíèå ïóíêòà ìåíþ óñòàíîâêè âëàäåëüöà Ñèñòåìà äëÿ ôàéëîâ, äèñêîâ è ïàïîê
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_sys" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_sys" /ve /t REG_SZ /d "Ïðåäîñòàâèòü äëÿ Ñèñòåìà" /f 1>> %logfile% 2>>&1
	rem Êîìàíäà óñòàíîâêè âëàäåëüöà Ñèñòåìà äëÿ ôàéëîâ, äèñêîâ è ïàïîê
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_sys\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-18 /grant=S-1-5-18=f & subinacl /subdirectories \"%%1\*.*\" /setowner=S-1-5-18 /grant=S-1-5-18=f" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_sys\command" /v "IsolatedCommand" /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-18 /grant=S-1-5-18=f & subinacl /subdirectories \"%%1\*.*\" /setowner=S-1-5-18 /grant=S-1-5-18=f" /f 1>> %logfile% 2>>&1
	rem Íàçâàíèå ïóíêòà ìåíþ óñòàíîâêè âëàäåëüöà Àäìèíèñòðàòîðû äëÿ ôàéëîâ, äèñêîâ è ïàïîê
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_adm" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_adm" /ve /t REG_SZ /d "Ïðåäîñòàâèòü äëÿ Àäìèíèñòðàòîðû" /f 1>> %logfile% 2>>&1
	rem Êîìàíäà óñòàíîâêè âëàäåëüöà Àäìèíèñòðàòîðû äëÿ ôàéëîâ, äèñêîâ è ïàïîê
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_adm\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-32-544 /grant=S-1-5-32-544=f & subinacl /subdirectories \"%%1\*.*\" /setowner=S-1-5-32-544 /grant=S-1-5-32-544=f" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_adm\command" /v "IsolatedCommand" /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=S-1-5-32-544 /grant=S-1-5-32-544=f & subinacl /subdirectories \"%%1\*.*\" /setowner=S-1-5-32-544 /grant=S-1-5-32-544=f" /f 1>> %logfile% 2>>&1
	rem Íàçâàíèå ïóíêòà ìåíþ óñòàíîâêè âëàäåëüöà Ïîëüçîâàòåëü äëÿ ôàéëîâ, äèñêîâ è ïàïîê
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_usr" /ve /t REG_SZ /d "Ïðåäîñòàâèòü äëÿ %username%" /f 1>> %logfile% 2>>&1
	rem Êîìàíäà óñòàíîâêè âëàäåëüöà Ïîëüçîâàòåëü äëÿ ôàéëîâ, äèñêîâ è ïàïîê
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_usr\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=%username% /grant=%username%=f & subinacl /subdirectories \"%%1\*.*\" /setowner=%username% /grant=%username%=f" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folder_takeown_usr\command" /v "IsolatedCommand" /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c subinacl /subdirectories \"%%1\" /setowner=%username% /grant=%username%=f & subinacl /subdirectories \"%%1\*.*\" /setowner=%username% /grant=%username%=f" /f 1>> %logfile% 2>>&1
	rem Ïðîãðàììû è êîìïîíåíòû â ïàïêå Êîìïüþòåð
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{D20EA4E1-3957-11d2-A40B-0C5020524153}" /f 1>> %logfile% 2>>&1
	rem Ñåòåâûå ïîäêëþ÷åíèÿ â ïàïêå Êîìïüþòåð
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{7b81be6a-ce2b-4676-a29e-eb907a5126c5}" /f 1>> %logfile% 2>>&1
	rem Êîðçèíà â ïàïêå Êîìïüþòåð
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{7007ACC7-3202-11D1-AAD2-00805FC1270E}" /f 1>> %logfile% 2>>&1
	rem Ñåòü â ïàïêå Êîìïüþòåð
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{645FF040-5081-101B-9F08-00AA002F954E}" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{00000000-0000-0000-0000-123456725801}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725801}" /ve /t REG_SZ /d "Ñåòü ðàáî÷åé ãðóïïû" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725801}" /v "Infotip" /t REG_SZ /d "Äîñòóï ê êîìïüþòåðàì è óñòðîéñòâàì â ñåòè ðàáî÷åé ãðóïïû" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725801}\DefaultIcon" /ve /t REG_SZ /d "shell32.dll,17" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725801}\InProcServer32" /ve /t REG_SZ /d "shell32.dll" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725801}\InProcServer32" /v "ThreadingModel" /t REG_SZ /d "Apartment" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725801}\Shell\Open\Command" /ve /t REG_SZ /d "\"explorer.exe\" shell:::{208D2C60-3AEA-1069-A2D7-08002B30309D}" /f 1>> %logfile% 2>>&1
	rem Âñå çàäà÷è â ïàïêå Êîìïüþòåð
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{00000000-0000-0000-0000-123456725802}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725802}" /ve /t REG_SZ /d "Ïîëíûé ñïèñîê íàñòðàèâàåìûõ ïàðàìåòðîâ" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725802}" /v "Infotip" /t REG_SZ /d "Äîñòóï êî âñåì ïàðàìåòðàì ñèñòåìû â îäíîé äèðåêòîðèé" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725802}\DefaultIcon" /ve /t REG_SZ /d "shell32.dll,21" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725802}\InProcServer32" /ve /t REG_SZ /d "shell32.dll" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725802}\InProcServer32" /v "ThreadingModel" /t REG_SZ /d "Apartment" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456725802}\Shell\Open\Command" /ve /t REG_SZ /d "\"explorer.exe\" shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" /f 1>> %logfile% 2>>&1
	rem Òàáëèöà ñèìâîëîâ â ïàïêå Êîìïüþòåð
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{00000000-0000-0000-0000-123456756840}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456756840}" /ve /t REG_SZ /d "Òàáëèöà ñèìâîëîâ" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456756840}" /v "InfoTip" /t REG_SZ /d "Òàáëèöà ñèìâîëîâ èñïîëüçóåòñÿ äëÿ äîáàâëåíèÿ â òåêñò äîïîëíèòåëüíûõ ñèìâîëîâ." /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456756840}" /v "System.ControlPanel.Category" /t REG_SZ /d "9" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456756840}\DefaultIcon" /ve /t REG_SZ /d "charmap.exe,0" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{00000000-0000-0000-0000-123456756840}\Shell\Open\command" /ve /t REG_SZ /d "charmap.exe" /f 1>> %logfile% 2>>&1
	rem Ñîçäàíèå ïóíêòà "Ðåãèñòðàöèÿ" â ìåíþ DLL èëè OCX-ôàéëîâ
	%rga% "HKCR\dllfile\Shell\DLLReg" /v "Icon" /t REG_SZ /d "shell32.dll,-153" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\dllfile\Shell\DLLReg" /ve /t REG_SZ /d "Çàðåãèñòðèðîâàòü DLL ôàéë â ñèñòåìå" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\dllfile\Shell\DLLReg\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem \"regsvr32.exe \"%%1\"\"" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\dllfile\Shell\CancelReg" /v "Icon" /t REG_SZ /d "shell32.dll,-153" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\dllfile\Shell\CancelReg" /ve /t REG_SZ /d "Îòìåíèòü ðåãèñòðàöèþ DLL" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\dllfile\Shell\CancelReg\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem \"regsvr32.exe /u \"%%1\"\"" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\ocxfile\Shell\OCXReg" /v "Icon" /t REG_SZ /d "shell32.dll,-153" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\ocxfile\Shell\OCXReg" /ve /t REG_SZ /d "Çàðåãèñòðèðîâàòü OCX ôàéë â ñèñòåìå" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\ocxfile\Shell\OCXReg\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem \"regsvr32.exe \"%%1\"\"" /f 1>> %logfile% 2>>&1
	rem Äîáàâëåíèå ïóíêòîâ "Çàïóñê îò èìåíè àäìèíèñòðàòîðà" è "Èçâëå÷ü ôàéëû èç ïàêåòà" â êîíòåêñòíîå ìåíþ MSI ôàéëîâ
	%rga% "HKCR\Msi.Package\Shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Msi.Package\shell\runas\Command" /ve /t REG_EXPAND_SZ /d "\"%SystemRoot%\System32\msiexec.exe\" /i \"%%1\" %%*" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Classes\Msi.Package\shell\ExtractAll" /ve /t REG_SZ /d "Èçâëå÷ü ôàéëû èç ïàêåòà" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Classes\Msi.Package\shell\ExtractAll" /v "icon" /t REG_SZ /d "msiexec.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Classes\Msi.Package\shell\ExtractAll\command" /ve /t REG_SZ /d "msiexec.exe /a \"%%1\" /qb TARGETDIR=\"%%1 Contents\"" /f 1>> %logfile% 2>>&1
	rem Óäàëåíèÿ ïóíêòà Ñìåíèòü ïàðîëü èç äèàëîãîâîãî îêíà Áåçîïàñíîñòü Windows
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableChangePassword" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
	rem Äîáàâëåíèå â Ïàíåëü óïðàâëåíèÿ îñíàñòêè "Ó÷åòíàÿ çàïèñü îïûòíîãî ïîëüçîâàòåëÿ" (netplwiz), äëÿ ðàñøèðåííîãî óïðàâëåíèÿ ó÷åòíûìè çàïèñÿìè.
	%rga% "HKCR\CLSID\{98641F47-8C25-4936-BEE4-C2CE1298969D}" /ve /t REG_SZ /d "Ó÷åòíàÿ çàïèñü îïûòíîãî ïîëüçîâàòåëÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{98641F47-8C25-4936-BEE4-C2CE1298969D}" /v "InfoTip" /t REG_SZ /d "Ðàñøèðåííûå íàñòðîéêè ïàðàìåòðîâ ó÷åòíûõ çàïèñåé." /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{98641F47-8C25-4936-BEE4-C2CE1298969D}" /v "System.ControlPanel.Category" /t REG_SZ /d "9" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{98641F47-8C25-4936-BEE4-C2CE1298969D}\DefaultIcon" /ve /t REG_SZ /d "netplwiz.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\CLSID\{98641F47-8C25-4936-BEE4-C2CE1298969D}\Shell\Open\command" /ve /t REG_SZ /d "Control Userpasswords2" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{98641F47-8C25-4936-BEE4-C2CE1298969D}" /ve /t REG_SZ /d "Ðàñøèðåííûå íàñòðîéêè ïàðàìåòðîâ ó÷åòíûõ çàïèñåé" /f 1>> %logfile% 2>>&1
	rem Äîáàâëåíèå êëàññè÷åñêîãî âñïëûâàþùåãî ìåíþ Ïðîãðàììû (Programs) â ìåíþ Ïóñê âìåñòî ìåíþ Èçáðàííîå (Favorites).
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Favorites" /t REG_SZ /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs" /f 1>> %logfile% 2>>&1
	%rga% "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v "Favorites" /t REG_EXPAND_SZ /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs" /f 1>> %logfile% 2>>&1
	rem Óäàëåíèå ïóíêòà "Èñïðàâëåíèå íåïîëàäîê ñîâìåñòèìîñòè" èç êîíòåêñòíîãî ìåíþ ÿðëûêîâ è èñïîëíÿåìûõ ôàéëîâ.
	%rga% "HKCR\batfile\ShellEx\ContextMenuHandlers\Compatibility" /ve /t REG_SZ /d "-{1d27f844-3a1f-4410-85ac-14651078412d}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\lnkfile\shellex\ContextMenuHandlers\Compatibility" /ve /t REG_SZ /d "-{1d27f844-3a1f-4410-85ac-14651078412d}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shellex\ContextMenuHandlers\Compatibility" /ve /t REG_SZ /d "-{1d27f844-3a1f-4410-85ac-14651078412d}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\cmdfile\ShellEx\ContextMenuHandlers\Compatibility" /ve /t REG_SZ /d "-{1d27f844-3a1f-4410-85ac-14651078412d}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Msi.Package\shellex\ContextMenuHandlers\Compatibility" /ve /t REG_SZ /d "-{1d27f844-3a1f-4410-85ac-14651078412d}" /f 1>> %logfile% 2>>&1
	rem Äîáàâëåíèå êîìàíäû "Êîïèðîâàòü êàê ïóòü" â êîíòåêñòíîì ìåíþ Ïðîâîäíèêà.
	%rga% "HKCR\AllFilesystemObjects\shell\CopyAsPathMenu" /ve /t REG_SZ /d "Êîïèðîâàòü êàê ïóòü" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\AllFilesystemObjects\shell\CopyAsPathMenu" /v "Icon" /t REG_SZ /d "shell32.dll,-242" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\AllFilesystemObjects\shell\CopyAsPathMenu\command" /ve /t REG_SZ /d "%SystemRoot%\system32\cmd.exe /c <nul (set/p var="%%1")|clip" /f 1>> %logfile% 2>>&1
	rem Ñîçäàíèå ïóíêòà "Î÷èñòèòü ñîäåðæèìîå ïàïêè"
	%rga% "HKCR\Directory\shell\DeleteFolderContent" /v "MUIVerb" /t REG_SZ /d "Î÷èñòèòü ñîäåðæèìîå ïàïêè" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\DeleteFolderContent" /v "Icon" /t REG_SZ /d "shell32.dll,-254" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\DeleteFolderContent\command" /ve /t REG_SZ /d "%SystemRoot%\system32\cmd.exe /c cd /d \"%%1\" & del /s /f /q . & rmdir /s /q ." /f 1>> %logfile% 2>>&1
	rem Îòêðûâàòü âñå ôàéëû áëîêíîòîì
	%rga% "HKCR\*\shell\OpenWNotepad" /ve /t REG_SZ /d "Îòêðûòü â Áëîêíîòå" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\*\shell\OpenWNotepad" /v "Icon" /t REG_SZ /d "shell32.dll,-152" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\*\shell\OpenWNotepad\command" /ve /t REG_SZ /d "notepad.exe \"%%1\"" /f 1>> %logfile% 2>>&1
	rem Ðàñøèðåííûé çàïóñê è ïîâåäåíèå .exe ôàéëîâ
	%rgd% "HKCR\exefile\shell\OneRunAsSystem" /f 1>> %logfile% 2>>&1
	%rgd% "HKCR\exefile\shell\RunAsInvoker" /f 1>> %logfile% 2>>&1
	%rgd% "HKCR\exefile\shell\runasuser" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs" /v "Icon" /t REG_SZ /d "imageres.dll,102" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs" /v "MUIVerb" /t REG_SZ /d "Ðàñøèðåííûé çàïóñê" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs" /v "ExtendedSubCommandsKey" /t REG_SZ /d "exefile\shell\00 RunAs" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\00 RunAsSystem" /v "Icon" /t REG_SZ /d "imageres.dll,102" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\00 RunAsSystem" /ve /t REG_SZ /d "Çàïóñê îò èìåíè ñèñòåìû" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\00 RunAsSystem\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem \"%%1\"" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\01 RunAsAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\01 RunAsAdmin" /ve /t REG_SZ /d "Çàïóñê îò èìåíè àäìèíèñòðàòîðà" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\01 RunAsAdmin\command" /ve /t REG_SZ /d "\"%%1\" %%*" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\01 RunAsAdmin\command" /v "IsolatedCommand" /t REG_SZ /d "\"%%1\" %%*" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\02 RunAsUser" /ve /t REG_SZ /d "@shell32.dll,-50944" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\02 RunAsUser" /v "SuppressionPolicyEx" /t REG_SZ /d "{F211AA05-D4DF-4370-A2A0-9F19C09756A7}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\02 RunAsUser" /v "Icon" /t REG_SZ /d "imageres.dll,319" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\02 RunAsUser\command" /v "DelegateExecute" /t REG_SZ /d "{ea72d00e-4960-42fa-ba92-7792a7944c1d}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\03 RunAsInvoker" /v "Icon" /t REG_SZ /d "imageres.dll,101" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\03 RunAsInvoker" /ve /t REG_SZ /d "Çàïóñê ñ ïîíèæåííûìè ïðàâàìè" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\00 RunAs\shell\03 RunAsInvoker\command" /ve /t REG_SZ /d "C:\WINDOWS\system32\cmd.exe /c set __COMPAT_LAYER=RunAsInvoker & start \"\" \"%%1\" %%*" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC" /v "Icon" /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\EMCShell.exe\",0" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC" /v "MUIVerb" /t REG_SZ /d "Ïîâåäåíèå ïðè çàïóñêå" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC" /v "ExtendedSubCommandsKey" /t REG_SZ /d "exefile\shell\01 EMC" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\00" /v "MUIVerb" /t REG_SZ /d "Îáû÷íûé çàïóñê" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\00" /v "Icon" /t REG_SZ /d "imageres.dll,11" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\00\command" /ve /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\EMCShell.exe\" reset \"%%1\"" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\01" /v "Icon" /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\Actions\Ask.exe\",0" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\01" /v "MUIVerb" /t REG_SZ /d "Çàïðîñ ïîäòâåðæäåíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\01\command" /ve /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\EMCShell.exe\" set \"%%1\" ask" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\02" /v "Icon" /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\Actions\Elevate.exe\",0" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\02" /v "MUIVerb" /t REG_SZ /d "Ñ ïîâûøåííûìè ïðèâèëåãèÿìè" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\02\command" /ve /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\EMCShell.exe\" set \"%%1\" elevate" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\03" /v "Icon" /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\Actions\Drop.exe\",0" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\03" /v "MUIVerb" /t REG_SZ /d "Ñ ïîíèæåííûìè ïðèâèëåãèÿìè" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\03\command" /ve /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\EMCShell.exe\" set \"%%1\" drop" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\04" /v "Icon" /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\Actions\PowerRequest.exe\",0" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\04" /v "MUIVerb" /t REG_SZ /d "Íå ïåðåõîäèòü â ñïÿùèé ðåæèì" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\04\command" /ve /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\EMCShell.exe\" set \"%%1\" nosleep" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\05" /v "Icon" /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\Actions\PowerRequest.exe\",0" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\05" /v "MUIVerb" /t REG_SZ /d "Íå îòêëþ÷àòü äèñïëåé" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\05\command" /ve /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\EMCShell.exe\" set \"%%1\" display-on" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\06" /v "Icon" /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\Actions\Deny.exe\",0" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\06" /v "MUIVerb" /t REG_SZ /d "Çàïðåò ñ ïðåäóïðåæäåíèåì" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\06\command" /ve /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\EMCShell.exe\" set \"%%1\" deny" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\07" /v "Icon" /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\Actions\Deny.exe\",0" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\07" /v "MUIVerb" /t REG_SZ /d "Ïîëíûé çàïðåò íà çàïóñê" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\01 EMC\shell\07\command" /ve /t REG_SZ /d "\"%SystemRoot%\Tools\ExecutionMaster\EMCShell.exe\" set \"%%1\" deny-access" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\open" /v "Icon" /t REG_SZ /d "imageres.dll,11" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\exefile\shell\runas" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	rem Î÷èñòêà äèñêà â êîíòåêñòíîå ìåíþ äèñêîâ
	%rga% "HKCR\Drive\shell\CleanMgr" /v "MUIVerb" /t REG_SZ /d "Î÷èñòêà äèñêà" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\CleanMgr" /v "Icon" /t REG_SZ /d "cleanmgr.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\CleanMgr" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\CleanMgr\command" /ve /t REG_SZ /d "nircmdc elevate cleanmgr.exe /lowdisk /d %%1" /f 1>> %logfile% 2>>&1
	rem Ïóíêò "Äåôðàãìåíòàöèÿ" â êîíòåêñòíîå ìåíþ äèñêîâ
	%rga% "HKCR\Drive\shell\Defrag" /ve /t REG_SZ /d "Äåôðàãìåíòàöèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\Defrag" /v "Icon" /t REG_SZ /d "dfrgui.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\Defrag" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\Defrag\command" /ve /t REG_SZ /d "defrag %%1" /f 1>> %logfile% 2>>&1
	rem Êîìàíäíàÿ ñòðîêà è PowerShell
	%rgd% "HKCR\Directory\shell\CmdFolder" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\RunPSCmd" /v "MUIVerb" /t REG_SZ /d "Çàïóñòèòü" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\RunPSCmd" /v "SubCommands" /t REG_SZ /d "ps_system;ps_admin;ps_user;cmd_system;cmd_admin;cmd_user" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\RunPSCmd" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\shell\RunPSCmd" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rgd% "HKCR\Directory\Background\shell\CmdFolder" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\RunPSCmd" /v "MUIVerb" /t REG_SZ /d "Çàïóñòèòü" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\RunPSCmd" /v "SubCommands" /t REG_SZ /d "ps_system;ps_admin;ps_user;cmd_system;cmd_admin;cmd_user" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\RunPSCmd" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\RunPSCmd" /v "Position" /t REG_SZ /d "Bottom" /f 1>> %logfile% 2>>&1
	%rgd% "HKCR\Drive\shell\CmdFolder" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\RunPSCmd" /v "MUIVerb" /t REG_SZ /d "Çàïóñòèòü" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\RunPSCmd" /v "SubCommands" /t REG_SZ /d "ps_system;ps_admin;ps_user;cmd_system;cmd_admin;cmd_user" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\RunPSCmd" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Drive\shell\RunPSCmd" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\LibraryFolder\Background\shell\RunPSCmd" /v "MUIVerb" /t REG_SZ /d "Çàïóñòèòü" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\LibraryFolder\Background\shell\RunPSCmd" /v "SubCommands" /t REG_SZ /d "ps_system;ps_admin;ps_user;cmd_system;cmd_admin;cmd_user" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\LibraryFolder\Background\shell\RunPSCmd" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\LibraryFolder\Background\shell\RunPSCmd" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_system" /ve /t REG_SZ /d "PS îò èìåíè ñèñòåìû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_system" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_system" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_system\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoExit -Command Set-Location -LiteralPath '%%v'" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_admin" /ve /t REG_SZ /d "PS îò èìåíè àäìèíèñòðàòîðà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_admin" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_admin" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_admin\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoExit -Command Set-Location -LiteralPath '%%v'" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_user" /ve /t REG_SZ /d "PS îò èìåíè ïîëüçîâàòåëÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_user" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\ps_user\command" /ve /t REG_SZ /d "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoExit -Command Set-Location -LiteralPath '%%v'" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_system" /ve /t REG_SZ /d "CMD îò èìåíè ñèñòåìû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_system" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\cmd.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_system" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_system\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem %SystemRoot%\System32\cmd.exe /s /k pushd \"%%v\"" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_admin" /ve /t REG_SZ /d "CMD îò èìåíè àäìèíèñòðàòîðà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_admin" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\cmd.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_admin" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_admin\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /s /k pushd \"%%v\"" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_user" /ve /t REG_SZ /d "CMD îò èìåíè ïîëüçîâàòåëÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_user" /v "Icon" /t REG_SZ /d "%SystemRoot%\System32\cmd.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cmd_user\command" /ve /t REG_SZ /d "%SystemRoot%\system32\cmd.exe /s /k set __COMPAT_LAYER=RunAsInvoker & pushd \"%%v\"" /f 1>> %logfile% 2>>&1
	rem Öâåò êîìàíäíîé ñòðîêè. Ñ îãðàíè÷åííûìè ïðàâàìè 09 (ñèíèé òåêñò íà ÷åðíîì ôîíå) ñ ïðàâàìè àäìèíèñòðàòîðà 08 (ñåðûé òåêñò íà ÷åðíîì ôîíå)
	%rga% "HKLM\SOFTWARE\Microsoft\Command Processor" /v "AutoRun" /t REG_SZ /d "cls && reg query HKEY_USERS\S-1-5-19\Environment /v TEMP 2>&1 | findstr /i /c:REG_EXPAND_SZ 2>&1 >nul && (color 08) || (color 09)" /f 1>> %logfile% 2>>&1
	rem Óäàëèòü ïóíêò "Âîññòàíîâèòü ïðåæíþþ âåðñèþ" èç êîíòåêñòíîãî ìåíþ Ïðîâîäíèêà
	%rgd% "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f 1>> %logfile% 2>>&1
	%rgd% "HKCR\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" /f 1>> %logfile% 2>>&1
	call :trusted_app reg.exe add HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\CompMgmt /v MUIVerb /t REG_SZ /d Äîïîëíèòåëüíî /f
	call :trusted_app reg.exe add HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\CompMgmt /v SubCommands /t REG_SZ /d godmode;controlpanel;propertiesadvanced;services;deviceproperties;regedit;msconfig;gpedit;taskschd;eventvwr;diskmng;appwiz /f
	call :trusted_app reg.exe add HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\CompMgmt /v Icon /t REG_SZ /d imageres.dll,104 /f
	call :trusted_app reg.exe add HKCR\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\shell\CompMgmt /v Position /t REG_SZ /d Bottom /f
	%rga% "HKCR\Directory\Background\shell" /ve /t REG_SZ /d "MyComp;ShowDesk;Eject;CleanTools,Refresh,RunPSCmd,Standart,System,Admin,Advanced,ReIcon,PowerMenu,Display,Gadgets,Personalize" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\MyComp" /v "MUIVerb" /t REG_SZ /d "Îòêðûòü ïðîâîäíèê (Êîìïüþòåð)" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\MyComp" /v "Icon" /t REG_SZ /d "explorer.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\MyComp" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\MyComp\command" /ve /t REG_SZ /d "explorer.exe shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\ShowDesk" /v "MUIVerb" /t REG_SZ /d "Ïîêàçàòü ðàáî÷èé ñòîë/ýëåìåíòû" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\ShowDesk" /v "Icon" /t REG_SZ /d "shell32.dll,-35" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\ShowDesk" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\ShowDesk\command" /ve /t REG_SZ /d "explorer.exe shell:::{3080F90D-D7AD-11D9-BD98-0000947B0257}" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Eject" /v "MUIVerb" /t REG_SZ /d "Áûñòðîå èçâëå÷åíèå ñúåìíûõ íîñèòåëåé" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Eject" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\EjectFlash\RemoveDrive.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Eject" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Eject" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Eject\command" /ve /t REG_EXPAND_SZ /d "wscript.exe %SystemRoot%\Tools\EjectFlash\EjectFlash.vbs" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Refresh" /v "MUIVerb" /t REG_SZ /d "Îáíîâèòü èêîíêè/ïàïêè (2x)" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Refresh" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Refresh.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Refresh" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Refresh\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Refresh.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\CleanTools" /v "MUIVerb" /t REG_SZ /d "Î÷èñòêà/îïòèìèçàöèÿ/ïîèñê âèðóñîâ" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\CleanTools" /v "SubCommands" /t REG_SZ /d "emptyclip;clearrecycle;cleardsk;speedy;drivetidy;clearreg;6to4;reducemem;servopt;virscan" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\CleanTools" /v "Icon" /t REG_SZ /d "shell32.dll,-254" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\CleanTools" /v "Position" /t REG_SZ /d "Top" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\NetTools" /v "MUIVerb" /t REG_SZ /d "Ñåòåâûå óòèëèòû" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\NetTools" /v "SubCommands" /t REG_SZ /d "goping;copyip;updtime;http;rdp;fixbrowsers;netfix;macchanger;tcpoptimizer" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\NetTools" /v "Icon" /t REG_SZ /d "shell32.dll,-18" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Standart" /v "MUIVerb" /t REG_SZ /d "Ñòàíäàðòíûå ïðîãðàììû" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Standart" /v "SubCommands" /t REG_SZ /d "mute;hide;topmost;centerall;closeall;winmanager;screen;search;scanner;webcam;calc;paint;snip;wordpad;iexplore;osk;charmap" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Standart" /v "Icon" /t REG_SZ /d "imageres.dll,152" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Standart" /v "Position" /t REG_SZ /d "Bottom" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\System" /v "MUIVerb" /t REG_SZ /d "Ñèñòåìà" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\System" /v "SubCommands" /t REG_SZ /d "control;devmgr;msconfig;sysdm;sysdir;networksh;wu;appwiz;rstrui;taskmgr;power;folderoptions;instinfo" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\System" /v "Icon" /t REG_SZ /d "imageres.dll,104" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\System" /v "Position" /t REG_SZ /d "Bottom" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Admin" /v "MUIVerb" /t REG_SZ /d "Àäìèíèñòðèðîâàíèå" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Admin" /v "SubCommands" /t REG_SZ /d "regedit;services;rsop;run;taskschd;wf;network;useracc;useracc2;eventvwr;perfmon;relmon;trouble" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Admin" /v "Icon" /t REG_SZ /d "mmc.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Admin" /v "Position" /t REG_SZ /d "Bottom" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Advanced" /v "MUIVerb" /t REG_SZ /d "Äîïîëíèòåëüíî" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Advanced" /v "SubCommands" /t REG_SZ /d "runblock;showsysfiles;reloadex;reiconcache;fixprints;drive-clean;dpstyle;sfcfix;fixwin" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Advanced" /v "Icon" /t REG_SZ /d "shell32.dll,-22" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\Advanced" /v "Position" /t REG_SZ /d "Bottom" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\ReIcon" /v "MUIVerb" /t REG_SZ /d "Ðàñïîëîæåíèå ôàéëîâ ðàáî÷åãî ñòîëà" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\ReIcon" /v "SubCommands" /t REG_SZ /d "res_reicon;save_reicon;launch_reicon" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\ReIcon" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ReIcon\ReIcon.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\shell\ReIcon" /v "Position" /t REG_SZ /d "Bottom" /f 1>> %logfile% 2>>&1
	rem Âûêëþ÷åíèå êîìïüþòåðà ÷åðåç êîíòåêñòíîå ìåíþ
	%rga% "HKCR\Directory\Background\Shell\PowerMenu" /v "MUIVerb" /t REG_SZ /d "Âûêëþ÷åíèå/ïåðåçàãðóçêà/áëîêèðîâêà" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\Shell\PowerMenu" /v "SubCommands" /t REG_SZ /d "keylock;lockoffmon;lock;switch;logoff;sleep;hibernate;rrestart;restart;shutdown;hybridshutdown;cancelshutdown" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\Shell\PowerMenu" /v "Icon" /t REG_SZ /d "shell32.dll,215" /f 1>> %logfile% 2>>&1
	%rga% "HKCR\Directory\Background\Shell\PowerMenu" /v "Position" /t REG_SZ /d "Bottom" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\godmode" /ve /t REG_SZ /d "Ðåæèì Áîãà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\godmode" /v "Icon" /t REG_SZ /d "imageres.dll,-1033" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\godmode\command" /ve /t REG_SZ /d "explorer shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\msconfig" /ve /t REG_SZ /d "Íàñòðîéêà ñèñòåìû (msconfig)" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\msconfig" /v "Icon" /t REG_SZ /d "shell32.dll,-25" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\msconfig\command" /ve /t REG_SZ /d "msconfig.exe /s" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\controlpanel" /v "MUIVerb" /t REG_SZ /d "Ïàíåëü óïðàâëåíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\controlpanel" /v "Icon" /t REG_SZ /d "imageres.dll,22" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\controlpanel\command" /ve /t REG_SZ /d "control.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\deviceproperties" /v "MUIVerb" /t REG_SZ /d "Äèñïåò÷åð óñòðîéñòâ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\deviceproperties" /v "Icon" /t REG_SZ /d "DeviceProperties.exe,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\deviceproperties\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem mmc devmgmt.msc" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\diskmng" /v "MUIVerb" /t REG_SZ /d "Óïðàâëåíèå äèñêàìè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\diskmng" /v "Icon" /t REG_SZ /d "dmdskres.dll,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\diskmng\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem mmc diskmgmt.msc" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\propertiesadvanced" /v "MUIVerb" /t REG_SZ /d "Äîïîëíèòåëüíûå ïàðàìåòðû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\propertiesadvanced" /v "Icon" /t REG_SZ /d "SystemPropertiesAdvanced.exe,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\propertiesadvanced\command" /ve /t REG_SZ /d "SystemPropertiesAdvanced.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\services" /v "MUIVerb" /t REG_SZ /d "Ñëóæáû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\services" /v "Icon" /t REG_SZ /d "filemgmt.dll,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\services\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem mmc services.msc" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\gpedit" /v "MUIVerb" /t REG_SZ /d "Ðåäàêòîð ãðóïïîâîé ïîëèòèêè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\gpedit" /v "Icon" /t REG_SZ /d "gpedit.dll,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\gpedit\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem mmc gpedit.msc" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rsop" /v "MUIVerb" /t REG_SZ /d "Ðåäàêòîð ðåçóëüòèðóþùåé ïîëèòèêè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rsop" /v "Icon" /t REG_SZ /d "gpedit.dll,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rsop\command" /ve /t REG_SZ /d "mmc rsop.msc" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\taskschd" /v "MUIVerb" /t REG_SZ /d "Ïëàíèðîâùèê çàäàíèé" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\taskschd" /v "Icon" /t REG_SZ /d "miguiresource.dll,1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\taskschd\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem mmc taskschd.msc /s" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\eventvwr" /v "MUIVerb" /t REG_SZ /d "Ïðîñìîòð ñîáûòèé" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\eventvwr" /v "Icon" /t REG_SZ /d "miguiresource.dll,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\eventvwr\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem mmc eventvwr.msc /s" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\emptyclip" /ve /t REG_SZ /d "Î÷èñòèòü áóôåð îáìåíà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\emptyclip" /v "Icon" /t REG_SZ /d "shell32.dll,-254" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\emptyclip\command" /ve /t REG_SZ /d "nircmdc clipboard clear" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\clearrecycle" /ve /t REG_SZ /d "Î÷èñòèòü êîðçèíó è âðåìåííûå ôàéëû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\clearrecycle" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\clearrecycle" /v "Icon" /t REG_SZ /d "shell32.dll,-254" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\clearrecycle\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ClearTrashTemp.exe a" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cleardsk" /ve /t REG_SZ /d "Ïîëíàÿ î÷èñòêà äèñêîâ îò ìóñîðà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cleardsk" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cleardsk" /v "Icon" /t REG_SZ /d "cleanmgr.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cleardsk\command" /ve /t REG_SZ /d "nircmdc elevate %SystemRoot%\system32\cmd.exe /c cleanmgr /sageset:1 & cleanmgr /sagerun:1" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\clearreg" /ve /t REG_SZ /d "Îïòèìèçèðîâàòü è ñæàòü ðååñòð" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\clearreg" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\clearreg" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\RegistryFirstAid\RFA.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\clearreg\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\RegistryFirstAid\RFA.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\6to4" /ve /t REG_SZ /d "Óäàëèòü ëèøíèå 6to4 àäàïòåðû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\6to4" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\6to4" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\6to4remover.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\6to4\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\6to4remover.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reducemem" /ve /t REG_SZ /d "Î÷èñòèòü íåèñïîëüçóåìóþ ïàìÿòü" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reducemem" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reducemem" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ReduceMemory\ReduceMemory.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reducemem\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ReduceMemory\ReduceMemory.exe /O" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\speedy" /ve /t REG_SZ /d "Îïòèìèçèðîâàòü ðàáîòó áðàóçåðîâ/ñêàéïà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\speedy" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\speedy" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\speedyfox.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\speedy\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\speedyfox.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drivetidy" /ve /t REG_SZ /d "Î÷èñòèòü äèñê îò ìóñîðà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drivetidy" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drivetidy" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\DriveTidy\DriveTidy.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drivetidy\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\DriveTidy\DriveTidy.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\servopt" /ve /t REG_SZ /d "Îïòèìèçèðîâàòü ñëóæáû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\servopt" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\servopt" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\EasyServicesOptimizer\eso.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\servopt\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\EasyServicesOptimizer\eso.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\virscan" /ve /t REG_SZ /d "68 àíòèâèðóñîâ â îäíîì! (îí-ëàéí)" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\virscan" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\virscan" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\herdProtect\herdProtectScan.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\virscan\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\herdProtect\herdProtectScan.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\keylock" /ve /t REG_SZ /d "Ëîê/àíëîê ìûøè è êëàâèàòóðû (CtrLALtZ)" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\keylock" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\KeyFreeze\KeyFreeze_%arch%.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\keylock\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\KeyFreeze\KeyFreeze_%arch%.exe" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\keylock" /v "SubCommands" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\keylock_32" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\keylock_64" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\lockoffmon" /ve /t REG_SZ /d "Áëîêèðîâêà è âûêëþ÷åíèå ìîíèòîðà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\lockoffmon" /v "Icon" /t REG_SZ /d "imageres.dll,-101" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\lockoffmon\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\MonitorOff.bat" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\lock" /ve /t REG_SZ /d "Áëîêèðîâêà êîìïüþòåðà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\lock" /v "Icon" /t REG_SZ /d "shell32.dll,-48" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\lock\command" /ve /t REG_SZ /d "Rundll32 User32.dll,LockWorkStation" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\logoff" /ve /t REG_SZ /d "Âûõîä èç ñèñòåìû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\logoff" /v "Icon" /t REG_SZ /d "shell32.dll,-45" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\logoff\command" /ve /t REG_SZ /d "hidcon.exe shutdown -l" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\switch" /ve /t REG_SZ /d "Ñìåíèòü ïîëüçîâàòåëÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\switch" /v "Icon" /t REG_SZ /d "imageres.dll,-88" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\switch\command" /ve /t REG_SZ /d "tsdiscon.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sleep" /ve /t REG_SZ /d "Ðåæèì Ñîí" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sleep" /v "Icon" /t REG_SZ /d "imageres.dll,-101" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sleep\command" /ve /t REG_SZ /d "rundll32.exe powrprof.dll,SetSuspendState Sleep" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\hibernate" /ve /t REG_SZ /d "Ðåæèì Ãèáåðíàöèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\hibernate" /v "Icon" /t REG_SZ /d "shell32.dll,217" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\hibernate\command" /ve /t REG_SZ /d "hidcon.exe shutdown -h" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\restart" /ve /t REG_SZ /d "Ïåðåçàãðóçêà êîìïüþòåðà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\restart" /v "Icon" /t REG_SZ /d "shell32.dll,-290" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\restart\command" /ve /t REG_SZ /d "hidcon.exe shutdown -r -f -t 00" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rrestart" /ve /t REG_SZ /d "Óäàëåííàÿ ïåðåçàãðóçêà/âûêëþ÷åíèå" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rrestart" /v "Icon" /t REG_SZ /d "shell32.dll,-18" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rrestart\command" /ve /t REG_SZ /d "hidcon.exe shutdown /i" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\shutdown" /ve /t REG_SZ /d "Âûêëþ÷èòü êîìïüþòåð" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\shutdown" /v "Icon" /t REG_SZ /d "shell32.dll,-28" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\shutdown\command" /ve /t REG_SZ /d "hidcon.exe shutdown -s -f -t 00" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\hybridshutdown" /ve /t REG_SZ /d "Ãèáðèäíîå âûêëþ÷åíèå" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\hybridshutdown" /v "Icon" /t REG_SZ /d "shell32.dll,-221" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\hybridshutdown\command" /ve /t REG_SZ /d "hidcon.exe shutdown -s -f -t 00 -hybrid" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cancelshutdown" /ve /t REG_SZ /d "Îòìåíà âûêëþ÷åíèÿ/ïåðåçàãðóçêè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cancelshutdown" /v "Icon" /t REG_SZ /d "imageres.dll,-98" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\cancelshutdown\command" /ve /t REG_SZ /d "nircmdc elevatecmd runassystem \"shutdown.exe -a\"" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\mute" /ve /t REG_SZ /d "Ïðèãëóøèòü/âîçîáíîâèòü çâóê" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\mute" /v "Icon" /t REG_SZ /d "sndvol.exe,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\mute\command" /ve /t REG_SZ /d "nircmdc mutesysvolume 2" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\hide" /ve /t REG_SZ /d "Ñâåðíóòü/âîññòàíîâèòü âñå îêíà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\hide" /v "Icon" /t REG_SZ /d "explorer.exe,-103" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\hide\command" /ve /t REG_SZ /d "explorer shell:::{3080F90D-D7AD-11D9-BD98-0000947B0257}" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\topmost" /ve /t REG_SZ /d "Óñòàíîâèòü ïîâåðõ âñåõ îêîí" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\topmost" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\TopMost\TopMost.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\topmost\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\TopMost\TopMost.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\centerall" /ve /t REG_SZ /d "Îöåíòðîâàòü âñå îêíà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\centerall" /v "Icon" /t REG_SZ /d "shell32.dll,-268" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\centerall\command" /ve /t REG_SZ /d "nircmdc win center alltop" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\closeall" /ve /t REG_SZ /d "Çàêðûòü âñå îêíà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\closeall" /v "Icon" /t REG_SZ /d "shell32.dll,-240" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\closeall\command" /ve /t REG_SZ /d "nircmdc win close class CabinetWClass" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\winmanager" /ve /t REG_SZ /d "Óïðàâëåíèå çàâèñøèìè îêíàìè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\winmanager" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\winmanager" /v "Icon" /t REG_SZ /d "shell32.dll,-3" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\winmanager\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\WindowManager.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\webcam" /ve /t REG_SZ /d "Âêë/Âûêë âåá-êàìåðó" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\webcam" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\WebCam\WebCam.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\webcam\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\WebCam\WebCam.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\screen" /ve /t REG_SZ /d "Ñäåëàòü ñêðèíøîò ýêðàíà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\screen" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Screenshoter.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\screen\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Screenshoter.exe" /f 1>> %logfile% 2>>&1
	set calc=C:\Windows\System32\calc.exe
	if exist "C:\Windows\System32\calc1.exe" set calc=C:\Windows\System32\calc1.exe
	if exist "C:\Windows\SysWOW64\calc1.exe" set calc=C:\Windows\SysWOW64\calc1.exe
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\calc" /v "CommandFlags" /t REG_DWORD /d "32" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\calc" /ve /t REG_SZ /d "Êàëüêóëÿòîð" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\calc" /v "Icon" /t REG_SZ /d "%calc%" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\calc\command" /ve /t REG_SZ /d "%calc%" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\notepad" /ve /t REG_SZ /d "Áëîêíîò" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\notepad" /v "Icon" /t REG_SZ /d "notepad.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\notepad\command" /ve /t REG_SZ /d "notepad.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\paint" /ve /t REG_SZ /d "Paint" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\paint" /v "Icon" /t REG_SZ /d "mspaint.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\paint\command" /ve /t REG_SZ /d "mspaint.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\wordpad" /ve /t REG_SZ /d "Wordpad" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\wordpad" /v "Icon" /t REG_SZ /d "write.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\wordpad\command" /ve /t REG_SZ /d "wordpad.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\snip" /ve /t REG_SZ /d "Íîæíèöû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\snip" /v "Icon" /t REG_SZ /d "SnippingTool.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\snip\command" /ve /t REG_SZ /d "SnippingTool.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\iexplore" /ve /t REG_SZ /d "Internet Explorer" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\iexplore" /v "Icon" /t REG_SZ /d "%ProgramFiles%\Internet Explorer\iexplore.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\iexplore\command" /ve /t REG_SZ /d "%ProgramFiles%\Internet Explorer\iexplore.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\osk" /ve /t REG_SZ /d "Ýêðàííàÿ êëàâèàòóðà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\osk" /v "Icon" /t REG_SZ /d "osk.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\osk\command" /ve /t REG_SZ /d "osk.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\charmap" /ve /t REG_SZ /d "Òàáëèöà ñèìâîëîâ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\charmap" /v "Icon" /t REG_SZ /d "charmap.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\charmap\command" /ve /t REG_SZ /d "charmap.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\appwiz" /ve /t REG_SZ /d "Ïðîãðàììû è êîìïîíåíòû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\appwiz" /v "Icon" /t REG_SZ /d "appwiz.cpl" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\appwiz\command" /ve /t REG_SZ /d "control appwiz.cpl" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reloadex" /ve /t REG_SZ /d "Ïåðåçàãðóçèòü îáîëî÷êó (ïðîâîäíèê)" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reloadex" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reloadex" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Rexplorer.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reloadex\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\Rexplorer.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\runblock" /ve /t REG_SZ /d "Áëîêèðîâàòü âàæíûå ïðèëîæåíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\runblock" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\runblock" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\RunBlock\RunBlock.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\runblock\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\RunBlock\RunBlock.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\showsysfiles" /ve /t REG_SZ /d "Ïîêàçàòü/ñêðûòü ñêðûòûå ôàéëû è ïàïêè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\showsysfiles" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\showsysfiles" /v "Icon" /t REG_SZ /d "shell32.dll,-278" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\showsysfiles\command" /ve /t REG_EXPAND_SZ /d "wscript.exe %SystemRoot%\Tools\ShowSysFiles.vbs" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reiconcache" /ve /t REG_SZ /d "Ïåðåñòðîèòü êýø çíà÷êîâ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reiconcache" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reiconcache" /v "Icon" /t REG_SZ /d "shell32.dll,-289" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\reiconcache\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\ReIconCache.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\dpstyle" /ve /t REG_SZ /d "Ïðîñìîòðåòü ðàçìåòêó äèñêîâ/ðàçäåëîâ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\dpstyle" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\DPStyle.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\dpstyle\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\DPStyle.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\copyip" /ve /t REG_SZ /d "Ñêîïèðîâàòü áåëûé àäðåñ IPv4 â áóôåð" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\copyip" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\CopyIP.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\copyip\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\CopyIP.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\goping" /ve /t REG_SZ /d "Óòèëèòà Ïèíã (GoPing)" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\goping" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\GoPing\GoPing.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\goping\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\GoPing\GoPing.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\updtime" /ve /t REG_SZ /d "Îáíîâèòü ëîêàëüíîå âðåìÿ è äàòó" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\updtime" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\UpdateTime\UpdateTime.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\updtime\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\UpdateTime\UpdateTime.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\http" /ve /t REG_SZ /d "Çàïóñòèòü Web-ñåðâåð (Apache/PHP/MySql)" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\http" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\http" /v "Icon" /t REG_SZ /d "shell32.dll,-244" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\http\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Web-Server\UniController.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixbrowsers" /ve /t REG_SZ /d "Èñïðàâèòü îøèáêè âî ìíîãèõ áðàóçåðàõ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixbrowsers" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixbrowsers" /v "Icon" /t REG_SZ /d "ieframe.dll,-190" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixbrowsers\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\fixBrowsers.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\macchanger" /ve /t REG_SZ /d "Ñìåíèòü/âîññòàíîâèòü MAC-àäðåñ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\macchanger" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\macchanger" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\MacAddrChanger.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\macchanger\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\MacAddrChanger.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\tcpoptimizer" /ve /t REG_SZ /d "Îïòèìèçàöèÿ ñåòåâîãî ñîåäèíåíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\tcpoptimizer" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\tcpoptimizer" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\TCPOptimizer.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\tcpoptimizer\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevate %SystemRoot%\Tools\TCPOptimizer.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\netfix" /ve /t REG_SZ /d "Èñïðàâèòü ðàçëè÷íûå ïðîáëåìû ñ ñåòüþ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\netfix" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\netfix" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ComIntRep\ComIntRep_%arch%.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\netfix\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ComIntRep\ComIntRep_%arch%.exe" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\netfix" /v "SubCommands" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\intrep_x86" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\intrep_x64" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixprints" /ve /t REG_SZ /d "Èñïðàâèòü äèñïåò÷åð î÷åðåäè ïå÷àòè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixprints" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixprints" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\FixPrintSpooler\FixSpooler_%arch%.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixprints\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\FixPrintSpooler\FixSpooler_%arch%.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drive-clean" /ve /t REG_SZ /d "Î÷èñòèòü âñå íåèñïîëüçóåìûå óñòðîéñòâà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drive-clean" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drive-clean" /v "Icon" /t REG_SZ /d "devmgr.dll,4" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drive-clean\command" /ve /t REG_EXPAND_SZ /d "nircmdc elevatecmd runassystem \"%SystemRoot%\Tools\DriveCleanup\DriveCleanup_%arch%.exe -n\"" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drive-clean" /v "SubCommands" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drvcln_x86" /f 1>> %logfile% 2>>&1
	%rgd% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\drvcln_x64" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\res_reicon" /ve /t REG_SZ /d "&Âîññòàíîâèòü ñõåìó ðàñïîëîæåíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\res_reicon" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\res_reicon" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ReIcon\ReIcon.exe,5" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\res_reicon\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ReIcon\ReIcon.exe /Restore" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\save_reicon" /ve /t REG_SZ /d "&Ñîõðàíèòü ñõåìó ðàñïîëîæåíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\save_reicon" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\save_reicon" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ReIcon\ReIcon.exe,6" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\save_reicon\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ReIcon\ReIcon.exe /Save" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\launch_reicon" /v "CommandFlags" /t REG_DWORD /d "32" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\launch_reicon" /ve /t REG_SZ /d "&Çàïóñòèòü óòèëèòó" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\launch_reicon" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\launch_reicon" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ReIcon\ReIcon.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\launch_reicon\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\ReIcon\ReIcon.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\control" /ve /t REG_SZ /d "Ïàíåëü óïðàâëåíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\control" /v "Icon" /t REG_SZ /d "control.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\control\command" /ve /t REG_SZ /d "control.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sysdir" /ve /t REG_SZ /d "Ñèñòåìíûå ïàïêè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sysdir" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Ex-Dir.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sysdir\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Ex-Dir.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\devmgr" /ve /t REG_SZ /d "Äèñïåò÷åð óñòðîéñòâ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\devmgr" /v "Icon" /t REG_SZ /d "DeviceProperties.exe,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\devmgr\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\system32\mmc.exe /s %SystemRoot%\system32\devmgmt.msc" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folderoptions" /ve /t REG_SZ /d "Ñâîéñòâà ïàïêè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folderoptions" /v "Icon" /t REG_SZ /d "explorer.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\folderoptions\command" /ve /t REG_SZ /d "control folders" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\networksh" /ve /t REG_SZ /d "Öåíòð óïðàâëåíèÿ ñåòÿìè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\networksh" /v "Icon" /t REG_SZ /d "networkexplorer.dll,4" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\networksh\command" /ve /t REG_SZ /d "control /name Microsoft.NetworkAndSharingCenter" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\power" /ve /t REG_SZ /d "Ýëåêòðîïèòàíèå" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\power" /v "Icon" /t REG_SZ /d "powercfg.cpl" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\power\command" /ve /t REG_SZ /d "control powercfg.cpl" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\instinfo" /ve /t REG_SZ /d "Ñïèñîê ïðîãðàìì" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\instinfo" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\InstallInfo.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\instinfo\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\InstallInfo.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\regedit" /ve /t REG_SZ /d "Ðåäàêòîð ðååñòðà" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\regedit" /v "Icon" /t REG_SZ /d "regedit.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\regedit\command" /ve /t REG_SZ /d "devxexec.exe /user:TrustedInstaller regedit.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rstrui" /ve /t REG_SZ /d "Âîññòàíîâëåíèå ñèñòåìû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rstrui" /v "Icon" /t REG_SZ /d "rstrui.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rstrui\command" /ve /t REG_SZ /d "rstrui.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\search" /ve /t REG_SZ /d "Áûñòðûé ïîèñê ôàéëîâ è ïàïîê" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\search" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Everything\Everything.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\search\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Everything\Everything.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\scanner" /ve /t REG_SZ /d "Îöåíêà ìåñòà íà äèñêàõ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\scanner" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Scanner\Scanner.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\scanner\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\Scanner\Scanner.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sysdm" /ve /t REG_SZ /d "Ñâîéñòâà ñèñòåìû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sysdm" /v "Icon" /t REG_SZ /d "sysdm.cpl" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sysdm\command" /ve /t REG_SZ /d "control sysdm.cpl" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\taskmgr" /ve /t REG_SZ /d "Äèñïåò÷åð çàäà÷" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\taskmgr" /v "Icon" /t REG_SZ /d "taskmgr.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\taskmgr\command" /ve /t REG_SZ /d "devxexec.exe /user:TrustedInstaller taskmgr.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sfcfix" /ve /t REG_SZ /d "Èñïðàâëåíèå îøèáîê Öåíòðà îáíîâëåíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sfcfix" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sfcfix" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\SFCFix.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\sfcfix\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\SFCFix.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixwin" /ve /t REG_SZ /d "Ìåíåäæåð èñïðàâëåíèé îøèáîê" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixwin" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixwin" /v "Icon" /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\fixWin\fixWin.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\fixwin\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\Tools\fixWin\FixWin.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\perfmon" /ve /t REG_SZ /d "Ìîíèòîð ðåñóðñîâ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\perfmon" /v "Icon" /t REG_SZ /d "imageres.dll,144" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\perfmon\command" /ve /t REG_SZ /d "perfmon.exe /res" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\relmon" /ve /t REG_SZ /d "Ìîíèòîð íàäåæíîñòè ñèñòåìû" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\relmon" /v "Icon" /t REG_SZ /d "perfmon.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\relmon\command" /ve /t REG_SZ /d "perfmon.exe /rel" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\trouble" /ve /t REG_SZ /d "Óñòðàíåíèå íåïîëàäîê" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\trouble" /v "Icon" /t REG_SZ /d "imageres.dll,124" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\trouble\command" /ve /t REG_SZ /d "control /name Microsoft.Troubleshooting" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\useracc" /ve /t REG_SZ /d "Ó÷åòíûå çàïèñè" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\useracc" /v "Icon" /t REG_SZ /d "imageres.dll,74" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\useracc\command" /ve /t REG_SZ /d "Control userpasswords" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\useracc2" /ve /t REG_SZ /d "Ó÷åòíûå çàïèñè (êëàññè÷.)" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\useracc2" /v "Icon" /t REG_SZ /d "shell32.dll,111" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\useracc2\command" /ve /t REG_SZ /d "Control userpasswords2" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rdp" /ve /t REG_SZ /d "Óäàëåííûé ðàáî÷èé ñòîë (RDP)" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rdp" /v "Icon" /t REG_SZ /d "mstsc.exe,0" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\rdp\command" /ve /t REG_SZ /d "mstsc.exe" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\network" /ve /t REG_SZ /d "Ñåòåâûå ïîäêëþ÷åíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\network" /v "Icon" /t REG_SZ /d "ncpa.cpl" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\network\command" /ve /t REG_SZ /d "control ncpa.cpl" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\wf" /ve /t REG_SZ /d "Áðàíäìàóýð Windows" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\wf" /v "Icon" /t REG_SZ /d "wscui.cpl,3" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\wf\command" /ve /t REG_EXPAND_SZ /d "%SystemRoot%\system32\mmc.exe /s %SystemRoot%\system32\wf.msc" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\wu" /ve /t REG_SZ /d "Öåíòð îáíîâëåíèÿ" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\wu" /v "Icon" /t REG_SZ /d "shell32.dll,46" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\wu\command" /ve /t REG_SZ /d "explorer ms-settings:windowsupdate" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\run" /ve /t REG_SZ /d "Âûïîëíèòü" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\run" /v "Icon" /t REG_SZ /d "shell32.dll,24" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\run" /v "HasLUAShield" /t REG_SZ /d "" /f 1>> %logfile% 2>>&1
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\run\command" /ve /t REG_SZ /d "explorer.exe shell:::{2559A1F3-21D7-11D4-BDAF-00C04F60B9F0}" /f 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	@echo. 1>> %logfile%
)
@echo %clr%[36m Äîáàâèòü ðàñøèðåíèå XnShell â êîíòåêñòíîå ìåíþ äëÿ ïðîñìîòðà ïðåâüþ èçîáðàæåíèé è èõ ðåäàêòèðîâàíèÿ?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÄîáàâëåíèå ðàñøèðåíèÿ XnShell â êîíòåêñòíîå ìåíþ äëÿ ïðîñìîòðà ïðåâüþ èçîáðàæåíèé è èõ ðåäàêòèðîâàíèÿ. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Äîáàâëåíèå ðàñøèðåíèÿ XnShell â êîíòåêñòíîå ìåíþ äëÿ ïðîñìîòðà ïðåâüþ èçîáðàæåíèé è èõ ðåäàêòèðîâàíèÿ. 1>> %logfile%
	set timerStart=!time!
	start "" /wait "%~dp0..\Installers\XnShellEx.exe"
	reg import "%SystemRoot%\Tools\XnShellEx\XnShellExt.reg"
	regsvr32 /s "%SystemRoot%\Tools\XnShellEx\XnViewShellExt64.dll"
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Äîáàâèòü â àâòîçàãðóçêó óòèëèòó ClipAngel äëÿ çàõâàòà äàííûõ â áóôåðå îáìåíà äëÿ ïîñëåäóþùåãî ïðîñìîòðà?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÄîáàâëåíèå â àâòîçàãðóçêó óòèëèòû ClipAngel äëÿ çàõâàòà äàííûõ â áóôåðå îáìåíà äëÿ ïîñëåäóþùåãî ïðîñìîòðà. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Äîáàâëåíèå â àâòîçàãðóçêó óòèëèòû ClipAngel äëÿ çàõâàòà äàííûõ â áóôåðå îáìåíà äëÿ ïîñëåäóþùåãî ïðîñìîòðà. 1>> %logfile%
	set timerStart=!time!
	start "" /wait "%~dp0..\Installers\ClipAngel.exe"
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ClipAngel" /t REG_SZ /d "%SystemRoot%\Tools\ClipAngel\ClipAngel.exe" /f 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Äîáàâèòü â àâòîçàãðóçêó óòèëèòó X-Mouse Button Control äëÿ òîíêîé íàñòðîéêè äîïîëíèòåëüíûõ âîçìîæíîñòåé ìûøè?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÄîáàâëåíèå â àâòîçàãðóçêó óòèëèòû X-Mouse Button Control äëÿ òîíêîé íàñòðîéêè äîïîëíèòåëüíûõ âîçìîæíîñòåé ìûøè. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Äîáàâëåíèå â àâòîçàãðóçêó óòèëèòû X-Mouse Button Control äëÿ òîíêîé íàñòðîéêè äîïîëíèòåëüíûõ âîçìîæíîñòåé ìûøè. 1>> %logfile%
	set timerStart=!time!
	start "" /wait "%~dp0..\Installers\XMouseButtonControl.exe"
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "XMouseButtonControl" /t REG_SZ /d "%SystemRoot%\Tools\XMouseButtonControl\XMouseButtonControl.exe" /f 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
rem #########################################################################################################################################################################################################################
@echo %clr%[36m Óìåíüøèòü ðàçìåð áóôåðà ìûøè è êëàâèàòóðû.%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m åñëè ìûøü âåäåò ñåáÿ íåêîððåêòíî, óâåëè÷üòå äàííûå çíà÷åíèÿ äî 100.
@echo Óìåíüøèòü ðàçìåð áóôåðà ìûøè è êëàâèàòóðû. Ïðåäóïðåæäåíèå: åñëè ìûøü âåäåò ñåáÿ íåêîððåêòíî, óâåëè÷üòå äàííûå çíà÷åíèÿ äî 100. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "16" /f 1>> %logfile% 2>>&1
rem %rgd% "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "16" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
rem @echo %clr%[36m Îòêëþ÷èòü ñ÷åò÷èêè ïðîèçâîäèòåëüíîñòè.%clr%[92m %clr%[7;31mÂíèìàíèå: ïîñëå îòêëþ÷åíèÿ ñëóæáû, íàáëþäàåòñÿ íåñòàáèëüíîñòü ñèñòåìû è íåðàáîòîñïîñîáíîñòü äèñïåò÷åðà çàäà÷.%clr%[0m%clr%[36m%clr%[92m
rem set timerStart=!time!
rem call :disable_svc pcw
rem set timerEnd=!time!
rem call :timer
rem @echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
rem echo. 1>> %logfile% 2>>&1
@echo %clr%[36m Îòêëþ÷èòü PPM, òåì ñàìûì óìåíüøèòü çàäåðæêó â èãðàõ è íàãðóçêó íà SSD.%clr%[92m
@echo Îòêëþ÷èòü PPM, òåì ñàìûì óìåíüøèòü çàäåðæêó â èãðàõ è íàãðóçêó íà SSD. 1>> %logfile%
set timerStart=!time!
call :disable_svc AmdK8
call :disable_svc intelppm
call :disable_svc AmdPPM
call :disable_svc Processor
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óñêîðèòü çàâåðøåíèå îáíàðóæåíèÿ è âîññòàíîâëåíèÿ òàéì-àóòà (TDR).%clr%[92m %clr%[7;31mÏðèìå÷àíèå:%clr%[0m%clr%[36m%clr%[92m ïîìîãàåò èçáàâèòüñÿ îò àâàðèéíîãî çàâåðøåíèÿ äðàéâåðà âèäåîêàðò ïðè äëèòåëüíûõ âû÷èñëåíèÿõ.
@echo Óñêîðèòü çàâåðøåíèå îáíàðóæåíèÿ è âîññòàíîâëåíèÿ òàéì-àóòà (TDR). Ïðèìå÷àíèå: ïîìîãàåò èçáàâèòüñÿ îò àâàðèéíîãî çàâåðøåíèÿ äðàéâåðà âèäåîêàðò ïðè äëèòåëüíûõ âû÷èñëåíèÿõ. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDelay" /t REG_DWORD /d "60" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "TdrDdiDelay" /t REG_DWORD /d "60" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü ñîñòîÿíèå ñâåðõíèçêîãî ýíåðãîïîòðåáëåíèÿ äëÿ âèäåîêàðò Intel è AMD (ULPS).%clr%[92m %clr%[7;31mÏðèìå÷àíèå:%clr%[0m%clr%[36m%clr%[92m ïîìîãàåò èçáàâèòüñÿ îò ôðèçîâ íà ñòàðûõ è íå îïòèìèçèðîâàííûõ èãðàõ.
@echo Îòêëþ÷èòü ñîñòîÿíèå ñâåðõíèçêîãî ýíåðãîïîòðåáëåíèÿ äëÿ âèäåîêàðò Intel è AMD (ULPS). Ïðèìå÷àíèå: Ïîìîãàåò èçáàâèòüñÿ îò ôðèçîâ íà ñòàðûõ è íå îïòèìèçèðîâàííûõ èãðàõ. 1>> %logfile%
set timerStart=!time!
for /f "tokens=* delims=" %%l in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E968-E325-11CE-BFC1-08002BE10318}" /s /v "DriverDesc"^|FindStr HKEY_') do (%rga% "%%l" /v "EnableUlps" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1)
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
if "%arch%"=="x64" (
	@echo %clr%[36m Óñòàíîâèòü UWP ïàíåëü óïðàâëåíèÿ NVIDIA v.8.1.962.0?%clr%[92m
	choice /c yn /n /t %autoChoose% /d n /m %keySelN%
	if !errorlevel!==1 (
		@echo %clr%[0m %clr%[93mÓñòàíîâêà ïàíåëè óïðàâëåíèÿ NVIDIA v.8.1.962.0. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
		@echo Óñòàíîâêà ïàíåëè óïðàâëåíèÿ NVIDIA v.8.1.962.0. 1>> %logfile%
		set timerStart=!time!
		%PS% "Add-AppxPackage -Path '%~dp0NVIDIA\NVIDIACorp.NVIDIAControlPanel_8.1.962.0_x64__56jybvy8sckqj.Appx'" 1>> %logfile% 2>>&1
		call :auto_svc NVDisplay.ContainerLocalSystem
		set timerEnd=!time!
		call :timer
		@echo ÎÊ %clr%[93m[%clr%[91m!mins!%clr%[0m ìèíóò %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
		echo. 1>> %logfile%
	)
)
@echo %clr%[36m Âêëþ÷èòü ïîääåðæêó ñãëàæèâàíèÿ àíèìàöèè â äðàéâåðå NVIDIA (SILK Smooth).%clr%[92m %clr%[7;31mÏðèìå÷àíèå:%clr%[0m%clr%[36m%clr%[92m ïîìîãàåò ïðè ìèêðîôðèçàõ â èãðàõ. Ïîñëåäíÿÿ ïîääåðæêà SILK ñîäåðæèòñÿ â äðàéâåðå 442.74 è íàñòðàèâàåòñÿ â ïàíåëè óïðàâëåíèÿ NVIDIA.
@echo Âêëþ÷èòü ïîääåðæêó ñãëàæèâàíèÿ àíèìàöèè â äðàéâåðå NVIDIA (SILK Smooth). Ïðèìå÷àíèå: ïîìîãàåò ïðè ìèêðîôðèçàõ â èãðàõ. Ïîñëåäíÿÿ ïîääåðæêà SILK ñîäåðæèòñÿ â äðàéâåðå 442.74 è íàñòðàèâàåòñÿ â ïàíåëè óïðàâëåíèÿ NVIDIA. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" /v "EnableRID61684" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷åíèå ìíîãîïëîñêîñòíîãî íàëîæåíèÿ (MPO) äëÿ èñïðàâëåíèÿ ìåðöàíèÿ ïðèëîæåíèé ïðè èçìåíåíèè ðàçìåðà îêíà ïîñëå îáíîâëåíèÿ äðàéâåðà îò NVIDIA Game Ready Driver 461.09 è âûøå.%clr%[92m
@echo Îòêëþ÷åíèå ìíîãîïëîñêîñòíîãî íàëîæåíèÿ (MPO) äëÿ èñïðàâëåíèÿ ìåðöàíèÿ ïðèëîæåíèé ïðè èçìåíåíèè ðàçìåðà îêíà ïîñëå îáíîâëåíèÿ äðàéâåðà îò NVIDIA Game Ready Driver 461.09 è âûøå. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v "OverlayTestMode" /t REG_DWORD /d "5" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïðèíóäèòåëüíîå âûäåëåíèå íåïðåðûâíîé ïàìÿòè â äðàéâåðå NVIDIA.%clr%[92m %clr%[7;31mÏðèìå÷àíèå:%clr%[0m%clr%[36m%clr%[92m âåòêà 0000 ìîæåò îòëè÷àòüñÿ â çàâèñèìîñòè îò íîìåðà ãðàôè÷åñêîãî ïðîöåññîðà.
@echo Ïðèíóäèòåëüíîå âûäåëåíèå íåïðåðûâíîé ïàìÿòè â äðàéâåðå NVIDIA. Ïðèìå÷àíèå: âåòêà 0000 ìîæåò îòëè÷àòüñÿ â çàâèñèìîñòè îò íîìåðà ãðàôè÷åñêîãî ïðîöåññîðà. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PreferSystemMemoryContiguous" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âêëþ÷åíèå ïîëíîãî öâåòîâîãî äèàïàçîíà íà âèäåîêàðòàõ NVIDIA.%clr%[92m
@echo Âêëþ÷åíèå ïîëíîãî öâåòîâîãî äèàïàçîíà íà âèäåîêàðòàõ NVIDIA. 1>> %logfile%
set timerStart=!time!
for /f "tokens=* delims=" %%i in ('reg query "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /s /v "HardwareInformation.AdapterString"^|FindStr HKEY_') do ( %rga% "%%i" /v "SetDefaultFullRGBRangeOnHDMI" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1 )
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Îòêëþ÷èòü êîä èñïðàâëåíèÿ îøèáîê (ECC) íà âèäåîêàðòàõ NVIDIA.%clr%[92m
@echo Îòêëþ÷èòü êîä èñïðàâëåíèÿ îøèáîê (ECC) íà âèäåîêàðòàõ NVIDIA. 1>> %logfile%
set timerStart=!time!
if exist "%ProgramFiles%\NVIDIA Corporation\NVSMI\nvidia-smi.exe" ( "%ProgramFiles%\NVIDIA Corporation\NVSMI\nvidia-smi.exe" -e 0 1>> %logfile% 2>>&1 )
if exist "%SystemRoot%\System32\nvidia-smi.exe" ( "%SystemRoot%\System32\nvidia-smi.exe" -e 0 1>> %logfile% 2>>&1 )
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïåðåêëþ÷èòü ðåæèì äðàéâåðà èç WDDM â Tesla Compute Cluster (TCC) íà âèäåîêàðòàõ NVIDIA.%clr%[92m %clr%[7;31mÏðèìå÷àíèå:%clr%[0m%clr%[36m%clr%[92m Ïîääåðæèâàåòñÿ òîëüêî âèäåîêàðòàìè Quadro è Tesla.
@echo Ïåðåêëþ÷èòü ðåæèì äðàéâåðà èç WDDM â Tesla Compute Cluster (TCC) íà âèäåîêàðòàõ NVIDIA. Ïîääåðæèâàåòñÿ òîëüêî âèäåîêàðòàìè Quadro è Tesla. 1>> %logfile%
set timerStart=!time!
if exist "%ProgramFiles%\NVIDIA Corporation\NVSMI\nvidia-smi.exe" ( "%ProgramFiles%\NVIDIA Corporation\NVSMI\nvidia-smi.exe" -fdm 1 1>> %logfile% 2>>&1 )
if exist "%SystemRoot%\System32\nvidia-smi.exe" ( "%SystemRoot%\System32\nvidia-smi.exe" -fdm 1 1>> %logfile% 2>>&1 )
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïðèíóäèòåëüíîå âûäåëåíèå íåïðåðûâíîé ïàìÿòè â ãðàôè÷åñêîì ÿäðå DirectX.%clr%[92m
@echo Ïðèíóäèòåëüíîå âûäåëåíèå íåïðåðûâíîé ïàìÿòè â ãðàôè÷åñêîì ÿäðå DirectX. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "DpiMapIommuContiguous" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïðèìåíåíèå îïòèìèçàöèè V-Sync äëÿ óñêîðåíèÿ èãð.%clr%[92m
@echo Ïðèìåíåíèå îïòèìèçàöèè V-Sync äëÿ óñêîðåíèÿ èãð. 1>> %logfile%
set timerStart=!time!
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d "1" /f 1>> %logfile% 2>>&1
%rga% "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "VsyncIdleTimeout" /t REG_DWORD /d "0" /f 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Âûáåðèòå æåëàåìîå ïðèëîæåíèå èëè èãðó äëÿ óñòàíîâêè âûñîêîïðîèçâîäèòåëüíîãî ïðèîðèòåòà DirectX è èñïîëüçîâàíèÿ âèðòóàëüíîãî àäðåñíîãî ïðîñòðàíñòâà äëÿ ñíèæåíèÿ ìèêðîôðèçîâ.%clr%[92m
@echo Âûáåðèòå æåëàåìîå ïðèëîæåíèå èëè èãðó äëÿ óñòàíîâêè âûñîêîïðîèçâîäèòåëüíîãî ïðèîðèòåòà DirectX è èñïîëüçîâàíèÿ âèðòóàëüíîãî àäðåñíîãî ïðîñòðàíñòâà äëÿ ñíèæåíèÿ ìèêðîôðèçîâ. 1>> %logfile%
set timerStart=!time!
%PS% "%~dp0AppGraphicsPerformance.ps1" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óñòàíîâêà îïòèìèçèðîâàííîãî ïðîôèëÿ NVIDIA.%clr%[92m
@echo Óñòàíîâêà îïòèìèçèðîâàííîãî ïðîôèëÿ NVIDIA. 1>> %logfile%
set timerStart=!time!
md "%ProgramData%\NVIDIA Corporation\Drs" 1>> %logfile% 2>>&1
start "" /wait "%~dp0..\Tools\nvidiaProfileInspector.exe" "%~dp0nvprofile.nip"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïðîãðàììà äëÿ íàñòðîéêè çàäåðæêàìè ïðåðûâàíèé íà óñòðîéñòâàõ (MSI Mode).%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m ïðèìåíÿéòå ïàðàìåòðû òîëüêî äëÿ óñòðîéñòâ ñ ïîääåðæêîé MSI Mode.
@echo Ïðîãðàììà äëÿ íàñòðîéêè çàäåðæêàìè ïðåðûâàíèé íà óñòðîéñòâàõ (MSI Mode). Ïðåäóïðåæäåíèå: ïðèìåíÿéòå ïàðàìåòðû òîëüêî äëÿ óñòðîéñòâ ñ ïîääåðæêîé msi. 1>> %logfile%
set timerStart=!time!
start "" /wait "%~dp0MSI_util_v3.exe"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óñòàíîâêà èíñòðóìåíòà äëÿ ïðèìåíåíèÿ ìàêñèìàëüíîãî ðàçðåøåíèÿ òàéìåðà ïðè çàïóñêå ÎÑ (ïðîâåðèòü çíà÷åíèå òàéìåðà ìîæíî ñ ïîìîùüþ óòèëèòû TimerTool, íàõîäÿùåéñÿ â ïàïêå Apps).%clr%[92m
@echo Óñòàíîâêà èíñòðóìåíòà äëÿ ïðèìåíåíèÿ ìàêñèìàëüíîãî ðàçðåøåíèÿ òàéìåðà ïðè çàïóñêå ÎÑ (ïðîâåðèòü çíà÷åíèå òàéìåðà ìîæíî ñ ïîìîùüþ óòèëèòû TimerTool, íàõîäÿùåéñÿ â ïàïêå Apps) 1>> %logfile%
set timerStart=!time!
net stop STR 1>> %logfile% 2>>&1
start "" /wait /min %SystemRoot%\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe /u %~dp0TimerResolution.exe
start "" /wait /min %SystemRoot%\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe /i %~dp0TimerResolution.exe
net start STR 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïðèìåíåíèå èíñòðóìåíòà â àâòîçàãðóçêó äëÿ îòêëþ÷åíèÿ ýíåðãîñáåðåæåíèÿ æåñòêèõ äèñêîâ.%clr%[92m
@echo Ïðèìåíåíèå èíñòðóìåíòà â àâòîçàãðóçêó äëÿ îòêëþ÷åíèÿ ýíåðãîñáåðåæåíèÿ æåñòêèõ äèñêîâ. 1>> %logfile%
set timerStart=!time!
call :kill "quietHDD.exe"
start "" /wait "%~dp0..\Installers\quietHDD.exe"
%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "quietHDD" /t REG_SZ /d "\"%SystemRoot%\Tools\quietHDD\quietHDD.exe\" /NOTRAY /ACAPMVALUE:255 /DCAPMVALUE:255 /ACAAMVALUE:254 /DCAAMVALUE:254 /NOWARN" /f 1>> %logfile% 2>>&1
rem reg unload "HKU\.DEFAULT" 1>> %logfile% 2>>&1
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Ïðîãðàììà äëÿ îòêëþ÷åíèÿ ëåíòû èç ïðîâîäíèêà.%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m ïîñëå ïðèìåíåíèÿ èçìåíåíèé íå íàæèìàéòå êíîïêó Yes äëÿ äàëüíåéøåãî ïðèìåíåíèÿ ñêðèïòà.
@echo Ïðîãðàììà äëÿ îòêëþ÷åíèÿ ëåíòû èç ïðîâîäíèêà. Ïðåäóïðåæäåíèå: ïîñëå ïðèìåíåíèÿ èçìåíåíèé íå íàæèìàéòå êíîïêó Yes äëÿ äàëüíåéøåãî ïðèìåíåíèÿ ñêðèïòà. 1>> %logfile%
set timerStart=!time!
call :acl_file-folders "%SystemRoot%\System32\ExplorerFrame.dll"
call :acl_file-folders "%SystemRoot%\System32\ExplorerFrame.dll.151"
call :acl_file-folders "%SystemRoot%\System32\ExplorerFrame.dll.winaero"
rem %rf% "%SystemRoot%\System32\ExplorerFrame.dll.151" 1>> %logfile% 2>>&1
start "" /wait "%~dp0RibbonDisabler.exe"
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Óñòàíîâèòü êëàññè÷åñêèé êàëüêóëÿòîð è msconfig îò Windows 7?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÓñòàíîâêà êëàññè÷åñêîãî êàëüêóëÿòîðà è msconfig îò Windows 7 â ðó÷íîì ðåæèìå. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Óñòàíîâêà êëàññè÷åñêîãî êàëüêóëÿòîðà è msconfig îò Windows 7 â ðó÷íîì ðåæèìå. 1>> %logfile%
	set timerStart=!time!
	start "" /wait "%~dp0ClassicCalculator.exe"
	start "" /wait "%~dp0ClassicMsconfig.exe"
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Óñòàíîâèòü ìóëüòèìåäèà ïðèëîæåíèå ^(FS êëèåíò^) äëÿ áåñïëàòíîãî îíëàéí ïðîñìîòðà ôèëüìîâ è ñåðèàëîâ?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÓñòàíîâêà ìóëüòèìåäèà ïðèëîæåíèÿ ^(FS êëèåíò^) äëÿ áåñïëàòíîãî îíëàéí ïðîñìîòðà ôèëüìîâ è ñåðèàëîâ. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Óñòàíîâêà ìóëüòèìåäèà ïðèëîæåíèÿ ^(FS êëèåíò^) äëÿ áåñïëàòíîãî îíëàéí ïðîñìîòðà ôèëüìîâ è ñåðèàëîâ. 1>> %logfile%
	set timerStart=!time!
	CheckNetIsolation LoopbackExempt -a -n="24831TIRRSOFT.FS_*_7dqv9t6ww56qc" 1>> %logfile% 2>>&1
	md "%~dp0FSClient" 1>> %logfile% 2>>&1
	rem curl -fSLo "%~dp0FSClient\FSClient.UWP.cer" "https://fsclient.github.io/fs/FSClient.UWP/FSClient.UWP.cer"
	rem curl -fSLo "%~dp0FSClient\FSClient.UWP.appxbundle" "https://fsclient.github.io/fs/FSClient.UWP/FSClient.UWP.appxbundle"
	%PS% "Invoke-WebRequest https://fsclient.github.io/fs/FSClient.UWP/FSClient.UWP.cer -OutFile '%~dp0FSClient\FSClient.UWP.cer'" 1>> %logfile% 2>>&1
	%PS% "Invoke-WebRequest https://fsclient.github.io/fs/FSClient.UWP/FSClient.UWP.appxbundle -OutFile '%~dp0FSClient\FSClient.UWP.appxbundle'" 1>> %logfile% 2>>&1
	certutil -enterprise -f -AddStore "Root" "%~dp0FSClient\FSClient.UWP.cer" 1>> %logfile% 2>>&1
	%PS% "Add-AppxPackage -Path '%~dp0FSClient\FSClient.UWP.appxbundle'" 1>> %logfile% 2>>&1
	%rf% "%~dp0FSClient\FSClient.UWP.cer" 1>> %logfile% 2>>&1
	%rf% "%~dp0FSClient\FSClient.UWP.appxbundle" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Óñòàíîâèòü ïðèëîæåíèå, ïîçâîëÿþùåå óïðàâëÿòü ãðîìêîñòüþ çâóêà ëþáîãî îòêðûòîãî ïðèëîæåíèÿ èç åäèíîé ïàíåëè?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÓñòàíîâêà ïðèëîæåíèÿ, ïîçâîëÿþùåãî óïðàâëÿòü ãðîìêîñòüþ çâóêà ëþáîãî îòêðûòîãî ïðèëîæåíèÿ èç åäèíîé ïàíåëè. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Óñòàíîâêà ïðèëîæåíèÿ, ïîçâîëÿþùåãî óïðàâëÿòü ãðîìêîñòüþ çâóêà ëþáîãî îòêðûòîãî ïðèëîæåíèÿ èç åäèíîé ïàíåëè. 1>> %logfile%
	set timerStart=!time!
	%PS% "Add-AppxPackage -Path '%~dp0EarTrumpet\40459File-New-Project.EarTrumpet_2.2.0.0_neutral___1sdd7yawvg6ne.AppxBundle'" 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âûñòàâèòü çíà÷êè ïàíåëè çàäà÷ ïî öåíòðó è ñïðÿòàòü çíà÷îê Ïóñê ^(ñòèëü Windows 11^)?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÓñòàíîâêà çíà÷êîâ ïàíåëè çàäà÷ ïî öåíòðó è ñêðûòèå çíà÷êà Ïóñê ^(ñòèëü Windows 11^). Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Óñòàíîâêà çíà÷êîâ ïàíåëè çàäà÷ ïî öåíòðó è ñêðûòèå çíà÷êà Ïóñê ^(ñòèëü Windows 11^). 1>> %logfile%
	set timerStart=!time!
	call :kill "TaskbarX.exe"
	start "" /wait "%~dp0..\Installers\TaskbarX.exe"
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "TaskbarX" /t REG_SZ /d "\"%SystemRoot%\Tools\TaskbarX\TaskbarX.exe\" -tbs=1 -color=0;0;0;50 -tpop=100 -tsop=100 -as=cubiceaseinout -obas=cubiceaseinout -tbr=0 -asp=300 -ptbo=0 -stbo=0 -lr=400 -oblr=400 -sr=0 -sr2=0 -sr3=0 -ftotc=1 -rzbt=1 -hps=1 -hss=1" /f 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Óñòàíîâèòü ïðèëîæåíèå äëÿ ñîçäàíèÿ ñíèìêîâ ýêðàíà è ñêðèíêàñòîâ ñî ìíîæåñòâîì íàñòðîåê?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÓñòàíîâêà ïðèëîæåíèÿ äëÿ ñîçäàíèÿ ñíèìêîâ ýêðàíà è ñêðèíêàñòîâ ñî ìíîæåñòâîì íàñòðîåê. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Óñòàíîâêà ïðèëîæåíèÿ äëÿ ñîçäàíèÿ ñíèìêîâ ýêðàíà è ñêðèíêàñòîâ ñî ìíîæåñòâîì íàñòðîåê. 1>> %logfile%
	set timerStart=!time!
	call :kill "ShareX.exe"
	start "" /wait "%~dp0..\Installers\ShareX.exe"
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ShareX" /t REG_SZ /d "%SystemRoot%\Tools\ShareX\ShareX.exe" /f 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Î÷èñòèòü ñëåäû ïîäêëþ÷åíèÿ USB-äèñêîâ è DVD-ROM äëÿ êîððåêòíîé ðàáîòû.%clr%[92m
@echo Î÷èñòèòü ñëåäû ïîäêëþ÷åíèÿ USB-äèñêîâ è DVD-ROM äëÿ êîððåêòíîé ðàáîòû. 1>> %logfile%
set timerStart=!time!
set saveregfile=%~dp0..\..\Backup\Backup_USB_DVD_%daytime%.reg
%~dp0..\Tools\USBOblivion_%arch%.exe -enable -auto -lang:19 -norestorepoint -norestart -noexplorer -silent -save:%saveregfile% -log:%logfile%
set timerEnd=!time!
call :timer
@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
echo. 1>> %logfile%
@echo %clr%[36m Äîáàâèòü óòèëèòó ìîíèòîðèíãà çàãðóçêè ñèñòåìû â àâòîçàãðóçêó?.%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÄîáàâëåíèå óòèëèòû ìîíèòîðèíãà çàãðóçêè ñèñòåìû â àâòîçàãðóçêó. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	@echo Äîáàâëåíèå óòèëèòû ìîíèòîðèíãà çàãðóçêè ñèñòåìû â àâòîçàãðóçêó. 1>> %logfile%
	set timerStart=!time!
	call :kill "EZUptime.exe"
	xcopy "%~dp0..\Tools\EZUptime.exe" "%SystemRoot%\Tools\EZUptime.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	start "" "%SystemRoot%\Tools\EZUptime.exe"
	%rga% "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "EZUptime" /t REG_SZ /d "%SystemRoot%\Tools\EZUptime.exe" /f 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Ñêðûòü âñå âîäÿíûå íàïîìèíàíèÿ îá àêòèâàöèè, òåñòîâîì, áåçîïàñíîì ðåæèìå è äðóãèå?%clr%[92m %clr%[7;31mÏðåäóïðåæäåíèå:%clr%[0m%clr%[36m%clr%[92m íå çàêðûâàéòå îêíà âûïîëíåíèÿ è íå íàæèìàéòå íà êíîïêè ïîäòâåðæäåíèÿ.
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo Ñêðûòü âñå âîäÿíûå íàïîìèíàíèÿ îá àêòèâàöèè, òåñòîâîì, áåçîïàñíîì ðåæèìå è äðóãèå. Ïðåäóïðåæäåíèå: íå çàêðûâàéòå îêíà âûïîëíåíèÿ è íå íàæèìàéòå íà êíîïêè ïîäòâåðæäåíèÿ. 1>> %logfile%
	set timerStart=!time!
	start "" /wait "%~dp0uwd_automate.exe"
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Óñòàíîâèòü óòèëèòó äëÿ îïòèìèçàöèè è âûáîðà ïðîôèëåé ïðîèçâîäèòåëüíîñòè CPU è GPU?.%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÓñòàíîâêà óòèëèòû äëÿ îïòèìèçàöèè è âûáîðà ïðîôèëåé ïðîèçâîäèòåëüíîñòè CPU è GPU. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Óñòàíîâêà óòèëèòû äëÿ îïòèìèçàöèè è âûáîðà ïðîôèëåé ïðîèçâîäèòåëüíîñòè CPU è GPU. 1>> %logfile%
	set timerStart=!time!
	start "" /wait "%~dp0..\Installers\ProfileSelector.exe"
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Ñîçäàòü ïàïêó ñ äîïîëíèòåëüíûìè óòèëèòàìè íà ðàáî÷åì ñòîëå?.%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÑîçäàíèå ïàïêè ñ äîïîëíèòåëüíûìè óòèëèòàìè íà ðàáî÷åì ñòîëå. Ïîæàëóéñòà ïîäîæäèòå...%clr%[92m
	@echo Ñîçäàíèå ïàïêè ñ äîïîëíèòåëüíûìè óòèëèòàìè íà ðàáî÷åì ñòîëå. 1>> %logfile%
	set timerStart=!time!
	xcopy "%~dp0nircmdc_%arch%.exe" "%SystemRoot%\System32\nircmdc.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0EmptyStandbyList.exe" "%SystemRoot%\Tools\EmptyStandbyList.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0MSI_util_v3.exe" "%SystemRoot%\Tools\MSI_util_v3.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\Tools\nvidiaProfileInspector.exe" "%SystemRoot%\Tools\nvidiaProfileInspector.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	echo F|xcopy "%~dp0AppGraphicsPerformance.ps1" "%SystemRoot%\Tools\AppGraphicsPerformance.ps1" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\Cleanmgr+" "%SystemRoot%\Tools\Cleanmgr+\*.*" /e /c /i /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\Tools\intPolicy_%arch%.exe" "%SystemRoot%\Tools\intPolicy_%arch%.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\NV RGBFullRangeToggle\NV_RGBFullRangeToggle.exe" "%SystemRoot%\Tools\NV_RGBFullRangeToggle.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\NVCleanstall\NVCleanstall_1.13.0.exe" "%SystemRoot%\Tools\NVCleanstall.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\QuickCPU" "%SystemRoot%\Tools\QuickCpu\*.*" /e /c /i /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\SetFSB 2.2.129.95" "%SystemRoot%\Tools\SetFSB 2.2.129.95\*.*" /e /c /i /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\TimerTool\TimerTool.exe" "%SystemRoot%\Tools\TimerTool.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\Tools\REAL.exe" "%SystemRoot%\Tools\REAL.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	xcopy "%~dp0..\vibranceGUI 2.3.1.1\vibranceGUI.exe" "%SystemRoot%\Tools\vibranceGUI.exe" /c /q /h /r /y 1>> %logfile% 2>>&1
	start "" /wait "%~dp0..\Installers\CompatibilityManager.exe"
	start "" /wait "%~dp0..\Installers\LatencyMon.exe"
	start "" /wait "%~dp0..\Installers\ExecutionMaster.exe"
	start "" /wait "%~dp0..\Installers\NoVideo_SRGB.exe"
	call :kill "ProcessLasso.exe"
	call :kill "bitsumsessionagent.exe"
	call :kill "srvstub.exe"
	call :kill "ProcessGovernor.exe"
	start "" /wait "%~dp0..\Installers\ProcessLasso.exe"
	md "%Public%\Desktop\Äîïîëíèòåëüíûå ÿðëûêè" 1>> %logfile% 2>>&1
	nircmdc shortcut "ms-settings:gaming-gamemode" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Âêëþ÷åíèå-îòêëþ÷åíèå èãðîâîãî ðåæèìà" "" "%SystemRoot%\System32\setupapi.dll" 40
	nircmdc shortcut "ms-settings:display-advancedgraphics" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Ôóíêöèÿ àïïàðàòíîãî óñêîðåíèÿ ïëàíèðîâàíèÿ GPU (HAGS)" "" "%SystemRoot%\System32\setupapi.dll" 1
	nircmdc shortcut "%SystemRoot%\Tools\CompatibilityManager\CompatibilityManager.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Íàñòðîéêà ðåæèìà ñîâìåñòèìîñòè äëÿ èãð èëè ïðèëîæåíèé" "" "%SystemRoot%\System32\imageres.dll" 116
	nircmdc shortcut "%SystemRoot%\Tools\EmptyStandbyList.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Î÷èñòêà êýøà ðåçåðâíîé ïàìÿòè (Standby List)" "standbylist" "%SystemRoot%\System32\setupapi.dll" 32
	nircmdc shortcut "%SystemRoot%\Tools\nvidiaProfileInspector.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Íàñòðîéêà ñêðûòûõ ïàðàìåòðîâ ïðîôèëåé NVIDIA" "" "%SystemRoot%\Tools\nvidiaProfileInspector.exe"
	nircmdc shortcut "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Èçìåíåíèå ïðèîðèòåòà äëÿ èãðû èëè ïðîãðàììû" "-NoLogo -NoProfile -NonInteractive -InputFormat None -ExecutionPolicy Bypass -Command %SystemRoot%\Tools\AppGraphicsPerformance.ps1" "%SystemRoot%\System32\imageres.dll" 24
	nircmdc shortcut "%SystemRoot%\Tools\MSI_util_v3.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Íàñòðîéêà çàäåðæêè ïðåðûâàíèé íà óñòðîéñòâàõ (MSI Mode)" "" "%SystemRoot%\System32\setupapi.dll" 54
	nircmdc shortcut "%SystemRoot%\Tools\Cleanmgr+\Cleanmgr+.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Ðàñøèðåííàÿ î÷èñòêà äèñêà îò ìóñîðà" "" "%SystemRoot%\Tools\Cleanmgr+\Cleanmgr+.exe"
	nircmdc shortcut "%SystemRoot%\Tools\LatencyMon\LatMon.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Ìîíèòîðèíã çàäåðæåê DPC è ISR" "" "%SystemRoot%\Tools\LatencyMon\LatMon.exe"
	nircmdc shortcut "%SystemRoot%\Tools\ProcessLasso\ProcessLasso64.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Ìîíèòîðèíã è ðàñøèðåííîå óïðàâëåíèå çàïóùåííûìè ïðîöåññàìè" "" "%SystemRoot%\Tools\ProcessLasso\ProcessLasso64.exe"
	nircmdc shortcut "%SystemRoot%\Tools\intPolicy_%arch%.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Íàñòðîéêà ïîëèòèêè ñðîäñòâà ïðåðûâàíèÿ äðàéâåðîâ" "" "%SystemRoot%\System32\setupapi.dll" 54
	nircmdc shortcut "%SystemRoot%\Tools\NV_RGBFullRangeToggle.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Âêëþ÷åíèå-îòêëþ÷åíèå ïîëíîãî öâåòîâîãî äèàïàçîíà íà âèäåîêàðòàõ NVIDIA (255 öâåòîâ â äèàïàçîíå)" "" "%SystemRoot%\System32\imageres.dll" 151
	nircmdc shortcut "%SystemRoot%\Tools\NVCleanstall.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Çàãðóçêà è óñòàíîâêà äðàéâåðîâ NVIDIA áåç òåëåìåòðèè" "" "%SystemRoot%\Tools\NVCleanstall.exe"
	nircmdc shortcut "%SystemRoot%\Tools\QuickCpu\QuickCPU.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Íàñòðîéêà è ìîíèòîðèíã ïðîèçâîäèòåëüíîñòè ïðîöåññîðà" "" "%SystemRoot%\Tools\QuickCpu\QuickCPU.exe"
	nircmdc shortcut "%SystemRoot%\Tools\SetFSB 2.2.129.95\setfsb.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Èçìåíåíèå ÷àñòîòû ñèñòåìíîé øèíû FSB (èñïîëüçóéòå ñ îñòîðîæíîñòüþ)" "" "%SystemRoot%\Tools\SetFSB 2.2.129.95\setfsb.exe"
	nircmdc shortcut "%SystemRoot%\Tools\TimerTool.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Íàñòðîéêà ðàçðåøåíèÿ âûñîêîòî÷íîãî ñèñòåìíîãî òàéìåðà" "" "%SystemRoot%\System32\setupapi.dll" 28
	nircmdc shortcut "%SystemRoot%\Tools\REAL.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Óìåíüøåíèå çàäåðæêè çâóêà íà óñòðîéñòâàõ âîñïðîèçâåäåíèÿ (ïîñëå çàïóñêà ïðèëîæåíèå ñâåðíåòñÿ â òðåé)" "--tray" "%SystemRoot%\Tools\REAL.exe"
	nircmdc shortcut "%SystemRoot%\Tools\vibranceGUI.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Íàñòðîéêà öèôðîâîé âèáðàöèè è íàñûùåííîñòè â èãðàõ è ïðèëîæåíèÿõ" "" "%SystemRoot%\Tools\vibranceGUI.exe"
	nircmdc shortcut "%SystemRoot%\Tools\ExecutionMaster\ExecutionMaster.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Äîáàâëåíèå èëè èìåíåíèå ðàçðåøåíèé íà çàïóñê ïðèëîæåíèé" "" "%SystemRoot%\Tools\ExecutionMaster\ExecutionMaster.exe"
	nircmdc shortcut "%SystemRoot%\Tools\NoVideo_SRGB\novideo_srgb.exe" "~$folder.common_desktop$\Äîïîëíèòåëüíûå ÿðëûêè" "Êàëèáðîâêà ìîíèòîðîâ ïî sRGB èëè äðóãèì öâåòîâûì ïðîñòðàíñòâàì íà ãðàôè÷åñêèõ ïðîöåññîðàõ NVIDIA è îñíîâå äàííûõ EDID èëè ïðîôèëåé ICC" "" "%SystemRoot%\Tools\NoVideo_SRGB\novideo_srgb.exe"
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!totalsecs!.!ms!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
@echo %clr%[36m Âûïîëíèòü ñæàòèå äâîè÷íûõ ôàéëîâ ïîñëå íàñòðîéêè?%clr%[92m
choice /c yn /n /t %autoChoose% /d y /m %keySelY%
if !errorlevel!==1 (
	@echo %clr%[0m %clr%[93mÂûïîëíÿåòñÿ ñæàòèå äâîè÷íûõ ôàéëîâ ÎÑ. Ýòî ìîæåò çàíÿòü ~1 ÷àñ. Ïîæàëóéñòà, ïîäîæäèòå...%clr%[92m
	echo Âûïîëíÿåòñÿ ñæàòèå äâîè÷íûõ ôàéëîâ ÎÑ. Ýòî ìîæåò çàíÿòü ~1 ÷àñ. 1>> %logfile%
	set timerStart=!time!
	compact /compactos:always 1>> %logfile% 2>>&1
	compact /c /s:"%ProgramFiles%" /a /i /q /exe:lzx 1>> %logfile% 2>>&1
	compact /c /s:"%ProgramFiles(x86)%" /a /i /q /exe:lzx 1>> %logfile% 2>>&1
	compact /c /s:"%ProgramData%" /a /i /exe:lzx 1>> %logfile% 2>>&1
	compact /c /s:"%UserProfile%\AppData" /a /i /q /exe:lzx 1>> %logfile% 2>>&1
	for /f "delims=" %%d in ('dir %SystemRoot% /b /ad') do (
		if "%%d" neq "Boot" (
			if "%%d" neq "System32" (
				if "%%d" neq "SysWOW64" (
					if "%%d" neq "Fonts" (
						if "%%d" neq "Cursors" (
							if "%%d" neq "INF" (
								compact /c /s:"%SystemRoot%\%%d" /a /i /q /exe:lzx 1>> %logfile% 2>>&1
							)
						)
					)
				)
			)
		)
	)
	for /f "delims=" %%f in ('dir %SystemRoot% /b /a-d') do (
		compact /c "%SystemRoot%\%%f" /a /i /q /exe:lzx 1>> %logfile% 2>>&1
	)
	compact /c "%SystemRoot%" /a /i /q /exe:lzx 1>> %logfile% 2>>&1
	set timerEnd=!time!
	call :timer
	@echo ÎÊ %clr%[93m[%clr%[91m!hours!%clr%[0m ÷àñîâ%clr%[93m %clr%[91m!mins!%clr%[0m ìèíóò%clr%[93m %clr%[91m!secs!%clr%[0m ñåêóíä%clr%[93m]%clr%[92m
	echo. 1>> %logfile%
)
start "" /wait /min %~dp0EmptyStandbyList.exe workingsets & start "" /wait /min %~dp0EmptyStandbyList.exe modifiedpagelist & start "" /wait /min %~dp0EmptyStandbyList.exe standbylist & start "" /wait /min %~dp0EmptyStandbyList.exe priority0standbylist
lodctr /e:PerfOS 1>> %logfile% 2>>&1
lodctr /r 1>> %logfile% 2>>&1
start "" "%SystemRoot%\explorer.exe"
timeout /t 1 /nobreak | break
ie4uinit -ClearIconCache
%PS% "gps explorer | spps" 1>> %logfile% 2>>&1
echo.%clr%[36m
echo. 1>> %logfile% 2>>&1
echo.%clr%[42m%clr%[0m
timeout /t 5 /nobreak | break
rundll32 user32.dll, SetActiveWindow 1
timeout /t 2 /nobreak | break
rundll32 user32.dll, SetActiveWindow 1
@echo %clr%[42m Âñå íàñòðîéêè çàâåðøåíû. Ïåðåçàãðóçèòü êîìïüþòåð äëÿ ïðèìåíåíèÿ òâèêîâ ïðÿìî ñåé÷àñ èëè ïðîäîëæèòü?%clr%[0m
choice /c yn /n /t %autoChoose% /d n /m %keySelN%
if !errorlevel!==1 (
	move /y %~dp0InstallUtil.InstallLog %logs%\InstallUtil.InstallLog >nul 2>&1
	move /y %~dp0TimerResolution.InstallLog %logs%\TimerResolution.InstallLog >nul 2>&1
	move /y %~dp0TimerResolution.InstallState %logs%\TimerResolution.InstallState >nul 2>&1
	call :acl_file-folders "%SystemRoot%\System32\CodeIntegrity\SIPolicy.p7b"
	call :acl_file-folders "%SystemRoot%\System32\CodeIntegrity\driversipolicy.p7b"
	%rf% %SystemRoot%\System32\CodeIntegrity\SIPolicy.p7b >nul 2>&1
	%rf% %SystemRoot%\System32\CodeIntegrity\driversipolicy.p7b >nul 2>&1
	%rf% %tmpfile% >nul 2>&1
	%rf% %~dp0logfile >nul 2>&1
	echo. 1>> %logfile% 2>>&1
	bcdedit /enum 1>> %logfile% 2>>&1
	echo. 1>> %logfile% 2>>&1
	@echo --- End of file --- 1>> %logfile% 2>>&1
	timeout /t 1 /nobreak | break
	taskkill /f /im "captime.exe"
	shutdown -f -r -t 0
	goto :eof
)
echo.
echo Âû ìîæåòå ïðîñìîòðåòü âûïîëíåííûå îïåðàöèè â äàííîì îêíå à òàê æå îòêðûòü ëîã ôàéë. Äëÿ ïðîäîëæåíèÿ, íàæìèòå Enter.
timeout -1 | break
echo.
move /y %~dp0InstallUtil.InstallLog %logs%\InstallUtil.InstallLog >nul 2>&1
move /y %~dp0TimerResolution.InstallLog %logs%\TimerResolution.InstallLog >nul 2>&1
move /y %~dp0TimerResolution.InstallState %logs%\TimerResolution.InstallState >nul 2>&1
call :acl_file-folders "%SystemRoot%\System32\CodeIntegrity\SIPolicy.p7b"
call :acl_file-folders "%SystemRoot%\System32\CodeIntegrity\driversipolicy.p7b"
%rf% %SystemRoot%\System32\CodeIntegrity\SIPolicy.p7b >nul 2>&1
%rf% %SystemRoot%\System32\CodeIntegrity\driversipolicy.p7b >nul 2>&1
echo. 1>> %logfile% 2>>&1
bcdedit /enum 1>> %logfile% 2>>&1
echo. 1>> %logfile% 2>>&1
@echo --- End of file --- 1>> %logfile% 2>>&1
choice /c yn /n /m "Îòêðûòü ëîã ôàéë ñåé÷àñ è âûéòè èç ñêðèïòà? Ëîã ôàéë ìîæíî íàéòè â ïàïêå %logs%. [Y:Îòêðûòü / N:Âûéòè]"
if !errorlevel!==1 (
	start "" notepad %logfile%
	timeout /t 1 /nobreak | break
)
%rf% %tmpfile% >nul 2>&1
%rf% %~dp0logfile >nul 2>&1
taskkill /f /im "captime.exe"
goto :eof

:clr
for /f "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set clr=%%b)
goto :eof
:timer
set options="tokens=1-4 delims=:.,"
for /f %options% %%a in ("%timerStart%") do set timerStart_h=%%a&set /a timerStart_m=100%%b %% 100&set /a timerStart_s=100%%c %% 100&set /a timerStart_ms=100%%d %% 100
for /f %options% %%a in ("%timerEnd%") do set timerEnd_h=%%a&set /a timerEnd_m=100%%b %% 100&set /a timerEnd_s=100%%c %% 100&set /a timerEnd_ms=100%%d %% 100
set /a hours=%timerEnd_h%-%timerStart_h%
set /a mins=%timerEnd_m%-%timerStart_m%
set /a secs=%timerEnd_s%-%timerStart_s%
set /a ms=%timerEnd_ms%-%timerStart_ms%
if %ms% lss 0 set /a secs-=1 & set /a ms = 100%ms%
if %secs% lss 0 set /a mins-=1 & set /a secs = 60%secs%
if %mins% lss 0 set /a hours-=1 & set /a mins = 60%mins%
if %hours% lss 0 set /a hours = 24%hours%
if 1%ms% lss 100 set ms=0%ms%
set /a totalsecs = %hours%*3600 + %mins%*60 + %secs%
goto :eof
:explorer
start "" "%SystemRoot%\explorer.exe"
timeout /t 1 /nobreak | break
ie4uinit -ClearIconCache
%PS% "gps explorer | spps" 1>> %logfile% 2>>&1
echo. 1>> %logfile% 2>>&1
@echo --- End of file --- 1>> %logfile% 2>>&1
timeout /t 1 /nobreak | break
%rf% %tmpfile% >nul 2>&1
%rf% %~dp0logfile >nul 2>&1
goto :eof
:kill
taskkill /f /im "%~1" 1>> %logfile% 2>>&1
goto :eof
:auto_svc
sc config "%~1" start= auto 1>> %logfile% 2>>&1
sc start "%~1" 1>> %logfile% 2>>&1
goto :eof
:delayed_svc
sc config "%~1" start= delayed-auto 1>> %logfile% 2>>&1
sc start "%~1" 1>> %logfile% 2>>&1
goto :eof
:demand_svc
sc config "%~1" start= demand 1>> %logfile% 2>>&1
sc stop "%~1" 1>> %logfile% 2>>&1
goto :eof
:demand_svc_sudo
call :trusted_app %~dp0SetACL_%arch%.exe -on '%~1' -ot srv -actn setowner -ownr 'n:S-1-5-32-544'
call :trusted_app %~dp0SetACL_%arch%.exe -on '%~1' -ot srv -actn ace -ace 'n:S-1-5-32-544;p:full'
%~dp0SetACL_%arch%.exe -on "HKLM\SYSTEM\CurrentControlSet\Services\%~1" -ot reg -actn setowner -ownr "n:S-1-5-32-544" 1>> %logfile% 2>>&1
%~dp0SetACL_%arch%.exe -on "HKLM\SYSTEM\CurrentControlSet\Services\%~1" -ot reg -actn ace -ace "n:S-1-5-32-544;p:full" 1>> %logfile% 2>>&1
sc config "%~1" start= demand 1>> %logfile% 2>>&1
sc stop "%~1" 1>> %logfile% 2>>&1
goto :eof
:disable_svc
sc config "%~1" start= disabled 1>> %logfile% 2>>&1
sc stop "%~1" 1>> %logfile% 2>>&1
goto :eof
:disable_svc_sudo
call :trusted_app %~dp0SetACL_%arch%.exe -on '%~1' -ot srv -actn setowner -ownr 'n:S-1-5-32-544'
call :trusted_app %~dp0SetACL_%arch%.exe -on '%~1' -ot srv -actn ace -ace 'n:S-1-5-32-544;p:full'
%~dp0SetACL_%arch%.exe -on "HKLM\SYSTEM\CurrentControlSet\Services\%~1" -ot reg -actn setowner -ownr "n:S-1-5-32-544" 1>> %logfile% 2>>&1
%~dp0SetACL_%arch%.exe -on "HKLM\SYSTEM\CurrentControlSet\Services\%~1" -ot reg -actn ace -ace "n:S-1-5-32-544;p:full" 1>> %logfile% 2>>&1
call :trusted_app sc config %~1 start= disabled
call :trusted_app sc stop %~1
goto :eof
:acl_file-folders
%~dp0SetACL_%arch%.exe -on "%~1" -ot file -rec cont_obj -actn setowner -ownr "n:S-1-5-32-544" 1>> %logfile% 2>>&1
%~dp0SetACL_%arch%.exe -on "%~1" -ot file -rec cont_obj -actn ace -ace "n:S-1-5-32-544;p:full" 1>> %logfile% 2>>&1
goto :eof
:acl_registry
%~dp0SetACL_%arch%.exe -on "%~1" -ot reg -actn setowner -ownr "n:S-1-5-32-544" 1>> %logfile% 2>>&1
%~dp0SetACL_%arch%.exe -on "%~1" -ot reg -actn ace -ace "n:S-1-5-32-544;p:full" 1>> %logfile% 2>>&1
goto :eof
:enable_task
schtasks /change /enable /tn "%~1" 1>> %logfile% 2>>&1
schtasks /run /tn "%~1" 1>> %logfile% 2>>&1
goto :eof
:disable_task
schtasks /end /tn "%~1" 1>> %logfile% 2>>&1
schtasks /change /disable /tn "%~1" 1>> %logfile% 2>>&1
goto :eof
:disable_task_sudo
%SystemUser% run-hidden.exe %PS% "Stop-ScheduledTask -TaskName %~1" 1>> %logfile% 2>>&1
%SystemUser% run-hidden.exe %PS% "Disable-ScheduledTask -TaskName %~1" 1>> %logfile% 2>>&1
goto :eof
:trusted_app
rem tasklist /fo table /nh /fi "imagename eq trustedinstaller.exe" >nul | find /i "trustedinstaller.exe" >nul || (net start trustedinstaller 1>> %logfile% 2>>&1)
%SystemUser% run-hidden.exe %~1 1>> %logfile% 2>>&1
goto :eof
:trusted_ps
%SystemUser% run-hidden.exe powershell -NoLogo -NoProfile -NonInteractive -InputFormat None -WindowStyle Hidden -ExecutionPolicy Bypass -Command %~1 1>> %logfile% 2>>&1
goto :eof
:remove_uwp
%PS% "Get-AppxPackage "*%~1*" -AllUsers | Remove-AppxPackage -AllUsers" 1>> %logfile% 2>>&1
rem %PS% "Get-AppxProvisionedPackage "%~1" –Online | Remove-AppxProvisionedPackage –Online" 1>> %logfile% 2>>&1
goto :eof
:remove_uwp_hard
%~dp0install_wim_tweak.exe /o /r /c "%~1" 1>> %logfile% 2>>&1
goto :eof
:adapters
set "RegistryLine=%~1"
if "%RegistryLine:~0,5%" == "HKEY_" set "RegistryKey=%~1" & goto :eof
for /f "tokens=2*" %%a in ("%RegistryLine%") do set "ProviderName=%%b"
echo %ProviderName% | findstr "search"
if !errorlevel!==1 (
	if "%ProviderName%" == "" goto :eof
	if "%ProviderName%" == "Microsoft" goto :eof
		%rga% "%RegistryKey%" /v "*FlowControl" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
		%rga% "%RegistryKey%" /v "*InterruptModeration" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
		%rga% "%RegistryKey%" /v "*SpeedDuplex" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
		%rga% "%RegistryKey%" /v "AutoDisableGigabit" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
		%rga% "%RegistryKey%" /v "EEE" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
		%rga% "%RegistryKey%" /v "*PriorityVLANTag" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
		%rga% "%RegistryKey%" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
		%rga% "%RegistryKey%" /v "*LsoV2IPv4" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
		%rga% "%RegistryKey%" /v "ApCompatMode" /t REG_SZ /d "0" /f 1>> %logfile% 2>>&1
		%rga% "%RegistryKey%" /v "PnPCapabilities" /t REG_DWORD /d "24" /f 1>> %logfile% 2>>&1
)
goto :eof
:browsers
set browsersFound=0
for /f %%x in ('tasklist /nh /fi "imagename eq chrome.exe"') do if %%x == chrome.exe set browsersFound=1
for /f %%x in ('tasklist /nh /fi "imagename eq firefox.exe"') do if %%x == firefox.exe set browsersFound=1
for /f %%x in ('tasklist /nh /fi "imagename eq opera.exe"') do if %%x == opera.exe set browsersFound=1
for /f %%x in ('tasklist /nh /fi "imagename eq msedge.exe"') do if %%x == msedge.exe set browsersFound=1
for /f %%x in ('tasklist /nh /fi "imagename eq vivaldi.exe"') do if %%x == vivaldi.exe set browsersFound=1
for /f %%x in ('tasklist /nh /fi "imagename eq thunderbird.exe"') do if %%x == thunderbird.exe set browsersFound=1
goto :eof