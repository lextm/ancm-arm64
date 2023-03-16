#Requires -RunAsAdministrator

$main = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll"
$main_x86 = "${env:ProgramFiles(x86)}\IIS\Asp.Net Core Module\V2\aspnetcorev2.dll"
$main_arm64 = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\aspnetcorev2_arm64.dll"
$main_x64 = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\aspnetcorev2_x64.dll"

if (!(Test-Path $main_arm64)) {
    Write-Error "Didn't patch yet. Exit."
    exit 1
}

$version = (Get-Item $main_arm64).VersionInfo.FileVersion
$versionParts = $version.Split(".")
$pathVersion = "$($versionParts[0]).$($versionParts[1]).$($versionParts[2])"

$out = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\$pathVersion\aspnetcorev2_outofprocess.dll"
$out_x86 = "${env:ProgramFiles(x86)}\IIS\Asp.Net Core Module\V2\$pathVersion\aspnetcorev2_outofprocess.dll"
# $out_arm64 = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\$pathVersion\aspnetcorev2_outofprocess_arm64.dll"
# $out_x64 = "$env:ProgramFiles\IIS\Asp.Net Core Module\V2\$pathVersion\aspnetcorev2_outofprocess_x64.dll"
$out_arm64 = "$env:SystemRoot\system32\inetsrv\aspnetcorev2_outofprocess_arm64.dll"
$out_x64 = "$env:SystemRoot\system32\inetsrv\aspnetcorev2_outofprocess_x64.dll"
& iisreset.exe /stop

Remove-Item $main
Remove-Item $main_x64
Remove-Item $main_x86
Remove-Item $out
Remove-Item $out_x64
Remove-Item $out_x86

Rename-Item $main_arm64 $main
# Rename-Item $out_arm64 $out
Copy-item $out_arm64 $out
Remove-Item $out_arm64

Rename-Item "$main_x86.bak" $main_x86
Rename-Item "$out_x86.bak" $out_x86

& iisreset.exe /start

Write-Host "Restored."
