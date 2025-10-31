param(
    [string]$InputPath = "place.rbxlx"
)

# Extract Workspace and Models from an exported .rbxlx into src/ paths using rbxmk
# Usage:
#   pwsh -File scripts/extract-workspace.ps1 -InputPath path\to\place.rbxlx

if (-not (Get-Command rbxmk -ErrorAction SilentlyContinue)) {
    Write-Error "rbxmk is not installed or not on PATH. Install via 'aftman install'."
    exit 1
}

if (-not (Test-Path $InputPath)) {
    Write-Error "Input file not found: $InputPath"
    exit 1
}

Write-Host "Extracting from $InputPath ..."

# NOTE: Single-quoted expression preserves the $ characters for rbxmk's query language.
rbxmk run -i $InputPath -e 'select $.Workspace > writeDir src/workspace; select $.ReplicatedStorage.Models > writeDir src/models'

if ($LASTEXITCODE -ne 0) {
    Write-Error "rbxmk extraction failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "Extraction complete: src/workspace and src/models updated."
