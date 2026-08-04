param(
    [Parameter(Mandatory)]
    [ValidateSet('install', 'uninstall')]
    [string] $Action
)

$ErrorActionPreference = 'Stop'
$fontInstallDir = if ($global) { "$env:windir\Fonts" } else { "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" }
$registryRoot = if ($global) { 'HKLM' } else { 'HKCU' }
$registryKey = "${registryRoot}:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
$fonts = @(Get-ChildItem -LiteralPath $PSScriptRoot -Recurse -File | Where-Object { $_.Extension -in '.ttf', '.ttc' -and !$_.Name.StartsWith('._') })
$nativeMethods = 'AwesomeFonts.NativeMethods' -as [type]
if (!$nativeMethods) {
    $nativeMethods = Add-Type -MemberDefinition @'
[System.Runtime.InteropServices.DllImport("gdi32.dll", CharSet = System.Runtime.InteropServices.CharSet.Unicode, SetLastError = true)]
public static extern int AddFontResourceEx(string name, uint fl, System.IntPtr pdv);

[System.Runtime.InteropServices.DllImport("gdi32.dll", CharSet = System.Runtime.InteropServices.CharSet.Unicode, SetLastError = true)]
public static extern bool RemoveFontResourceEx(string name, uint fl, System.IntPtr pdv);

[System.Runtime.InteropServices.DllImport("user32.dll", SetLastError = true)]
public static extern System.IntPtr SendMessageTimeout(
    System.IntPtr hWnd,
    uint Msg,
    System.IntPtr wParam,
    System.IntPtr lParam,
    uint fuFlags,
    uint uTimeout,
    out System.IntPtr lpdwResult
);
'@ -Name NativeMethods -Namespace AwesomeFonts -PassThru
}
if (!$fonts) { throw 'No font files found' }

if ($Action -eq 'install') {
    New-Item $fontInstallDir -ItemType Directory -Force | Out-Null

    if (!$global) {
        $acl = Get-Acl $fontInstallDir
        foreach ($sid in 'S-1-15-2-1', 'S-1-15-2-2') {
            $rule = [System.Security.AccessControl.FileSystemAccessRule]::new(
                [System.Security.Principal.SecurityIdentifier]::new($sid),
                'ReadAndExecute',
                'ContainerInherit,ObjectInherit',
                'None',
                'Allow'
            )
            $acl.SetAccessRule($rule)
        }
        Set-Acl $fontInstallDir $acl
    }

    foreach ($font in $fonts) {
        $destination = Join-Path $fontInstallDir $font.Name
        $value = if ($global) { $font.Name } else { $destination }
        $sameFile = (Test-Path -LiteralPath $destination) -and (Get-FileHash -LiteralPath $font.FullName).Hash -eq (Get-FileHash -LiteralPath $destination).Hash

        while ($nativeMethods::RemoveFontResourceEx($destination, 0, [IntPtr]::Zero)) {}
        if (!$sameFile) { Copy-Item -LiteralPath $font.FullName -Destination $destination -Force }
        if ($nativeMethods::AddFontResourceEx($destination, 0, [IntPtr]::Zero) -eq 0) {
            throw "Unable to load font '$destination'"
        }
        New-ItemProperty $registryKey "$($font.BaseName) (TrueType)" -Value $value -Force | Out-Null
    }
} else {
    foreach ($font in $fonts) {
        $destination = Join-Path $fontInstallDir $font.Name
        if (Test-Path -LiteralPath $destination) {
            while ($nativeMethods::RemoveFontResourceEx($destination, 0, [IntPtr]::Zero)) {}
            $stream = [System.IO.File]::Open($destination, 'Open', 'ReadWrite', 'None')
            $stream.Dispose()
        }
    }

    foreach ($font in $fonts) {
        $destination = Join-Path $fontInstallDir $font.Name
        if (Test-Path -LiteralPath $destination) { Remove-Item -LiteralPath $destination -Force }
        Remove-ItemProperty -LiteralPath $registryKey -Name ([WildcardPattern]::Escape("$($font.BaseName) (TrueType)")) -Force
    }
}

$result = [IntPtr]::Zero
$nativeMethods::SendMessageTimeout([IntPtr] 0xffff, 0x001d, [IntPtr]::Zero, [IntPtr]::Zero, 2, 1000, [ref] $result) | Out-Null
