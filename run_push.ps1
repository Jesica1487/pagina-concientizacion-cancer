param(
    [string]$Message = "Actualización: cambios y mejoras",
    [string]$Remote  = "origin"
)

Set-Location -Path (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)
Write-Host "Carpeta:" (Get-Location) -ForegroundColor Cyan

# Verificar repo git
$inside = (& git rev-parse --is-inside-work-tree 2>$null)
if ($inside -ne "true") {
    Write-Error "No es un repositorio Git. Ejecutá 'git init' primero."
    exit 1
}

git status --short

# Verificar remote
$remoteUrl = (& git remote get-url $Remote 2>$null) 
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Remote '$Remote' no existe. Se agrega automatico:"
    git remote add $Remote https://github.com/Jesica1487/pagina-concientizacion-cancer.git
} else {
    Write-Host "Remote $Remote -> $remoteUrl" -ForegroundColor Green
}

# Agregar cambios
git add .

# Commit si hay staged
$staged = (& git diff --cached --name-only)
if ([string]::IsNullOrEmpty($staged)) {
    Write-Host "No hay cambios staged para commitear." -ForegroundColor Yellow
} else {
    git commit -m "$Message"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Fallo el commit."
        exit 1
    }
}

# Determinar rama actual y push
$branch = (& git rev-parse --abbrev-ref HEAD)
Write-Host "Rama actual: $branch" -ForegroundColor Cyan

git branch -M main
git push -u $Remote main

if ($LASTEXITCODE -eq 0) {
    Write-Host "Push completado correctamente." -ForegroundColor Green
} else {
    Write-Error "Error al pushear. Verificá credenciales/remote/existencia del repo en GitHub."
    exit 1
}
if ($LASTEXITCODE -eq 0) {
    Write-Host "Push completado correctamente." -ForegroundColor Green
} else {
    Write-Error "Error al pushear. Verificá credenciales/remote/existencia del repo en GitHub."
    exit 1
}
