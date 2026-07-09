
if (-not $env:VSCMD_VER) {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

    if (Test-Path $vswhere) {
        $vsPath = & $vswhere `
            -latest `
            -products * `
            -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
            -property installationPath

        if ($vsPath) {
            & "$vsPath\Common7\Tools\Launch-VsDevShell.ps1" `
                -Arch amd64 `
                -HostArch amd64 `
                -SkipAutomaticLocation |
                Out-Null
        }
    }
}

(&mise activate pwsh) | Out-String | Invoke-Expression

Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-Alias vim nvim
