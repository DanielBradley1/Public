####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: https://ourcloudnetwork.com/get-a-list-of-all-users-mfa-status-in-azure-ad-with-powershell/
####

#Connect to Microsoft Online
Connect-MsolService

#Get all user accounts
Write-Host "Finding accounts..." -ForegroundColor white -BackgroundColor Black
$Users = Get-MsolUser -All | Where-Object { $_.UserType -ne "Guest" }

#create a new object
$Report = [System.Collections.Generic.List[Object]]::new()

#pause and display information
Start-Sleep 1.5
Write-Host $users.count "Accounts found" -ForegroundColor white -BackgroundColor Black

#Loop through each user, gather information on mfa status and methods and add to report
ForEach ($user in $users) {
    $mfadefaultmethod = ($User.StrongAuthenticationMethods | Where-Object { $_.IsDefault -eq "True"}).methodtype
    $userupn = $user.UserPrincipalName
    $displayname = $user.displayname
    If (($user.StrongAuthenticationRequirements.state) -eq "Enforced") {
        $state = $User.StrongAuthenticationRequirements.State
    }
    Else {
        $state = 'Disabled'
    }
    If ($mfadefaultmethod) {
        Switch ($mfadefaultmethod) {
        "OneWaySMS" { $Method = "SMS" }
        "TwoWayVoiceMobile" { $Method = "Phone call" }
        "PhoneAppOTP" { $Method = "Hardware token or authenticator app" }
        "PhoneAppNotification" { $Method = "Authenticator app" }
        }
    }
    Else {
        $mfadefaultmethod = "Not set"
   }
     $ReportLine = [PSCustomObject] @{
        UserPrincipalName = $User.UserPrincipalName
        DisplayName       = $User.DisplayName
        MFAState          = $State
        MFADefaultMethod  = $MFADefaultMethod
    }          
    $Report.Add($ReportLine)
   }
   
#Export report to CSV file
$Report | Export-CSV -Encoding UTF8 -NoTypeInformation "c:\temp\m365mfareport.csv"
Write-Host "Data exported to C:\temp folder" -ForegroundColor white -BackgroundColor Black
