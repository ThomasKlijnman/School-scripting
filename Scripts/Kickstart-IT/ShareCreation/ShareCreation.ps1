#############################################
#  _______ _                                 _  ___ _ _                             
# |__   __| |                               | |/ / (_|_)                            
#    | |  | |__   ___  _ __ ___   __ _ ___  | ' /| |_ _ _ __  _ __ ___   __ _ _ __  
#    | |  | '_ \ / _ \| '_ ` _ \ / _` / __| |  < | | | | '_ \| '_ ` _ \ / _` | '_ \ 
#    | |  | | | | (_) | | | | | | (_| \__ \ | . \| | | | | | | | | | | | (_| | | | |
#    |_|  |_| |_|\___/|_| |_| |_|\__,_|___/ |_|\_\_|_| |_| |_|_| |_| |_|\__,_|_| |_|
#                                                   _/ |                            
#                                                  |__/  
#	Author - @ThomasKlijnman
#	Email - thomas@klijnman.nl
#	Dit script is gebaseerd op eigen code en is geplaatst een huidige Github omgeving.
#   En is volledig te gebruiken in de huidige Powershell versie 5.1+
#	{Please use this code at own risk}
#	
##############  Script starts Here ##########

echo "   _  ___      _        _             _     _____ _______  "
echo "  | |/ (_)    | |      | |           | |   |_   _|__   __| "
echo "  | | / _  ___| | _____| |_ __ _ _ __| |_    | |    | |    "
echo "  |  < | |/ __| |/ / __| __/ _| | |__| __|   | |    | |    "
echo "  | | \| | (__|   <\__ \ || (_| | |  | |_   _| |_   | |    "
echo "  |_|\_\_|\___|_|\_\___/\__\__,_|_|   \__| |_____|  |_|    "
echo "  "
echo "Script for aanmaken van File shares. Ook in Bulk"
echo ""
Import-Module ActiveDirectory

$Username = Read-Host 'Privileged Account.'
$LoginPassword = Get-Credential "KICKSTART-IT\$Username"

$path = "\\Zeus\Projects\"
$newFolderName = Read-Host -Prompt "Voor de naam van de nieuwe folder in"
$newFolderFull = $path + $newFolderName
Write-Host "Nieuwe folder naam: $newFolderFull"

$LogPath = "\\Zeus\log$"
$ADPath = "OU=Groups,OU=Beheer,DC=Kickstart-IT,DC=local"
$confirm = Read-Host "Correct? Y/N"

If(($confirm) -ne "y")
{
 End
}

Else {
 Write-Host -ForegroundColor Green "Security groepen aanmaken.."
  $groupnameM = "G-FS-Project-$newFolderName-M"
  $groupnameR = "G-FS-Project-$newFolderName-R"
    New-AdGroup $groupNameM -samAccountName $groupNameM -GroupScope Global -path $ADPath -Description "Globale File share voor het project $newFolderName"
    New-AdGroup $groupNameR -samAccountName $groupNameR -GroupScope Global -path $ADPath -Description "Globale File share voor het project $newFolderName"

 Write-Host -ForegroundColor Green "Folder toevoegen.."
    New-Item $newFolderFull -ItemType Directory

 Write-Host -ForegroundColor Green "Kopiëren van inheritance.."
    icacls $newFolderFull /inheritance:e
    
    $readOnly = [System.Security.AccessControl.FileSystemRights]"ReadAndExecute"
    $readWrite = [System.Security.AccessControl.FileSystemRights]"Modify"
    
    $inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
    
    $propagationFlag = [System.Security.AccessControl.PropagationFlags]::None
    
    $userM = New-Object System.Security.Principal.NTAccount($groupNameM)
    $userR = New-Object System.Security.Principal.NTAccount($groupNameR)
    
    $type = [System.Security.AccessControl.AccessControlType]::Allow
    $accessControlEntryDefault = New-Object System.Security.AccessControl.FileSystemAccessRule @("Domain Users", $readOnly, $inheritanceFlag, $propagationFlag, $type)
    $accessControlEntryM = New-Object System.Security.AccessControl.FileSystemAccessRule @($userM, $readWrite, $inheritanceFlag, $propagationFlag, $type)
    $accessControlEntryR = New-Object System.Security.AccessControl.FileSystemAccessRule @($userR, $readOnly, $inheritanceFlag, $propagationFlag, $type)
    $objACL = Get-ACL $newFolderFull
    $objACL.RemoveAccessRuleAll($accessControlEntryDefault)
    $objACL.AddAccessRule($accessControlEntryM)
    $objACL.AddAccessRule($accessControlEntryR)
    Set-ACL $newFolderFull $objACL

 Write-Host -ForegroundColor Green "Log bestand schrijven.."
    $generatelog1 = New-PSDrive LogFile -PSProvider FileSystem -Root $LogPath -Credential $LoginPassword
	$generatelog2 = "$Username heeft het project $newFolderName toegevoegd met de groepen $groupnameM en $groupnameR - $(Get-Date -Format g)" | Out-File -Encoding utf8 -FilePath LogFile:\ProjectCreation\$newFolderName.txt
	$generatelog3 = Remove-PSDrive LogFile

}
