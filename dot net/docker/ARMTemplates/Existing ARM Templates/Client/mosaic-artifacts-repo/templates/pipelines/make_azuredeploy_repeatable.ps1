$url = "$(System.TeamFoundationServerUri)$(System.TeamProjectId)/_apis/Release/releases/$(Release.ReleaseId)?api-version=6.0-preview.8"

Write-Host "URL: $url"
$pipeline = Invoke-RestMethod -Uri $url -Headers @{
    Authorization = "Bearer $(System.AccessToken)" # Provided by ADO thanks to OAuth checkbox
}

# Change the value of var2 to be persisted in the rest of the run.
$pipeline.variables.newOrExisting.value = "existing"

# Alternatively create new variable in cases when it's not present.
# $pipeline.variables  | Add-Member -MemberType NoteProperty -Name $name -Value @{value=$env.Value} -Force

# $json = @($pipeline) | ConvertTo-Json -Depth 99
# Invoke-RestMethod -Uri $url -Method Put -Body $json -ContentType "application/json" -Headers @{Authorization = "Bearer $(System.AccessToken)"}
