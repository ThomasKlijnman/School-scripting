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
#	Dit script is gebaseerd op eigen code 
#   En is volledig te gebruiken in de huidige Powershell versie 5.1+
#	{Please use this code at own risk}
#	
##############  Script begint hier ##########

echo " _____  _  __ _    	"
echo "/__ __\/ |/ // \   	"
echo "  / \  |   / | |   	"
echo "  | |  |   \ | |_/\	"
echo "  \_/  \_|\_\\____/	"
echo ""
echo "Script voor het aanmaken van meerdere gebruikers tegelijk"
echo "Importing Modules and Files....."
echo ""

$Username = Read-Host 'Privileged Account. Formaat: {gebruikersnaam}'
$csv = Import-Csv -Path ".\users.csv"
$LoginPassword = Get-Credential "sardjoe\$Username"
$ADDomain = "@sardjoe.pri"
$LogPad = "\\FS02\log"
$DCPath = ",DC=sardjoe,DC=pri"

ForEach ($item In $csv) {
try { Get-ADUser $item.Username -ErrorAction SilentlyContinue
    Write-Host "User $item.Username bestaat al." -foregroundcolor Red}
catch { 

        $StarterPassword = $item.Password | ConvertTo-SecureString -AsPlainText -Force
        $create_user = New-ADUser -Name $item.Username -GivenName $item.Voornaam -Surname $item.Achternaam -UserPrincipalName ($item.Username + $ADDomain) -AccountPassword $StarterPassword -ChangePasswordAtLogon $True -Enabled $True -Path ($item.OUPath + $DCPath) -Credential $LoginPassword
	    $add_to_group = Add-ADGroupMember -Identity $item.AfdelingsGroep -Member $item.Username
        Write-Host -ForegroundColor Yellow "User $($item.Username) aangemaakt!"
            
            $OFS = "`r`n"
			$generatelog1 = New-PSDrive -Name LogFile -PSProvider FileSystem -Root $LogPad -Credential $LoginPassword
			$generatelog2 = "$Username created $($item.Username) and is added to group : $($item.Afdelingsgroep)" + $OFS + "Time and date: $(Get-Date -Format g)" | Out-File -Encoding utf8 -FilePath LogFile:\$($item.Username).txt
			$generatelog3 = Remove-PSDrive LogFile
			
		Write-Host -ForegroundColor Green "Log file geregistreerd"
    }
}

PAUSE