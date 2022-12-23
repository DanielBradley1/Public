####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: https://ourcloudnetwork.com/configure-device-extension-attributes-in-azure-ad-with-powershell/
####

#Import module
Import-Module Microsoft.Graph.Identity.DirectoryManagement

#Select beta profile
Select-MgProfile -Name "beta"

#Connect to Microsoft Graph
Connect-mgGraph -Scopes Device.Read.All, Directory.ReadWrite.All, Directory.AccessAsUser.All

#Store devices
$AzureADJoinedDevices = Get-MgDevice | Where-Object {$_.EnrollmentType -eq "AzureDomainJoined"}

#Loop through devices
ForEach ($device in $AzureADJoinedDevices) {

#Store URI path
$uri = $null
$uri = "https://graph.microsoft.com/beta/devices/" + $device.id

#Define attribute values
$json = @{
      "extensionAttributes" = @{
      "extensionAttribute1" = "Corporate Device"
         }
  } | ConvertTo-Json
  
#Assign attributes
Invoke-MgGraphRequest -Uri $uri -Body $json -Method PATCH -ContentType "application/json"
}
