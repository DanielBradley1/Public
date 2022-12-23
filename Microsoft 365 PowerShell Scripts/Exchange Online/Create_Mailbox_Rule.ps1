####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: https://ourcloudnetwork.com/how-to-create-mailbox-rules-with-microsoft-graph-powershell/
####

#Import the graph module
Import-Module Microsoft.Graph.Mail

#Connect to Microsoft Graph
Connect-MgGraph -Scope MailboxSettings.Read, MailboxSettings.ReadWrite, Mail.ReadWrite

#Complete the below with the requested information
$targetuser = "your UPN here"
$targetfolder = "Target folder name here"
$userid = $targetuser

#Store the target folder
$targetfolder = Get-MgUserMailFolder -UserId $userId -filter "DisplayName eq '$targetfolder'"

#Store the inbox folder (New rules can only be created on the inbox folder)
$MailboxFolder = Get-MgUserMailFolder -UserId $userId -filter "DisplayName eq 'inbox'"

#Define the Conditions and Actions
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

#Create the rule
New-MgUserMailFolderMessageRule -UserId $userId -MailFolderId $mailboxfolder.id -BodyParameter $params
