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
echo "Script voor het configureren van een specifieke App-V Server"
echo ""
$Hostname = Read-Host 'Voer hostnaam van de Server in'
$URL = Read-Host 'Voer web URL van de App-V publish Server in'

Add-AppvPublishingServer -Name $Hostname -URL$ $URL

Sync-AppvPublishingServer -ServerId 1

PAUSE