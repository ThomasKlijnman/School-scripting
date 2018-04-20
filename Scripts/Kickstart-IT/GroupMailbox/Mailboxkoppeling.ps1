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
echo "Shared mailbox koppelen aan een Universal group"
echo "Importing modules..."
echo ""
Import-Module ActiveDirectory
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;

$LogPath = "\\ZEUS\log\"

$Username = Read-Host 'Privileged Account.'
$LoginPassword = Get-Credential "KICKSTART-IT\$Username"

$SharedMailbox = Read-Host 'Voer de naam van de Shared mailbox in:'
$UniversalGroup = Read-Host 'Voer de naam van de Universal group in:'
​
Get-Mailbox $SharedMailbox | Add-ADPermission -User $UniversalGroup -ExtendedRights "Send As"
Get-Mailbox $SharedMailbox | Add-MailboxPermission -User $UniversalGroup -AccessRights FullAccess

  Write-Output "Log bestand schrijven.."
     $generatelog1 = New-PSDrive LogFile -PSProvider FileSystem -Root $LogPath -Credential $LoginPassword
	 $generatelog2 = "$Username heeft de Shared mailbox $SharedMailbox gekoppeld met $UniversalGroup - $(Get-Date -Format g)" | Out-File -Encoding utf8 -FilePath LogFile:\SharedmailboxKoppeling\$newFolderName.txt
	 $generatelog3 = Remove-PSDrive LogFile