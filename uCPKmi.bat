@echo off
set ucpkmiver=1.0
title Universal CPK Mod Installer %ucpkmiver%
if exist ucpkmistartup.bat (call ucpkmistartup.bat)

if not exist ucpkmi.cfg (
  echo ERROR [NO_CONFIG_FILE]
  echo ----------
  echo Cannot find configuration file
  echo Please put the configuration file in the same folder as this script and try again.
  pause >nul
  exit
)

  for /f "tokens=1,2 delims==" %%a in (ucpkmi.cfg) do (
  if /I %%a==cpkpath set cpk=%%b
)

  for /f "tokens=1,2 delims==" %%a in (ucpkmi.cfg) do (
  if /I %%a==cpkname set cpkname=%%b
)
set cpkonlyname=%cpkname:.cpk=%

  for /f "tokens=1,2 delims==" %%a in (ucpkmi.cfg) do (
  if /I %%a==ModsFolder set ModsFolder=%%b
)

  for /f "tokens=1,2 delims==" %%a in (ucpkmi.cfg) do (
  if /I %%a==worklocation set worklocation=%%b
)

  for /f "tokens=1,2 delims==" %%a in (ucpkmi.cfg) do (
  if /I %%a==uCPKmiCacheLocation set cachelocation=%%b
)

  for /f "tokens=1,2 delims==" %%a in (ucpkmi.cfg) do (
  if /I %%a==cpktool set cpktool=%%b
)

  for /f "tokens=1,2 delims==" %%a in (ucpkmi.cfg) do (
  if /I %%a==modsdatabase set modsdb=%%b
)
  for /f "tokens=1,2 delims==" %%a in (ucpkmi.cfg) do (
  if /I %%a==skipchecks set skipchecks=%%b
)
  for /f "tokens=1,2 delims==" %%a in (ucpkmi.cfg) do (
  if /I %%a==debugstart set debugstart=%%b
)

if not exist %cachelocation% (md %cachelocation%)
if /i %skipchecks% EQU true (goto skipchecks)
if /i %debugstart% EQU true (goto skipchecks)
if not defined worklocation (set "worklocation=%cd%")

if not defined cpk (
  echo ERROR [NOT_CONFIGURED]
  echo ----------
  echo You didn't set up uCPKmi properly yet.
  echo Please configure uCPKmi by modifying ucpkmi.cfg and try again.
  pause >nul
  exit
)
if not defined cpkname (
  echo ERROR [NOT_CONFIGURED]
  echo ----------
  echo You didn't set up uCPKmi properly yet.
  echo Please configure uCPKmi by modifying ucpkmi.cfg and try again.
  pause >nul
  exit
)
if not defined cpktool (
  echo ERROR [NOT_CONFIGURED]
  echo ----------
  echo You didn't set up uCPKmi properly yet.
  echo Please configure uCPKmi by modifying ucpkmi.cfg and try again.
  pause >nul
  exit
)

if not defined cachelocation (set cachelocation=.\ucpkmi)
if not defined modsfolder (set modsfolder=.\mods)
if not defined modsdb (set modsdb=%modsfolder%\ModsDB.ini)



if not exist "%cpktool%" (
  echo ERROR [NO_CPK_TOOL]
  echo ----------
  echo Could not find %cpktool%!
  echo Make sure the path to your CPK tool is correct and try again.
  pause >nul
  exit
)

if not exist "%cpk%\%cpkname%" (
  echo ERROR [NO_CPK]
  echo ----------
  echo Could not find %cpkname%!
  echo Make sure the path to your CPK is correct, aswell as its name, and try again.
  pause >nul
  exit
)

if not exist %modsfolder% (md %modsfolder%)
goto menu

