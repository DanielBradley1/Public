####
#Name: Daniel Bradley
#LinkedIn: https://www.linkedin.com/in/danielbradley2/
#Description: This script will automatically check if your MDM user scope is configured. If it is set to none, it will assign all users to the scope.
####

Import-Module Microsoft.Graph.Identity.SignIns

Select-MgProfile -Name beta

Connect-MgGraph -Scopes Policy.Read.All, Policy.ReadWrite.MobilityManagement

$uri = "https://graph.microsoft.com/beta/policies/mobileDeviceManagementPolicies/0000000a-0000-0000-c000-000000000000/?$select=appliesTo"
$mdmscope = $null
$mdmscope = Invoke-MgGraphRequest -Uri $uri -Method GET

Write-host "Checking MDM Scope settings" -BackgroundColor yellow -ForegroundColor black
sleep 2

If ($mdmscope.appliesTo -eq "none") {
    write-host "MDM scope not set" -backgroundcolor Red
    sleep 2
    write-host "Setting MDM scope to All" -backgroundcolor yellow -ForegroundColor Black
    sleep 2

    try {
        $uripatch = "https://graph.microsoft.com/beta/policies/mobileDeviceManagementPolicies/0000000a-0000-0000-c000-000000000000/?$select=appliesTo"
        $json = @'
        {
        "@odata.context": "https://graph.microsoft.com/beta/$metadata#mobilityManagementPolicies(appliesTo)/$entity",
        "appliesTo": "All"
        }
'@
       
        Invoke-MgGraphRequest -uri $uripatch -body $json -method PATCH -ContentType "Application/Json"
        
        } catch {"Unable to set MDM scope"}
        
    Write-Host "MDM scope successfully set to All" -BackgroundColor Green -ForegroundColor Black

} elseif ($mdmscope.appliesTo -eq "selected") {
    $uri = "https://graph.microsoft.com/beta/policies/mobileDeviceManagementPolicies/" + $mdmscope.id + "/includedGroups"
    $PolicyGroups = Invoke-MgGraphRequest -uri $uri -method GET
    $IncludedGroup = $policyGroups.Values.DisplayName
    Write-Host "MDM scope is set to" $IncludedGroup -BackgroundColor Green -ForegroundColor Black
    sleep 2
}
