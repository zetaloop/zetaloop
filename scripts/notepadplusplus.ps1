param(
    [Parameter(Mandatory)]
    [ValidateSet('layout', 'install', 'uninstall')]
    [string] $Action,
    [Parameter(Mandatory)]
    [string] $InstallDir,
    [switch] $Global
)

$ErrorActionPreference = 'Stop'
$contextMenu = "$InstallDir\contextMenu"
$shell = '{B298D29A-A6ED-11DE-BA8C-A68E55D89593}'
$classes = if ($Global) { 'Registry::HKEY_LOCAL_MACHINE\Software\Classes' } else { 'Registry::HKEY_CURRENT_USER\Software\Classes' }

function Find-One {
    param([string] $Name)

    $items = @(Get-ChildItem "$InstallDir\_installer" -Recurse -Force | Where-Object Name -EQ $Name)
    if ($items.Count -ne 1) {
        throw "Expected one $Name in the Notepad++ installer, found $($items.Count)"
    }
    $items[0]
}

function Move-Contents {
    param($Source, [string] $Destination)

    New-Item $Destination -ItemType Directory -Force | Out-Null
    Get-ChildItem $Source -Force | Move-Item -Destination $Destination -Force
}

function Set-RegistryValue {
    param(
        [string] $Path,
        [string] $Name,
        [string] $Value
    )

    if (!(Test-Path $Path)) {
        New-Item $Path -Force | Out-Null
    }
    New-ItemProperty $Path -Name $Name -Value $Value -Force | Out-Null
}

function Remove-Package {
    if ($Global) {
        Get-AppxProvisionedPackage -Online |
            Where-Object DisplayName -EQ 'NotepadPlusPlus' |
            ForEach-Object { Remove-AppxProvisionedPackage -PackageName $_.PackageName -Online | Out-Null }
        Get-AppxPackage NotepadPlusPlus -AllUsers |
            ForEach-Object { Remove-AppxPackage -Package $_.PackageFullName -AllUsers }
    } else {
        Get-AppxPackage NotepadPlusPlus | Remove-AppxPackage
    }
}

if ($Action -eq 'layout') {
    $stage = "$InstallDir\_installer"
    $localization = Find-One 'nppLocalization'
    $userFiles = (Find-One 'userDefineLangs').Parent
    $plugins = (Find-One 'mimeTools').Parent
    $pluginConfig = (Find-One 'nppPluginList.dll').Directory

    Get-ChildItem $stage -Force |
        Where-Object { !$_.Name.StartsWith('$') -and !$_.Name.StartsWith('[') -and $_.Name -ne 'uninstall.exe' } |
        Move-Item -Destination $InstallDir
    Move-Contents $localization.FullName "$InstallDir\localization"
    Move-Contents $userFiles.FullName $InstallDir
    Move-Contents $plugins.FullName "$InstallDir\plugins"
    Move-Contents $pluginConfig.FullName "$InstallDir\plugins\Config"
    Move-Item "$InstallDir\LICENSE" "$InstallDir\license.txt"
    New-Item "$InstallDir\disableNppAutoUpdate.xml" -ItemType File | Out-Null

    if (!(Test-Path "$contextMenu\NppShell.dll") -or !(Test-Path "$contextMenu\NppShell.msix")) {
        throw 'Notepad++ context menu components are missing'
    }
    Remove-Item $stage -Recurse -Force
} elseif ($Action -eq 'install') {
    $verb = "$classes\*\shell\ANotepad++64"
    Set-RegistryValue $verb '(default)' 'Notepad++ Context menu'
    Set-RegistryValue $verb 'ExplorerCommandHandler' $shell
    Set-RegistryValue $verb 'NeverDefault' ''
    Set-RegistryValue "$classes\CLSID\$shell" '(default)' 'notepad++'
    Set-RegistryValue "$classes\CLSID\$shell\InProcServer32" '(default)' "$contextMenu\NppShell.dll"
    Set-RegistryValue "$classes\CLSID\$shell\InProcServer32" 'ThreadingModel' 'Apartment'

    if ([Environment]::OSVersion.Version.Build -ge 22000) {
        if ($Global) {
            Add-AppxPackage -Stage "$contextMenu\NppShell.msix" -ExternalLocation $contextMenu
            Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath "$contextMenu\NppShell.msix" | Out-Null
        } else {
            Add-AppxPackage -Path "$contextMenu\NppShell.msix" -ExternalLocation $contextMenu
        }
    }
} else {
    Remove-Package
    Remove-Item "$classes\*\shell\ANotepad++64" -Recurse -Force -ErrorAction Ignore
    Remove-Item "$classes\CLSID\$shell" -Recurse -Force -ErrorAction Ignore
    if (Test-Path "$contextMenu\NppShell.dll") {
        & "$env:WINDIR\System32\rundll32.exe" "$contextMenu\NppShell.dll,CleanupDll"
    }
}
