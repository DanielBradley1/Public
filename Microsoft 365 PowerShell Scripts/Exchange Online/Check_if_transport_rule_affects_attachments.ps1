####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: https://ourcloudnetwork.com/how-to-determine-which-active-rules-impact-email-attachments/
####

#Connect to Exchange Online
Connect-ExchangeOnline

#Store exact rule name
$rulename = "Block certain messages"

#Store rule parameters which affect attachments
$attachmentrules = get-transportrule "$rulename" | Select *attachment*

#Convert array objects to string
$string1 = $attachmentrules.AttachmentExtensionMatchesWords | out-string
$attachmentrules.AttachmentExtensionMatchesWords = $string1
$string2 = $attachmentrules.AttachmentNameMatchesPatterns | out-string
$attachmentrules.AttachmentNameMatchesPatterns = $string2
$string3 = $attachmentrules.AttachmentPropertyContainsWords | out-string
$attachmentrules.AttachmentPropertyContainsWords = $string3
$string4 = $attachmentrules.AttachmentContainsWords | out-string
$attachmentrules.AttachmentContainsWords = $string4
$string5 = $attachmentrules.AttachmentMatchesPatterns | out-string
$attachmentrules.AttachmentMatchesPatterns = $string5
$string6 = $attachmentrules.ExceptIfAttachmentNameMatchesPatterns | out-string
$attachmentrules.ExceptIfAttachmentNameMatchesPatterns = $string6
$string7 = $attachmentrules.ExceptIfAttachmentExtensionMatchesWords | out-string
$attachmentrules.ExceptIfAttachmentExtensionMatchesWords = $string7
$string8 = $attachmentrules.ExceptIfAttachmentPropertyContainsWords | out-string
$attachmentrules.ExceptIfAttachmentPropertyContainsWords = $string8
$string9 = $attachmentrules.ExceptIfAttachmentSizeOver | out-string
$attachmentrules.ExceptIfAttachmentSizeOver = $string9
$string10 = $attachmentrules.ExceptIfAttachmentContainsWords | out-string
$attachmentrules.ExceptIfAttachmentContainsWords = $string10
$string11 = $attachmentrules.ExceptIfAttachmentMatchesPatterns | out-string
$attachmentrules.ExceptIfAttachmentMatchesPatterns = $string11
$string = "$attachmentrules"

#Create Report object
$Report = [System.Collections.Generic.List[Object]]::new()

#Define regex parameters
$reg = [RegEx]"(\w+)=(\w*)"

#Create report to review
$table=@()
$table = $reg.Matches($string) | ForEach-Object {
    $rhs = if($_.Groups[2].Value){
        $_.Groups[2].Value
    }else{
        "N/A"
    }
    $obj = [PSCustomObject][ordered]@{
        "TYPE" = $_.Groups[1].Value
        "VALUE" = $rhs
    }
    $Report.Add($obj)
} | Format-Table

#Display report in session
$report

#Export report to CSV
$report | export-csv C:\temp\MailRuleAttachmentInfo.csv -NoTypeInformation
