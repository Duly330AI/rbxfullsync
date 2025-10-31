param([string]$InputPath)

function Get-Rbxmk {
  if (Get-Command rbxmk -ErrorAction SilentlyContinue) { return "rbxmk" }
  $local = Join-Path $PSScriptRoot "..\tools\rbxmk.exe"
  if (Test-Path $local) { return $local }
  throw "rbxmk not found. Install via aftman (aftman install) or place rbxmk.exe into tools\ ."
}

if (-not $InputPath) {
  $candidates = @("gardenclash.rbxl","place.rbxlx","place.rbxl")
  foreach ($f in $candidates) { if (Test-Path $f) { $InputPath = $f; break } }
}

if (-not $InputPath -or -not (Test-Path $InputPath)) { Write-Error "No .rbxl/.rbxlx found in repo root."; exit 1 }

$rbxmk = Get-Rbxmk
& $rbxmk run -i $InputPath -e 'pcall(function() select $.Workspace > writeDir src/workspace end); pcall(function() select $.ReplicatedStorage.Models > writeDir src/models end)'
if ($LASTEXITCODE -ne 0) { Write-Error "rbxmk failed with exit code $LASTEXITCODE"; exit $LASTEXITCODE }
Write-Host "✓ Import done from $InputPath -> src/workspace + src/models"
