####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: https://ourcloudnetwork.com/how-to-create-custom-intune-roles-with-powershell/
####

###
$DisplayName = "My Custom Role2" #Define your role name
$RoleDescription = "My custom role description2" #Define the role description
###

#Import module
Import-Module Microsoft.Graph.DeviceManagement.Administration

#Select beta profile
Select-MgProfile -Name Beta

#Connect to Microsoft Graph
Connect-MgGraph -scopes DeviceManagementRBAC.ReadWrite.All

#Store the URI path
$uri = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions/"

#Store Json Payload
$json = @'
		{
    "@odata.context": "https://graph.microsoft.com/beta/$metadata#deviceManagement/roleDefinitions/$entity",
    "@odata.type": "#microsoft.graph.deviceAndAppManagementRoleDefinition",
    "displayName": "<rname>",
    "description": "<rdesc>",
    "isBuiltInRoleDefinition": true,
    "isBuiltIn": true,
    "roleScopeTagIds": [],
    "permissions": [
        {
            "actions": [
                "Microsoft.Intune_Organization_Read",
            ],
            "resourceActions": [
                {
                    "allowedResourceActions": [
                        "Microsoft.Intune_ManagedDevices_Read",
                    ],
                    "notAllowedResourceActions": []
                }
            ]
        }
    ],
    "rolePermissions": [
        {
            "actions": [
                "Microsoft.Intune_ManagedDevices_Read",
            ],
            "resourceActions": [
                {
                    "allowedResourceActions": [
                        "Microsoft.Intune_ManagedDevices_Read",
                    ],
                    "notAllowedResourceActions": []
                }
            ]
        }
    ]
}
'@

#Update unique payload information
$json = $json -replace '<rname>',$DisplayName
$json = $json -replace '<rdesc>',$RoleDescription

#Create custom Intune role
Invoke-MgGraphRequest -Uri $uri -body $json -Method POST -ContentType "application/json"