:skipchecks
if not defined cachelocation (set cachelocation=.\ucpkmi)
if not defined modsfolder (set modsfolder=.\mods)
if not defined modsdb (set modsdb=%modsfolder%\ModsDB.ini)
if not exist %modsfolder% (md %modsfolder%)
if not defined worklocation (set "worklocation=%cd%")
if /i %debugstart% EQU true (goto status)
:menu
cls
echo Type the mod folder to install that mod
echo Type "!delete" to uninstall all currently installed mods
echo Type "!refresh" to refresh the mod list
echo Type "!check" to check currently installed mods
echo.
echo Mods available in "%modsfolder%"
echo ------------------------------------
cd %modsfolder%
for /r %%a in (.) do @if exist "%%~fa\mod.ini" echo %%~nxa
cd %worklocation%
echo ------------------------------------
echo.
set /p modfoldernormal=Mod folder: 
if /i "%modfoldernormal%" EQU "" (goto menu) 
if /i "%modfoldernormal%" EQU "!delete" (goto uninstall)
if /i "%modfoldernormal%" EQU "!refresh" (goto menu)
if /i "%modfoldernormal%" EQU "!check" (goto check)
if /i "%modfoldernormal%" EQU "!exit" (exit)
if /i "%modfoldernormal%" EQU "!status" (goto status)
if /i "%modfoldernormal%" EQU "!debug" (goto status)




if not "%modfoldernormal%"=="%modfoldernormal: =%" (
  cls
  echo ERROR
  echo ----------
  echo The mod's folder cannot have a space in its name.
  echo Please rename the folder and try again.
  pause >nul
  goto menu
)

if not exist %modsfolder%\%modfoldernormal% (
  cls
  echo ERROR
  echo ----------
  echo Mod folder does not exist
  pause >nul
  goto menu
)

if not exist %modsfolder%\%modfoldernormal%\mod.ini (
  cls
  echo ERROR
  echo ----------
  echo Not a valid mod folder.
  echo Forgot to create mod.ini?
  pause >nul
  goto menu
)

  for /f "tokens=1,2 delims==" %%a in (%modsfolder%\%modfoldernormal%\mod.ini) do (
  if /I %%a==title set title=%%b
)
  for /f "tokens=1,2 delims==" %%a in (%modsfolder%\%modfoldernormal%\mod.ini) do (
  if /I %%a==author set author=%%b
)
  for /f "tokens=1,2 delims==" %%a in (%modsfolder%\%modfoldernormal%\mod.ini) do (
  if /I %%a==description set description=%%b
)
  for /f "tokens=1,2 delims==" %%a in (%modsfolder%\%modfoldernormal%\mod.ini) do (
  if /I %%a==version set modver=%%b
)
  for /f "tokens=1,2 delims==" %%a in (%modsfolder%\%modfoldernormal%\mod.ini) do (
  if /I %%a==modfiles set modfiles=%%b
)

:confirm
set confirm=
if not exist %modsfolder%\%modfoldernormal% (
  cls
  echo ERROR
  echo ----------
  echo The mod's folder cannot have a space in its name.
  echo Please rename the folder and try again.
  pause >nul
  goto menu
)

if not exist %modsfolder%\%modfoldernormal%\mod.ini (
  cls
  echo ERROR
  echo ----------
  echo Not a valid mod folder.
  echo Forgot to create mod.ini?
  pause >nul
  goto menu
)


cls
echo Do you want to install %title% by %author%? 
echo Version: %modver%
echo Description: %description%
echo.
set /p confirm=(Y/N)
if /i "%confirm%" NEQ "Y" if /i "%confirm%" NEQ "N" goto confirm
if /i %confirm% EQU Y goto install
if /i %confirm% EQU n goto menu



