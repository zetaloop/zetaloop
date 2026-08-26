param(
    [Parameter(Mandatory)]
    [ValidateSet('install', 'uninstall')]
    [string] $Action,
    [Parameter(Mandatory)]
    [string] $InstallDir,
    [Parameter(Mandatory)]
    [string] $VersionFolder,
    [Parameter(Mandatory)]
    [ValidateSet('64bit', 'arm64')]
    [string] $Architecture,
    [switch] $Global
)

$ErrorActionPreference = 'Stop'
$registry = Get-Content "$PSScriptRoot\vscode-registry.json" -Raw | ConvertFrom-Json
$product = Get-Content "$InstallDir\$VersionFolder\resources\app\product.json" -Raw | ConvertFrom-Json
if ($registry.version -ne $product.version -or $registry.commit -ne $product.commit) {
    throw 'VS Code registry data does not match the installed release'
}
$classes = if ($Global) { 'Registry::HKEY_LOCAL_MACHINE\Software\Classes' } else { 'Registry::HKEY_CURRENT_USER\Software\Classes' }
$settings = if ($Global) { 'Registry::HKEY_LOCAL_MACHINE' } else { 'Registry::HKEY_CURRENT_USER' }
$code = "$InstallDir\Code.exe"
$quotedCode = '"' + $code + '"'
$command = "$quotedCode `"%1`""
$iconDir = "$InstallDir\$VersionFolder\resources\app\resources\win32"
$platform = if ($Architecture -eq 'arm64') { 'arm64' } else { 'x64' }
$clsid = $product.win32ContextMenu.$platform.clsid

$language = (Get-UICulture).Name.ToLowerInvariant()
$language = switch -Regex ($language) {
    '^zh-(tw|hk|mo)' { 'zh-tw'; break }
    '^zh' { 'zh-cn'; break }
    '^pt-br' { 'pt-br'; break }
    default { $language.Split('-')[0] }
}
$localization = $registry.localizations.PSObject.Properties[$language].Value
if (!$localization) {
    $localization = $registry.localizations.en
}

function Set-RegistryValue {
    param(
        [string] $Path,
        [string] $Name,
        [string] $Value,
        [Microsoft.Win32.RegistryValueKind] $Type = [Microsoft.Win32.RegistryValueKind]::String
    )

    if (!(Test-Path $Path)) {
        New-Item $Path -Force | Out-Null
    }
    New-ItemProperty $Path -Name $Name -Value $Value -PropertyType $Type -Force | Out-Null
}

function Remove-AppxRegistration {
    Get-CimInstance Win32_Process -Filter "Name = 'dllhost.exe'" |
        Where-Object { $_.CommandLine -like "*/Processid:$clsid*" } |
        ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction Ignore }
    $packages = Get-AppxPackage Microsoft.VisualStudioCode
    if ($Global) {
        $packages | ForEach-Object { Remove-AppxProvisionedPackage -PackageName $_.PackageFullName -Online | Out-Null }
        $packages | ForEach-Object { Remove-AppxPackage -Package $_.PackageFullName -AllUsers }
    } else {
        $packages | Remove-AppxPackage
    }
}

function Remove-ContextMenus {
    'VSCodeContextMenu', '*\shell\VSCode', 'Directory\shell\VSCode', 'Directory\Background\shell\VSCode', 'Drive\shell\VSCode' |
        ForEach-Object { Remove-Item "$classes\$_" -Recurse -Force -ErrorAction Ignore }
}

function Install-Associations {
    foreach ($association in $registry.associations) {
        $extension, $type, $icon = $association
        $openWith = "$classes\$extension\OpenWithProgids"
        New-Item $openWith -Force | Out-Null
        Remove-ItemProperty $openWith -Name 'VSCode' -Force -ErrorAction Ignore
        Set-RegistryValue $openWith "VSCode$extension" ''

        $progid = "$classes\VSCode$extension"
        Set-RegistryValue $progid '(default)' ($localization.sourceFile -f $type)
        Set-RegistryValue $progid 'AppUserModelID' $product.win32AppUserModelId
        Set-RegistryValue "$progid\DefaultIcon" '(default)' "$iconDir\$icon"
        Set-RegistryValue "$progid\shell\open" 'Icon' $quotedCode
        Set-RegistryValue "$progid\shell\open\command" '(default)' $command
    }

    $sourceFile = "$classes\VSCodeSourceFile"
    Set-RegistryValue $sourceFile '(default)' ($localization.sourceFile -f $product.nameLong)
    Set-RegistryValue "$sourceFile\DefaultIcon" '(default)' "$iconDir\default.ico"
    Set-RegistryValue "$sourceFile\shell\open" '(default)' $quotedCode
    Set-RegistryValue "$sourceFile\shell\open\command" '(default)' $command

    $application = "$classes\Applications\Code.exe"
    New-Item $application -Force | Out-Null
    Set-RegistryValue "$application\DefaultIcon" '(default)' "$iconDir\default.ico"
    Set-RegistryValue "$application\shell\open" 'Icon' $quotedCode
    Set-RegistryValue "$application\shell\open\command" '(default)' $command
}

function Remove-Associations {
    foreach ($association in $registry.associations) {
        $extension = $association[0]
        $openWith = "$classes\$extension\OpenWithProgids"
        Remove-ItemProperty $openWith -Name 'VSCode' -Force -ErrorAction Ignore
        Remove-ItemProperty $openWith -Name "VSCode$extension" -Force -ErrorAction Ignore
        Remove-Item "$classes\VSCode$extension" -Recurse -Force -ErrorAction Ignore
    }
    Remove-Item "$classes\VSCodeSourceFile" -Recurse -Force -ErrorAction Ignore
    Remove-Item "$classes\Applications\Code.exe" -Recurse -Force -ErrorAction Ignore
}

function Set-ApplicationRegistration {
    $appPath = "$settings\Software\Microsoft\Windows\CurrentVersion\App Paths\code.exe"
    Set-RegistryValue $appPath '(default)' $code
    Remove-ItemProperty $appPath -Name 'Path' -Force -ErrorAction Ignore

    $idProperty = if ($Global) { "win32${platform}AppId" } else { "win32${platform}UserAppId" }
    $appId = $product.$idProperty.Substring(1)
    $uninstall = "$settings\Software\Microsoft\Windows\CurrentVersion\Uninstall\${appId}_is1"
    Set-RegistryValue $uninstall 'DisplayIcon' $quotedCode
    Set-RegistryValue $uninstall 'DisplayName' $product.win32NameVersion
    Set-RegistryValue $uninstall 'DisplayVersion' $product.version
    Set-RegistryValue $uninstall 'Publisher' 'Microsoft Corporation'
    Set-RegistryValue $uninstall 'InstallLocation' $InstallDir
}

function Remove-ApplicationRegistration {
    Remove-Item "$settings\Software\Microsoft\Windows\CurrentVersion\App Paths\code.exe" -Recurse -Force -ErrorAction Ignore
    $idProperty = if ($Global) { "win32${platform}AppId" } else { "win32${platform}UserAppId" }
    $appId = $product.$idProperty.Substring(1)
    Remove-Item "$settings\Software\Microsoft\Windows\CurrentVersion\Uninstall\${appId}_is1" -Recurse -Force -ErrorAction Ignore
}

if ($Action -eq 'install') {
    Install-Associations
    Set-ApplicationRegistration
    Remove-ContextMenus

    $classicMenu = Test-Path 'Registry::HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'
    if ([Environment]::OSVersion.Version.Build -ge 22000 -and !$classicMenu) {
        $appxDir = "$InstallDir\$VersionFolder\appx"
        Move-Item "$InstallDir\appx" $appxDir
        Set-RegistryValue "$classes\VSCodeContextMenu" 'Title' $localization.contextMenu ExpandString
        Remove-AppxRegistration
        $package = (Get-Item "$appxDir\code_*.appx").FullName
        if ($Global) {
            Add-AppxPackage -Stage $package -ExternalLocation $appxDir
            Add-AppxProvisionedPackage -Online -SkipLicense -PackagePath $package | Out-Null
        } else {
            Add-AppxPackage -Path $package -ExternalLocation $appxDir
        }
    } else {
        Set-RegistryValue "$classes\*\shell\VSCode" '(default)' $localization.contextMenu ExpandString
        Set-RegistryValue "$classes\*\shell\VSCode" 'Icon' $code ExpandString
        Set-RegistryValue "$classes\*\shell\VSCode\command" '(default)' $command ExpandString
        foreach ($type in 'Directory', 'Directory\Background', 'Drive') {
            Set-RegistryValue "$classes\$type\shell\VSCode" '(default)' $localization.contextMenu ExpandString
            Set-RegistryValue "$classes\$type\shell\VSCode" 'Icon' $code ExpandString
            Set-RegistryValue "$classes\$type\shell\VSCode\command" '(default)' "$quotedCode `"%V`"" ExpandString
        }
        Remove-AppxRegistration
    }
} else {
    Remove-AppxRegistration
    Remove-ContextMenus
    Remove-Associations
    Remove-ApplicationRegistration
}
