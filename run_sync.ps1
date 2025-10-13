Set-Location -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Verificar repo git
$inside = (& git rev-parse --is-inside-work-tree 2>$null)
if ($LASTEXITCODE -ne 0 -or $inside -ne "true") {
    Write-Error "No es un repositorio Git. Situate en la carpeta correcta."
    exit 1
}

Write-Host "Directorio:" (Get-Location) -ForegroundColor Cyan

# Verificar cambios sin commitear
$status = (& git status --porcelain)
if (-not [string]::IsNullOrEmpty($status)) {
    Write-Warning "Hay cambios sin commitear. Hacé commit o stash antes de continuar."
    Write-Host "`nSalida de 'git status --porcelain':" -ForegroundColor Yellow
    Write-Host $status
    Write-Host "`nEjemplos:" -ForegroundColor Cyan
    Write-Host "  git add ."
    Write-Host "  git commit -m `"Mensaje`""
    Write-Host "  o bien: git stash"
    exit 1
}

# Fetch remoto
Write-Host "`nObteniendo referencias remotas..." -ForegroundColor Cyan
& git fetch origin
if ($LASTEXITCODE -ne 0) {
    Write-Error "git fetch falló. Verifica tu conexión y remote."
    exit 1
}

# Intentar pull --rebase
Write-Host "`nIntentando 'git pull --rebase origin main'..." -ForegroundColor Cyan
$pullOutput = & git pull --rebase origin main 2>&1
$pullExit = $LASTEXITCODE
Write-Host $pullOutput

if ($pullExit -ne 0) {
    Write-Error "git pull --rebase falló. Posibles conflictos. Pasos recomendados:"
    Write-Host "  1) Ejecutá 'git status' para ver archivos en conflicto."
    Write-Host "  2) Editá y resolvé los conflictos, luego 'git add <archivo>'."
    Write-Host "  3) Ejecutá 'git rebase --continue' hasta finalizar."
    Write-Host "  Si querés cancelar el rebase: 'git rebase --abort'."
    exit 1
}

# Push al remoto
Write-Host "`nSubiendo cambios a origin/main..." -ForegroundColor Cyan
& git push -u origin main
if ($LASTEXITCODE -ne 0) {
    Write-Error "git push falló. Revisa credenciales o permisos en el repo remoto."
    exit 1
}

Write-Host "`nSincronización completada correctamente." -ForegroundColor Green
exit 0
