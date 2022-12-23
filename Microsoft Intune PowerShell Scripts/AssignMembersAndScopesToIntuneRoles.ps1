####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: https://ourcloudnetwork.com/how-to-create-custom-intune-roles-with-powershell/
####

###
$DisplayName = "My Display Name" #Define a name for your role assignment
$AdminGroupName = "Approval Admins" #Define the group that contains the user you wish you assign this role to
$RoleName = "Read-Only Device Role" #Define the name of the active role
###

#Import Module
Import-Module Microsoft.Graph.DeviceManagement.Administration

#Select beta profile
Select-MgProfile -Name Beta

#Connect to Microsoft Graph
Connect-MgGraph -scopes DeviceManagementRBAC.ReadWrite.All

$Role = Get-MgDeviceManagementRoleDefinition | Where-Object {$_.DisplayName -eq $Rolename}
$admingroup = Get-MgGroup | Where-Object {$_.DisplayName -eq $AdminGroupName} | select id

#Store URI path
$uri = "https://graph.microsoft.com/beta/deviceManagement/roleAssignments"

#Store Json payload
$json = @'
{
"id":"",
"description":"",
"displayName":"<dname>",
"members":["<admgroup>"],
"resourceScopes":[],
"roleDefinition@odata.bind":"https://graph.microsoft.com/beta/deviceManagement/roleDefinitions('<roleid>')",
"scopeType":"allDevices"
}
'@

#Update unique payload information.
$json = $json -replace '<roleid>',$Role.id
$json = $json -replace '<dname>',$DisplayName
$json = $json -replace '<admgroup>',$admingroup.id


#Create role assignment
Invoke-MgGraphRequest -Uri $uri -body $json -Method POST -ContentType "application/json"
