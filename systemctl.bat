@echo off
echo Script di adattamento per AGO Tools: systemctl
if %1==restart goto restart
if %1==status goto status
:restart
net stop %2
net start %2
goto end
:status

echo Servico: %1
if "%2"=="" goto erro
sc query %2 | findstr RUNNING
if %ERRORLEVEL% == 2 goto trouble
if %ERRORLEVEL% == 1 goto stopped
if %ERRORLEVEL% == 0 goto started
echo unknown status
goto end
:trouble
echo trouble
goto end
:started
echo started
goto end
:stopped
echo stopped
goto end
:erro
echo sintaxe: servico NOMESERVICO
goto end

:end