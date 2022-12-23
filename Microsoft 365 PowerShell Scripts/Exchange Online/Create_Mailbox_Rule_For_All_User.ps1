####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: https://ourcloudnetwork.com/how-to-create-mailbox-rules-with-microsoft-graph-powershell/
####

#Import Module
Import-Module Microsoft.Graph.Mail

#Store connection information
$appid = 'YOUR APPLICATION ID'
$tenantid = 'YOUR TENANT ID'
$secret = 'YOUR CLIENT SECRET >VALUE<'
 
#Store request body
$body =  @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $appid
    Client_Secret = $secret
}

#Sent HTTPs request to Microsoft 
$connection = Invoke-RestMethod `
    -Uri https://login.microsoftonline.com/$tenantid/oauth2/v2.0/token `
    -Method POST `
    -Body $body
 
#Store access token
$token = $connection.access_token
 
#Connect to Microsoft Graph
Connect-MgGraph -AccessToken $token

#Define target folder
$targetfolder = "Folder where you want to move mail to"

#Store all users
$allusers = get-mguser -Property UserType, Displayname, Id, Mail, UserPrincipalName | where-object {$_.UserType -eq "Member"}

#Apply rule to all users
ForEach ($user in $allusers) {

#Null variables
$vtargetfolder = $null
$MailboxFolder = $null

#Store targer and inbox folder
$vtargetfolder = Get-MgUserMailFolder -UserId $user.Id -filter "DisplayName eq '$targetfolder'"
$MailboxFolder = Get-MgUserMailFolder -UserId $user.id -filter "DisplayName eq 'inbox'"

#Check if Target folder exists
If ($vtargetfolder -eq $null) {
write-host "Folder:" $targetfolder " is missing for" $user.DisplayName
} else{

#Define rule conditions and actions
$params = @{
	DisplayName = "Company-Wide Move To Training Folder"
	Sequence = 2
	IsEnabled = $true
	Conditions = @{
		SenderContains = @(
			"infomail@mycompany.com"
		)
	    }
	Actions = @{
		moveToFolder = $targetfolder.id
		StopProcessingRules = $true
	    }
    }
    
    #Create new rule
    New-MgUserMailFolderMessageRule -UserId $user.id -MailFolderId $mailboxfolder.id -BodyParameter $params | out-null
    Write-host "Mailbox rule created successfully for" + $user.DisplayName
    }
}
