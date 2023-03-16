#Requires -RunAsAdministrator

[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $msiFolder
)

$main = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll"
$main_x86 = "${env:ProgramFiles(x86)}\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll"
$main_arm64 = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\aspnetcorev2_arm64.dll"
$main_x64 = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\aspnetcorev2_x64.dll"

$version = (Get-Item $main).VersionInfo.FileVersion
$versionParts = $version.Split(".")
$pathVersion = "$($versionParts[0]).$($versionParts[1]).$($versionParts[2])"

$out = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\$pathVersion\aspnetcorev2_outofprocess.dll"
$out_x86 = "${env:ProgramFiles(x86)}\IIS\Asp.Net Core Module\V2\$pathVersion\aspnetcorev2_outofprocess.dll"
$out_arm64 = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\$pathVersion\aspnetcorev2_outofprocess_arm64.dll"
$out_x64 = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\$pathVersion\aspnetcorev2_outofprocess_x64.dll"

if ((Test-Path $main) -and !(Test-Path $main_arm64)) {

    if ($msiFolder) {
    } else {
        $msiFolder = ".\msi\AttachedContainer"
    }
    if (!(Test-Path $msiFolder)) {
        Write-Error "Canot find MSI package folder $msiFolder. Exit."
        exit 1
    }    

    Write-Host "Patch files"
    Rename-Item $main $main_arm64
    Rename-Item $main_x86 "$main_x86.bak"
    Rename-Item $out $out_arm64
    Rename-Item $out_x86 "$out_x86.bak"

    Copy-Item .\src\aspnetcorev2.dll $main
    Copy-Item .\src\aspnetcorev2_outofprocess.dll $out

    $tempPath = [System.IO.Path]::GetTempPath()
    $tempDirName = 'ANCM-{0:x}' -f (Get-Random)
    $tempDirPath = Join-Path $tempPath $tempDirName
    Start-Process msiexec "/a `"$msiFolder\AspNetCoreModuleV2_x64.msi`" /qn TARGETDIR=`"$tempDirPath`"" -Wait
    $main_x64_src = Join-Path $tempDirPath "IIS\Asp.Net Core Module\V2\aspnetcorev2.dll"
    Copy-Item $main_x64_src $main_x64

    $out_x64_src = Join-Path $tempDirPath "IIS\Asp.Net Core Module\V2\$pathVersion\aspnetcorev2_outofprocess.dll"
    Copy-Item $out_x64_src $out_x64

    # Start-Process msiexec "/a `"$msiFolder\AspNetCoreModuleV2_x86.msi`" /qn TARGETDIR=`"$tempDirPath`"" -Wait
    $main_x86_src = Join-Path $tempDirPath "IIS\Asp.Net Core Module\WowOnly\aspnetcorev2.dll"
    Copy-Item $main_x86_src $main_x86

    $out_x86_src = Join-Path $tempDirPath "IIS\Asp.Net Core Module\WowOnly\WowOnly\aspnetcorev2_outofprocess.dll"
    Copy-Item $out_x86_src $out_x86

    Remove-Item $tempDirPath -Recurse -Force

    Write-Host "Patched"
} else {
    Write-Host "Already patched"
}

.\sha1.ps1
