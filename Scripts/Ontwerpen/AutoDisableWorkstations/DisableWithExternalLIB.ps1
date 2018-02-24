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
 
$ZoekenInOU="ou=Active,OU=Workstations,OU=Support,DC=sardjoe,DC=pri" 
$PlaatsenInOU="ou=Hibernation,OU=Workstations,OU=Support,DC=sardjoe,DC=pri" 
  
$AantalDagenInactief = 60 
	
$Vandaag = Get-Date -Format g
     
$WerkstationDescription = "Workstation is disabled due to inactivity for 60 days on $Vandaag" 
 
 
Get-QADComputer -InactiveFor $AantalDagenInactief -SizeLimit 0 -SearchRoot $ZoekenInOU -IncludedProperties ParentContainerDN | foreach {  
 
    $computer = $_.ComputerName 
    $SourceOU = $_.DN 
     
    $WerkstationDescription = "Source OU was $SourceOu" 
     
    Set-QADComputer $computer -Description $WerkstationDescription 
 
    Disable-QADComputer $computer 
 
    Move-QADObject $computer -NewParentContainer $PlaatsenInOU  
	Write-Host -ForegroundColor Yellow "Werkstation $computer verplaatst naar $PlaatsenInOU"
 
}