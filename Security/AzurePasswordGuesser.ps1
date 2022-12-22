# 

[cmdLetBinding()]
param(
    [ValidateScript]
        [System.IO.FileInfo] $pathtocsv
)

$creds = Import-Csv $pathtocsv
