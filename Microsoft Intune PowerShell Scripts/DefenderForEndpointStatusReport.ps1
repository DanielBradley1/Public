Connect-MgGraph -Scopes DeviceManagementConfiguration.Read.All

$body = @'
{
  "filter": "",
  "format": "csv",
  "select": [
    "DeviceName",
    "_ManagedBy",
    "IsWDATPSenseRunning",
    "WDATPOnboardingState",
    "LastReportedDateTime",
    "UPN",
    "DeviceId"
  ],
  "skip": 0,
  "top": 0,
  "search": "",
  "reportName": "DefenderAgents"
}
'@

$response = Invoke-MgGraphRequest -Method POST -uri "/beta/deviceManagement/reports/exportJobs" -Body $body

$uri = "https://graph.microsoft.com/beta/deviceManagement/reports/exportJobs('" + "$($response.id)" + "')"

$response2 = Invoke-MgGraphRequest -Method GET -Uri $uri

Invoke-MgGraphRequest -Method GET -Uri $response2.url -OutputFilePath C:\temp\report2.zip
