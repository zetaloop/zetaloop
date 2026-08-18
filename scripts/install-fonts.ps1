param(
    [Parameter(Mandatory)]
    [ValidateSet('install', 'uninstall')]
    [string] $Action
)

$ErrorActionPreference = 'Stop'
$helper = Join-Path $PSScriptRoot 'fontctl.cs'
$fonts = @(Get-ChildItem -LiteralPath $PSScriptRoot -Recurse -File | Where-Object { $_.Extension -in '.otf', '.ttf', '.ttc' -and !$_.Name.StartsWith('._') })

if (!$fonts) { throw 'No font files found' }

if ($Action -eq 'install' -and !(Test-Path -LiteralPath $helper)) {
    Copy-Item -LiteralPath (Join-Path (Find-BucketDirectory $bucket -Root) 'scripts\fontctl.cs') -Destination $helper
}

if (!('FontCtl' -as [type])) { Add-Type -Path $helper }

if ($Action -eq 'install') {
    [FontCtl]::Install($fonts.FullName, [bool] $global)
} else {
    [FontCtl]::Uninstall($fonts.FullName, [bool] $global)
}
