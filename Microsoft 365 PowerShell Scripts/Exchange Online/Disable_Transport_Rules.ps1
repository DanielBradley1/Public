####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: https://ourcloudnetwork.com/how-to-determine-which-active-rules-impact-email-attachments/
####

#Import module
Import-Module ExchangeOnlineManagement

#Connect to Exchange Online
Connect-ExchangeOnline

#View a list of enabled transport rules
Get-TransportRule | Where-Object {$_.State -eq "Enabled"}

#Define and store your transport rule
$Rule = Get-TransportRule -Identity "###Block .exe attachments###"

#Check if enabled and disable the rule
If ($rule.state -eq "Enabled") {
   Disable-TransportRule -Identity $Rule.Name -confirm:$false
    Write-host $rule.name ": has been disabled" -ForegroundColor black -BackgroundColor green
} Else {
    Write-host $rule.name ": is already disabled" -ForegroundColor black -BackgroundColor yellow
}
