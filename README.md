# ancm-arm64, installer patches for ASP.NET Core module on Windows 11 ARM64 and IIS.

## Background
The official installer for .NET 8.0/9.0 at this moment only properly installs ASP.NET Core module ARM64 bits on the machine, so that only pure ARM64 ASP.NET Core web apps can run on IIS. The application pool simply crashes when you try to host x86 or x64 web apps even if you enable emulation.

Note that
*  .NET 6.0 web apps can only run in x64/x86 modes on IIS/Windows 11 ARM64. There wasn't no Windows ARM64 support in 6.0 release, so this repo doesn't apply to .NET 6.0.
* This repo also applies to .NET 7.0 but that release reached end of life.
* **.NET 10 Preview 2 and above already include the patches, so you don't need to apply from this repo.**
* **The patched installers for .NET 8/9/10 won't be available immediately, but you can verify if the patch is needed carefully.**

BTW, [I also wrote about my investigation on this topic in details](https://halfblood.pro/successful-and-failed-attempt-my-first-pull-request-for-asp-net-core/) and hope you find the technical details useful when you study Windows ARM64.

## Preparation

Perform the following steps to prepare the environment on your development machine,

1. Download [the original 64 bit installer](https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-aspnetcore-7.0.4-windows-hosting-bundle-installer) from Microsoft.
1. Download [WiX Toolset](https://github.com/wixtoolset/wix3/releases/tag/wix3112rtm) if it isn't installed to `%ProgramFilesX86%\WiX Toolset v3.11\bin\`.
1. Extract all contents from original Microsoft installer using `dark.exe` with

   ``` bash
   dark.exe dotnet-hosting-7.0.4-win.exe -x .\msi
   ```

At this stage, all useful bits can be found in `\msi\AttachedContainer` folder, such as `AspNetCoreModuleV2_*.msi`. This folder provides all files are later used for patching.

> Note that here we use .NET 7.0.4 as an example. The same approach should apply to other versions (including the latest .NET 10 Preview) till Microsoft officially ships the necessary changes in future releases.

## Apply the Patch

1. Execute the official installer to install ARM64 bits to IIS.
1. Clone this repo to your local disk.
1. Execute `patch.ps1 -msiFolder <folder>` (this points to the `AttachedContainer` folder in earlier steps) as administrator so that it extracts the necessary files from those MSI packages and install to the desired places.
   > Note that this install script also installs a few helper files compiled by me. They are ARM64X pure forwarders required for ARM64/x64 side by side execution. The source code and build script are in `src` folder.

## Restore to Default

1. Execute `restore.ps1` as administrator.

> You should restore to default before upgrading the hosting bundle to a newer version.
