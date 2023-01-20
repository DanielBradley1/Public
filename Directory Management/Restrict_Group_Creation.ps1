#author: Daniel Bradley
#website: https://ourcloudnetwork.com
#linkedin: https://www.linkedin.com/in/danielbradley2/

Import-Module Microsoft.Graph.Groups
Import-Module Microsoft.Graph.Identity.DirectoryManagement
Select-MgProfile -name beta
Connect-MgGraph -Scopes "Group.ReadWrite.All", "GroupMember.ReadWrite.All", "Directory.ReadWrite.All"

$GroupName = "test"
$AllowGroupCreation = "False"

$groupid = (Get-MgGroup | Where-Object {$_.DisplayName -match $GroupName}).id

If (!$groupid) {
    Write-host "The specified group '$groupname' does not exist" -ForegroundColor Yellow
}

$settingsObjectID = (Get-MgDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id

if (!$SettingsObjectID) {
$templateid = (Get-MgDirectorySettingTemplate | Where-object {$_.displayname -eq "group.unified"}).id
$params = @{
	TemplateId = $templateid
}
New-MgDirectorySetting -BodyParameter $params
$settingsObjectID = (Get-MgDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
}

$params = @{
	Values = @(
		@{
			Name = "EnableGroupCreation"
			Value = "false"
		}
        @{
			Name = "GroupCreationAllowedGroupId"
			Value = $groupid
		}
	)
}

Update-MgDirectorySetting -DirectorySettingId $settingsObjectID `
-BodyParameter $params

Write-host "Group settings have been updated" -ForegroundColor Green
(Get-MgDirectorySetting -DirectorySettingId $settingsObjectID).values
