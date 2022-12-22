#Requires -RunAsAdministrator

[cmdLetBinding()]
param(
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist"
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            if($_ -notmatch "(\.ps1)"){
                throw "The file specified in the path argument must be a .ps1 script"
            }
            return $true 
        })]
        [System.IO.FileInfo]$path
)

#if(!$path) { $command = read-host -Prompt "Enter command to be obfuscated " }
$command = "powershell.exe { write-host 'hello world' > C:\hi.txt } "
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$obfuscated = [convert]::ToBase64String($bytes) | Out-File -Force -FilePath "C:\test\raw.txt"

