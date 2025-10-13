@echo off
cd /d "%~dp0"
echo Carpeta actual: %CD%
echo -------------------------------------------------
git status --short
echo -------------------------------------------------

set "MSG=%~1"
if "%MSG%"=="" set "MSG=Actualización: cambios y mejoras"

echo Agregando archivos...
git add .

echo Commit con mensaje: %MSG%
git commit -m "%MSG%" || (
  echo No hay cambios para commitear o el commit falló.
)

echo Comprobando remote 'origin'...
git remote get-url origin >nul 2>&1
if ERRORLEVEL 1 (
  echo Remote 'origin' no configurado. Se agrega automáticamente:
  git remote add origin https://github.com/Jesica1487/pagina-concientizacion-cancer.git
)

echo Asegurando rama principal 'main'...
git branch -M main

echo Pusheando a origin main...
git push -u origin main
if ERRORLEVEL 1 (
  echo Error al pushear. Verifica la URL del remote y tus credenciales.
  pause
  exit /b 1
)

echo Push completado.
pause
  exit /b 1
)

echo Push completado.
pause
