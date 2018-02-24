import-csv -path c:\temp\users.csv | foreach {
 
$voornaam = $_.name.split()[0] 
$achternaam = $_.name.split()[1]
$domain = "{DOMEIN NAAM HOLDER}"
 
new-aduser -name $_.name -enabled $true –givenName $voornaam –surname $achternaam -accountpassword (convertto-securestring $_.password -asplaintext -force) -changepasswordatlogon $true -samaccountname $_.samaccountname –userprincipalname ($_.samaccountname+”@$domain”) -department $_.department
}