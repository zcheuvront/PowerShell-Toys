#Requires -RunAsAdministrator

# 2880 characters
$global:Ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer ullamcorper mi in lacus molestie, eu varius arcu vehicula. Sed condimentum est aliquet mattis rhoncus. Pellentesque elit magna, placerat sit amet finibus non, rutrum in urna. In placerat lobortis eros non fringilla. Nunc malesuada sem in purus aliquet, in molestie mi tempor. Ut aliquam, diam vitae consequat faucibus, justo urna facilisis erat, ac pulvinar nisi tellus quis velit. Maecenas at rhoncus justo, iaculis posuere odio. Quisque eget tempus massa. Nullam vulputate ut ipsum non porttitor. Suspendisse in justo tincidunt, euismod metus quis, gravida urna. Sed semper, velit non feugiat cursus, justo erat eleifend urna, lobortis pretium quam tellus quis mi. Aliquam a bibendum lorem. Aliquam vestibulum neque quis urna venenatis, non dictum lectus aliquet. Duis eu diam vel diam porta placerat sed ut nibh. Quisque quis rutrum sapien, sed pulvinar enim. Nunc venenatis lectus nibh, id rutrum massa convallis vitae. Maecenas aliquet, lectus id volutpat viverra, lacus urna ultricies sem, vel fermentum risus mauris vitae erat. Nam velit elit, finibus nec odio at, vehicula semper nisi. Pellentesque ultricies vulputate lectus sed blandit. Etiam id pretium nunc, ac maximus sem. Donec dignissim aliquam justo vel malesuada. Pellentesque dictum sem augue, sit amet aliquet enim feugiat vel. Donec ac volutpat augue, eu suscipit tellus. Aenean tincidunt ex dolor, sit amet lacinia arcu eleifend sed. Curabitur consequat orci eget turpis vestibulum, eu aliquet metus hendrerit. Etiam massa lectus, auctor quis leo vel, ultricies consequat metus. Praesent justo eros, eleifend vel dignissim et, tincidunt eget dui. Mauris bibendum nisi risus, a convallis est tempus vitae. Aenean porttitor tortor laoreet rutrum porta. Morbi tincidunt mollis diam, in volutpat velit vestibulum ut. Vivamus a vehicula tortor, sed semper lorem. In cursus volutpat maximus. Maecenas sagittis placerat suscipit. Cras pharetra risus eu turpis egestas aliquet. Etiam volutpat erat venenatis risus maximus, non dapibus tortor accumsan. Curabitur pretium enim quam, sed convallis augue scelerisque lobortis. Aenean purus lacus, volutpat a semper quis, sollicitudin at orci. Nulla auctor et magna ut euismod. Ut ut congue tellus. Ut a pharetra tortor. Curabitur mattis pellentesque leo fringilla tristique. Vestibulum rhoncus diam magna, sed viverra sem volutpat vel. Pellentesque et tempus dui. Fusce eleifend arcu non finibus aliquam. Morbi gravida vitae nulla nec tempus. Curabitur sollicitudin arcu id velit convallis ultrices. Vestibulum a sapien dignissim turpis fringilla commodo vitae vel diam. Mauris viverra elit tortor, in dictum velit congue nec. Nunc vitae eleifend nisi. Proin gravida justo nec turpis accumsan, at placerat turpis molestie. Nulla facilisi. Aliquam risus augue, consectetur at purus eu, lacinia mattis ipsum."
$Global:BasePath = "$pwd\Q\"

function NullFile($FileList)
{
	foreach($File in $FileList)
	{
    #Write-Host $file.FullName
		$FileSize = $File.Length
		$f = new-object System.IO.FileStream $File.FullName, create, ReadWrite
		$f.SetLength($FileSize)
		$f.Close()
	}

}

function Show-Menu($flag1, $flag2, $flag3, $flag4) 
{
    Clear-Host
    Write-Host -F Green "================ CaddyCage Menu ================"
    
    Write-Host -F yellow "1: Press '1' to prepare the environment"
    Write-Host -F yellow "2: Press '2' to arm the malware"
    Write-Host -F yellow "3: Press '3' to execute"
    Write-Host -F yellow "4: Press '4' to cleanup"
    Write-Host -F yellow "Q: Press 'Q' to quit."
}

function GetFiles($FilePath)
{
	$FileList = Get-ChildItem $FilePath -Recurse
	return $FileList
}

function EnvironmentSetup()
{
	#Create folder structure in PWD 
	$Folders = "Q\Users\foo\Documents","Q\Users\foo\Downloads","Q\Users\foo\Desktop","Q\Users\foo\Pitures","Q\Users\foo\Videos"
	foreach($Folder in $Folders)
	{
		$TempPath = Join-Path $pwd $Folder
		New-Item -ItemType Directory -Path $TempPath -Force | Out-Null
	}
  Write-Host -F Green "[+] Built File Structure"

  $FileTypes = ".txt",".pdf",".docx",".rtf"
  for($i=0;$i -lt 4;$i++)
  {
    Foreach ($FileType in $FileTypes)
    {
      foreach ($Folder in $Folders)
      {
        $FileSize = Get-Random -Minimum 2 -Maximum 2880
        $TempPath2 = Join-Path $pwd $Folder
        New-Item -ItemType File -Path $TempPath2\$i$FileType -ErrorAction SilentlyContinue | Out-Null
        Set-Content -Path $TempPath2\$i$FileType -Value $Ipsum.Substring($FileSize)
      }
    }
  }
  Write-Host -F Green "     [+] Generated bogus files"
}

# Script starts here
$DefaultVariables = $(Get-Variable).Name
do
{
    Show-Menu($flag1, $flag2, $flag3, $flag4)
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
      '1' 
      {
        if($flag1)
        {
          Write-Host -F Red "ERROR: Dummy filesystem has already been created in $pwd\Q"
        }
        elseif (!$flag1)
        {
          EnvironmentSetup
          $flag1 = $true
        }
      } 

      '2' 
      {
        $flag2 = $true
      } 

      '3' 
      {
        # Execute
        $UserFiles = GetFiles($BasePath)
        NullFile($UserFiles)
      }

      '4'
      {
        Remove-Item $pwd\Q -Force -ErrorAction SilentlyContinue -Recurse
        $flag1,$flag2,$flag3,$flag4,$flag5 = $false
      }
    }
    pause
}
until ($selection -eq 'q')
((Compare-Object -ReferenceObject (Get-Variable).Name -DifferenceObject $DefaultVariables).InputObject).foreach{Remove-Variable -Name $_ -ErrorAction SilentlyContinue}
# todo:
# 	
# 	[x] create mock file structure
# 	[] Populate with files with random size of $Ipsum string (1-2880)
# 	[] Create recursive adversary ability
# 	[x] overwrite dummy files with matching size in null bytes (NullFile function)
# 	[] 
#
#	Stretch goal: spawn mapped webdav server to emulate network-facet of attack
# 	Stretch goal: Emulate the MBR wiping behavior 
# 	Stretch goal: Add verbose flag and option for directing output file natively