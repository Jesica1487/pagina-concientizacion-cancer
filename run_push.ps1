param(
    [string]$Message = "Actualización: cambios y mejoras",
    [string]$Remote  = "origin"
)

Set-Location -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

Write-Host "Carpeta:" (Get-Location) -ForegroundColor Cyan

# Verificar que estamos en un repo git
$inside = & git rev-parse --is-inside-work-tree 2>$null
if ($LASTEXITCODE -ne 0 -or $inside -ne "true") {
    Write-Error "No es un repositorio Git. Ejecutá 'git init' en esta carpeta o situate en la carpeta correcta."
    exit 1
}

Write-Host "`n-- git status --" -ForegroundColor Yellow
git status --short

Write-Host "`n-- git remote -v --" -ForegroundColor Yellow
$remotes = & git remote -v 2>&1
Write-Host $remotes

# Si no existe remote, proponemos añadirlo automáticamente (URL por defecto)
if ($remotes -match "^$") {
    Write-Warning "No hay remotos configurados."
    Write-Host "Agregar remote sugerido:"
    Write-Host "  git remote add $Remote https://github.com/Jesica1487/pagina-concientizacion-cancer.git" -ForegroundColor Cyan
    exit 1
}

# Añadir y commitear
Write-Host "`nAgregando cambios..." -ForegroundColor Yellow
& git add .

$staged = & git diff --cached --name-only
if ([string]::IsNullOrEmpty($staged)) {
    Write-Host "No hay cambios staged para commitear." -ForegroundColor Yellow
} else {
    Write-Host "Commit: $Message" -ForegroundColor Yellow
    & git commit -m "$Message"
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "El commit falló o no hubo cambios. Revisa mensajes anteriores."
    }
}

# Determinar rama actual
$branch = (& git rev-parse --abbrev-ref HEAD).Trim()
if ([string]::IsNullOrEmpty($branch)) { $branch = "main" }
Write-Host "`nRama actual:" $branch -ForegroundColor Green

# Intentar push con verbose y capturar salida
Write-Host "`nEjecutando: git push -u $Remote $branch --verbose" -ForegroundColor Cyan
$pushOutput = & git push -u $Remote $branch --verbose 2>&1
$pushExit = $LASTEXITCODE

Write-Host "`n--- salida de git push ---" -ForegroundColor Yellow
Write-Host $pushOutput
Write-Host "--------------------------`n" -ForegroundColor Yellow

if ($pushExit -eq 0) {
    Write-Host "Push completado correctamente." -ForegroundColor Green
    exit 0
}

# Diagnosticar errores comunes
if ($pushOutput -match "Repository not found" -or $pushOutput -match "repository '.*' not found") {
    Write-Error "Error: 'Repository not found'. Comprueba que el repositorio existe en GitHub y que la URL del remote es correcta."
    Write-Host "Verifica la URL del remote:" -ForegroundColor Cyan
    Write-Host "  git remote get-url $Remote"
    Write-Host "Si el repo no existe, crealo en GitHub en:" -ForegroundColor Green
    Write-Host "  https://github.com/Jesica1487/pagina-concientizacion-cancer" -ForegroundColor Green
    Write-Host "O establece el remote correcto:" -ForegroundColor Cyan
    Write-Host "  git remote set-url $Remote https://github.com/Jesica1487/pagina-concientizacion-cancer.git"
    exit 1
}

if ($pushOutput -match "Permission denied" -or $pushOutput -match "authentication failed" -or $pushOutput -match "could not read Username") {
    Write-Error "Error de autenticación. Verifica tus credenciales."
    Write-Host "Opciones:" -ForegroundColor Cyan
    Write-Host "  - Usar HTTPS con Personal Access Token (PAT):" -ForegroundColor Green
    Write-Host "      git push https://<TOKEN>@github.com/Jesica1487/pagina-concientizacion-cancer.git" -ForegroundColor Green
    Write-Host "  - Configurar SSH y usar git@github.com:Jesica1487/pagina-concientizacion-cancer.git" -ForegroundColor Green
    Write-Host "  - Configurar el helper de credenciales: git config --global credential.helper manager-core" -ForegroundColor Green
    exit 1
}

# Mensaje genérico si no se encontró patrón
Write-Error "Push fallido. Revisa la salida anterior para detalle. Posibles acciones:"
Write-Host "  - Verifica remote: git remote -v" -ForegroundColor Cyan
Write-Host "  - Verifica que el repo exista en GitHub y que tengas permisos." -ForegroundColor Cyan
Write-Host "  - Intenta push con más detalle: git push -u $Remote $branch --verbose" -ForegroundColor Cyan
exit 1
