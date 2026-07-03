# sync.ps1
# 1. Generate codebuddy/*.md from skills/*/SKILL.md (flat format for CodeBuddy)
# 2. Ensure ~/.codebuddy/skills junction points to codebuddy/
# No admin required (mklink /J works for normal users)

$ErrorActionPreference = "Stop"
$repoRoot = $PSScriptRoot
if (-not $repoRoot) { $repoRoot = $PWD.Path }
$srcDir = Join-Path $repoRoot "skills"
$dstDir = Join-Path $repoRoot "codebuddy"
$link = Join-Path $env:USERPROFILE ".codebuddy\skills"

# --- 1. Generate flat .md ---
if (-not (Test-Path $srcDir)) { Write-Error "skills dir not found: $srcDir"; exit 1 }
if (-not (Test-Path $dstDir)) { New-Item -ItemType Directory -Path $dstDir -Force | Out-Null }

$srcSkills = @{}
Get-ChildItem -Path $srcDir -Directory | ForEach-Object {
    $f = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $f) { $srcSkills[$_.Name] = $f }
}

$copied = 0
foreach ($k in $srcSkills.Keys) {
    Copy-Item $srcSkills[$k] (Join-Path $dstDir "$k.md") -Force
    $copied++
}
$removed = 0
Get-ChildItem -Path $dstDir -Filter "*.md" | ForEach-Object {
    if (-not $srcSkills.ContainsKey($_.BaseName)) { Remove-Item $_.FullName -Force; $removed++ }
}
Write-Host "Flat skill sync: updated $copied, removed $removed" -ForegroundColor Cyan

# --- 2. Junction management ---
$needRecreate = $false
if (Test-Path $link) {
    $item = Get-Item $link -Force
    $lt = $item.LinkType
    if ($lt -eq 'Junction' -or $lt -eq 'SymbolicLink') {
        $tgt = if ($item.Target) { ([string]$item.Target).Trim() } else { "" }
        $normDst = (Resolve-Path $dstDir).Path
        $normTgt = if ($tgt) { (Resolve-Path $tgt -ErrorAction SilentlyContinue).Path } else { "" }
        if ($normTgt -ne $normDst) {
            cmd /c rmdir "$link" 2>$null
            $needRecreate = $true
        }
    } elseif ($item.PSIsContainer) {
        Write-Warning "$link is a real directory, not a link. Please handle manually."
        exit 1
    }
} else {
    $needRecreate = $true
}

if ($needRecreate) {
    cmd /c mklink /J "$link" "$dstDir" | Out-Null
    Write-Host "Junction created: $link -> $dstDir" -ForegroundColor Green
} else {
    Write-Host "Junction OK: $link -> $dstDir" -ForegroundColor Green
}
