$files = Get-ChildItem .\src\* -Include ('*.dll') -File
Write-Host "SHA1 code for the patched dlls are:"
$files | ForEach-Object {
    $hash = Get-FileHash -Path $_.FullName -Algorithm SHA1
    Write-Host $_.Name - $hash.Hash
}
