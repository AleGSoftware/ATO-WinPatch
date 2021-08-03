@echo off
@echo off
goto check_Permissions

:check_Permissions
    echo Benvenuto! Per questo programma sono richiesti i permessi amministrativi.

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo OK.
    ) else (
        echo Tentativo di riavvio con permessi amministrativi in corso...
		powershell -Command "Start-Process ATO-WinPatch.bat -Verb RunAs"
		goto end
    )
:START
CLS
ECHO AleGSoftware, 2020
ECHO Starting...
PING -n 3 LOCALHOST >NUL

echo  ====================================================
echo  =AGO Tools Patcher per Windows======================
echo  ====================================================
echo  =Questo programma permette di usare questo pc come =
echo  =un server per il programma AGO Tools              =
echo  ====================================================
echo This program comes with ABSOLUTELY NO WARRANTY.
echo This is free software, and you are welcome to redistribute it
echo under certain conditions.
choice -c ANV -m "[A]ccettare la licenza, [N]on accettare la licenza, [V]isualizzare la licenza"
if %errorLevel% == 2 goto end
if %errorLevel% == 3 goto vl



echo Benvenuto in AGO TOOLS Patcher. Scegliere l'opzione:
echo 1. Scarica e installa (richiede connessione ad internet)
echo 	- Install. OpenSSH
echo 	- Install. Script di adattamento
echo 2. Scarica solo e installa manualmente
echo 3. Informazioni
echo 4. Uscita
:SELECTION
set /p mode=Mod.=
if %mode%==1 goto infopatch
if %mode%==2 goto dl
if %mode%==3 goto info
if %mode%==4 goto exiting
goto selection
:InfoPatch
echo Informazioni su questa modalità
echo 1. Viene scaricato da GitHub (PowerShell/Win32-OpenSSH) il pacchetto OpenSSH
echo 2. Viene decompresso
echo 3. Viene eseguito lo script PowerShell dell'installer (install-sshd)
echo 4. Viene avviato OpenSSH
echo 5. Viene abilitato OpenSSH
echo 6. Vengono scaricati gli script di adattamento
echo 7. Vengono installati sotto System32
pause
goto patch
:info
echo  ====================================================
echo  =AGO Tools Patcher per Windows======================
echo  ====================================================
echo  =Questo programma permette di usare questo pc come =
echo  =un server per il programma AGO Tools              =
echo  ====================================================
pause
goto start 
:PATCH
mkdir c:\ATOPatch
echo DL: OpenSSH
powershell -c Invoke-WebRequest -Uri "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.1.0.0p1-Beta/OpenSSH-Win64.zip" -OutFile "C:\atopatch\ssh.zip"
powershell -c Expand-Archive -Force C:\ATOPatch\ssh.zip C:\ATOPatch
echo IN: OpenSSH
powershell -ExecutionPolicy Bypass C:\ATOPatch\OpenSSH-Win64\install-sshd.ps1
echo SET: OpenSSH
net start sshd
powershell -c Set-Service 'sshd' -StartupType Automatic
echo OK: OpenSSH
echo DL: Script di adattamento
powershell -c Invoke-WebRequest -Uri "https://download.alegsoftware.ga/software/ATO-WinPatch/adapters.zip" -OutFile "C:\atopatch\adapters.zip"
powershell -c Expand-Archive -Force C:\ATOPatch\adapters.zip C:\ATOPatch
echo IN: Script di adattamento
copy c:\atopatch\bash.bat c:\windows\system32\bash.bat
copy c:\atopatch\systemctl.bat c:\windows\system32\systemctl.bat
cls
echo I servizi sono stati installati.
goto start

:dl
echo Tutto verrà scaricato in c:\atopatch\
echo ssh.zip = openssh
echo adapters.zip = adattatori
powershell -c Invoke-WebRequest -Uri "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.1.0.0p1-Beta/OpenSSH-Win64.zip" -OutFile "C:\atopatch\ssh.zip"
powershell -c Invoke-WebRequest -Uri "https://download.alegsoftware.ga/software/ATO-WinPatch/adapters.zip" -OutFile "C:\atopatch\adapters.zip"
explorer c:\atopatch\
echo OK.
goto start


:vl
powershell -c Invoke-WebRequest -Uri "https://www.gnu.org/licenses/gpl-3.0.txt" -OutFile "lic.txt"
start /wait notepad lic.txt
del lic.txt
goto start

:exiting
echo Grazie per aver usato questo programma.
echo Chiusura in 10 sec...
PING -n 11 LOCALHOST > nul
goto end

:end
