$recoveryDir = Join-Path $env:TEMP "terraform-state-recovery"
$prevPath = Join-Path $recoveryDir "lab03-previous.tfstate"
$backPath = Join-Path $recoveryDir "lab03-before-recovery.$(Get-Date -Format 'yyyyMMdd-HHmmss').tfstate"

$curJson = terraform state pull

if ($LASTEXITCODE -ne 0) {
  throw "State pull failed."
}

$curJson | Set-Content -Path $backPath -Encoding utf8NoBOM

$curState = $curJson | ConvertFrom-Json
$prevState = Get-Content $prevPath -Raw | ConvertFrom-Json

if ($curState.Lineage -ne $prevState.Lineage) {
  throw "Lineages differ."
}

if ($curState.Serial -le $prevState.Serial) {
  throw "Downloaded snapshot is not older than the current snapshot."
}

Write-Host "Backup Saved: $backPath"
Write-Host "Current Serial: $($curState.Serial); Previous Serial: $($prevState.Serial)"
