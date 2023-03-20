# ancm-arm64
Installer patches for ASP.NET Core module on Windows 11 ARM64.

The official installer for .NET 7.0/8.0 at this moment only properly installs ASP.NET Core module ARM64 bits on the machine, so that only pure ARM64 ASP.NET Core web apps can run on IIS.

> Note that .NET 6.0 web apps can only run in x64/x86 modes on IIS/Windows 11 ARM64.

> Also note that once [this pull request](https://github.com/dotnet/aspnetcore/pull/47290) is merged and shipped in new hosting bundle installers, you don't need this patch any more.

## Preparation

1. Download [the original 64 bit installer](https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-aspnetcore-7.0.4-windows-hosting-bundle-installer) from Microsoft.
1. Download [WiX Toolset](https://github.com/wixtoolset/wix3/releases/tag/wix3112rtm) if it isn't installed to `%ProgramFilesX86%\WiX Toolset v3.11\bin\`.
1. Extract all contents from Microsoft installer using `dark.exe` with

   ``` bash
   dark.exe dotnet-hosting-7.0.4-win.exe -x .\msi
   ```

At last, all useful bits are in `\msi\AttachedContainer` folder, such as `AspNetCoreModuleV2_*.msi`. This folder is going to be used for patching.

> Note that here we use .NET 7.0.4 as an example. It applies to other versions till Microsoft officially ships the necessary changes.

## Apply the Patch

1. Execute the official installer to get ARM64 bits installed to IIS.
1. Execute `patch.ps1 -msiFolder <folder>` as administrator so that it extracts the necessary files from those MSI packages and install to the desired places.
   > Note that this install script also installs a few helper files compiled by me. They are ARM64X pure forwarder required for ARM64/x64 side by side execution. The source code and build script are in `src` folder.

## Restore to Default

1. Execute `restore.ps1` as administrator.