:install
echo --------------------------
if not exist "%CPK%\%cpkname%.backup" (
  echo No backup detected, backing up %cpkname% as %cpkname%.backup...
  echo f|xcopy /y "%cpk%\%cpkname%" "%cpk%\%cpkname%.backup" >nul
) else (
  echo Backup of %cpkname% already detected, proceeding instalation...
  echo You have 7 seconds to close this window if this is wrong...
  echo.
  echo If you already installed mods with uCPKmi, just press any key
  timeout /t 7 >nul
)
echo --------------------------
echo --------------------------
if exist "%modsfolder%\%modfoldernormal%\%modfiles%\*.cpk" (
echo CPK mod detected. Extracting files...
for %%x in (%modsfolder%\%modfoldernormal%\%modfiles%\*.cpk) do (
  set "cpkinstallation=%%x"
  goto CPKProceed
)

:cpkproceed
%cpktool% %cpkinstallation%
echo IF THIS LOOKS STUCK, DON'T DO ANYTHING! IT ISN'T!
  if not exist "%cachelocation%\ucpkmi_%cpkonlyname%" (
  %cpktool% "%cpk%\%cpkname%"
  rename %cpkonlyname% ucpkmi_%cpkonlyname%
  move ucpkmi_%cpkonlyname% "%cachelocation%" >nul
) else (
  echo Extracted files already found, skipping extraction...
)
echo --------------------------
echo IF THIS LOOKS STUCK, DON'T DO ANYTHING! IT ISN'T!
%cpktool% "%cachelocation%\ucpkmi_%cpkonlyname%" "%cpkonlyname%"
echo --------------------------
echo %title% >> %modsdb%
echo Done! Press any key to exit!
pause >nul
exit
)

if not exist "%cachelocation%\ucpkmi_%cpkonlyname%" (
  echo IF THIS LOOKS STUCK, DON'T DO ANYTHING! IT ISN'T!
  %cpktool% "%cpk%\%cpkname%"
  rename %cpkonlyname% ucpkmi_%cpkonlyname%
  move ucpkmi_%cpkonlyname% "%cachelocation%" >nul
) else (
  echo Extracted files already found, skipping extraction...
)
echo --------------------------
echo Copying files...
pause
xcopy /s /y "%modsfolder%\%modfoldernormal%\%modfiles%" "%cachelocation%\ucpkmi_%cpkonlyname%" >nul
echo --------------------------
echo IF THIS LOOKS STUCK, DON'T DO ANYTHING! IT ISN'T!
%cpktool% "%cachelocation%\ucpkmi_%cpkonlyname%" "%cpk%\%cpkonlyname%"
echo --------------------------
echo %title% >> %modsdb%
echo Done! Press any key to exit!
pause >nul
exit



:check
cls
echo Currently installed mods:
echo ---------
if not exist "%modsdb%" (
  echo No mods are currently installed
) else (
type %modsdb%
)
echo ---------
echo Press any key to go back to the menu...
pause >nul
goto menu

:uninstall
cls
echo Currently installed mods:
echo ---------
if not exist "%modsdb%" (
  echo No mods are currently installed
) else (
type "%modsdb%"
)
echo ---------
echo This will uninstall all of your currently installed mods
set /p answer=Proceed (Y/N): 
echo ---------
if /i %answer% equ y goto uninstallyes
goto menu


:uninstallyes
if not exist "%cpk%\%cpkname%.backup" (
echo ERROR
echo No backup of your current cpk was detected!
echo Without a backup, the uninstaller cannot proceed.
pause >nul
goto menu
)

echo Uninstalling mods...
del %cpk%\%cpkname%
ren %cpk%\%cpkname%.backup %cpkname%
del /q "%cachelocation%\*"
FOR /D %%p IN ("%cachelocation%\*.*") DO rmdir "%%p" /s /q
del /q "%modsdb%"
echo.
echo Done! Press any key to go back to the menu
pause >nul
goto menu

:status
cls
echo INFO
echo uCPKmi Version=%ucpkmiver%
echo.
echo CPKPath="%cpk%"
echo CpkName="%cpkname%"
echo CpkNameWithoutFiletype="%cpkonlyname%"
echo ModsFolder="%modsfolder%"
echo ModsDatabasePath="%modsdb%"
echo WorkLocation="%worklocation%"
echo uCPKmi Cache Location="%cachelocation%"
pause >nul
goto menu