####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: https://ourcloudnetwork.com/export-m365-group-members-with-microsoft-graph-powershell/
####

#Install MS Graph if not available
if (Get-Module -ListAvailable -Name Microsoft.Graph.Groups) {
} 
else {
        Install-Module -Name Microsoft.Graph.Groups -Scope CurrentUser -Repository PSGallery -Force 
        Write-Host "Microsoft Graph Authentication Installed"
}

#Import Module 
Import-Module Microsoft.Graph.Groups

#Connect to organization
Connect-MgGraph -Scopes Group.Read.All, GroupMember.Read.All

#Create report object
$Report = [System.Collections.Generic.List[Object]]::new()

#Find all Groups
$GroupList = Get-MgGroup

#Loop through each group
ForEach ($group in $GroupList){

#Create variable for friendly group name output
If ($group.GroupTypes = "Unified") {
        $grouptype = "Microsoft 365 Group"
       }
     
#Store all members of current group
    $users = Get-MgGroupMember -GroupID $group.id

#Store members information
    [string]$MemberNames
    [array]$UserData = $users.AdditionalProperties
    [string]$MemberNames = $UserData.displayName -join ", "

#Add group and member information to report
      $ReportLine = [PSCustomObject][Ordered]@{  
       "Group Name"             = $group.DisplayName
       "Group Type"             = $grouptype
       "Group Members"          = $MemberNames 
      }
      $Report.Add($ReportLine)
      
}

#Export report to CSV
$Report | Export-CSV -NoTypeInformation C:\temp\report.csv
