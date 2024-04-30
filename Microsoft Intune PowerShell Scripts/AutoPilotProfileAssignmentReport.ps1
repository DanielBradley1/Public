Connect-MgGraph -Scopes DeviceManagementServiceConfig.Read.All

$apdevices = Get-MgBetaDeviceManagementWindowsAutopilotDeviceIdentity -All

$Report = [System.Collections.Generic.List[Object]]::new()

forEach ($device in $apdevices) {
    
    $batch = @"
{
  "requests": [
    {
      "id": "1",
      "method": "GET",
      "url": "/deviceManagement/windowsAutopilotDeviceIdentities/$($device.Id)?`$expand=deploymentProfile,intendedDeploymentProfile"
    },
    {
      "id": "2",
      "method": "GET",
      "url": "/devices/deviceid_$($device.AzureAdDeviceId)?`$select=displayName"
    }
  ]
}
"@

    $response = Invoke-MgGraphRequest `
    -Method POST `
    -URI "https://graph.microsoft.com/beta/`$batch" `
    -body $batch `
    -OutputType PSObject

    $obj = [PSCustomObject][ordered]@{
        "DisplayName" = $response.responses.body.displayName | Where {$_ -ne $null}
        "AutoPilot Profile" = $response.responses.body.deploymentprofile.displayname
    }
    $report.Add($obj)
}

$report
