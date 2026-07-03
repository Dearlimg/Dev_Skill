# 将 skills/ 软链接到 CodeBuddy 用户级目录
# 需在管理员权限的 PowerShell 中运行

$target = "$PWD\skills"
$link   = "$env:USERPROFILE\.codebuddy\skills"

if (-not (Test-Path $target)) {
    Write-Error "skills 目录不存在: $target"
    exit 1
}

# 如果已存在链接或目录，先处理
if (Test-Path $link) {
    $item = Get-Item $link
    if ($item.LinkType -eq 'SymbolicLink') {
        Write-Host "软链接已存在，跳过" -ForegroundColor Yellow
        exit 0
    } else {
        Write-Error "$link 已存在且不是软链接，请手动处理后重试"
        exit 1
    }
}

New-Item -ItemType SymbolicLink -Path $link -Target $target -Force | Out-Null
Write-Host "已创建软链接: $link -> $target" -ForegroundColor Green
