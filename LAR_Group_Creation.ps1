################################## Geen synopsis ######################################
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
###############################  Script starts Here ##################################

echo "   _  ___      _        _             _     _____ _______  "
echo "  | |/ (_)    | |      | |           | |   |_   _|__   __| "
echo "  | | / _  ___| | _____| |_ __ _ _ __| |_    | |    | |    "
echo "  |  < | |/ __| |/ / __| __/ _| | |__| __|   | |    | |    "
echo "  | | \| | (__|   <\__ \ || (_| | |  | |_   _| |_   | |    "
echo "  |_|\_\_|\___|_|\_\___/\__\__,_|_|   \__| |_____|  |_|    "
echo "  "
echo "Script voor het aanmaken van een LAR groep"
echo ""
$Username = Read-Host 'Privileged Account.'
$csv = Import-Csv -Path ".\groups.csv"
$LoginPassword = Get-Credential "KICKSTART-IT\$Username"
$myPath = "\\Zeus\log$\LAR"
$Create_in_OU = "OU=Groups,OU=Beheer,DC=kickstart-it,DC=local"

ForEach ($item In $csv) {
try { Get-ADGroup ($item.GroupName + "_Administrators") -ErrorAction SilentlyContinue
    Write-Host "Group ($item.GroupName + "_Administrators") bestaat al." -foregroundcolor Green}
catch { 
        $create_group = New-ADGroup -Name ($item.GroupName + "-Administrators") -GroupCategory Security -GroupScope Global -Path $Create_in_OU -Credential $LoginPassword
		$update_group = Set-ADGroup -Identity ($item.GroupName + "-Administrators") -Replace @{info="$($Username + " Added " + $item.GroupName)"} -Credential $LoginPassword
        Write-Host -ForegroundColor Green "Groep $($item.GroupName) aangemaakt!"
		$add_member = Add-ADGroupMember ($item.GroupName + "-Administrators") $item.Members -Credential $LoginPassword
		Write-Host -ForegroundColor Green "Gebruiker(s) toegevoegd aan $($item.GroupName)"

			$generatelog1 = New-PSDrive LogFile -PSProvider FileSystem -Root $myPath -Credential $LoginPassword
			$generatelog2 = "$Username Heeft de LAR groep: $($item.GroupName) aangemaakt! - $(Get-Date -Format g)" | Out-File -Encoding utf8 -FilePath LogFile:\$($item.GroupName).txt
			$generatelog3 = Remove-PSDrive LogFile
			
		Write-Host -ForegroundColor Green "Log file geregistreerd"
    }
}
	
PAUSE