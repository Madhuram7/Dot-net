# Get params, PowerShell is used here, can be done in VSC terminal
Set-AzDataFactoryV2 -ResourceGroupName $rg -Name $adfv2 -Location $l

$rg = 'temp-mosaic-group'
$l = 'eastus2'

$adfv2_id = Get-AzDataFactoryV2 -ResourceGroupName $rg -Name $adfv2
$sub_id = (Get-AzContext).Subscription.id

# Give ADFv2 MI RBAC role to ADLS gen 2 account
New-AzRoleAssignment -ObjectId $adfv2_id.Identity.PrincipalId -RoleDefinitionName "Reader" -Scope  "/subscriptions/$sub_id/resourceGroups/$rg/providers/Microsoft.Storage/storageAccounts/$adls/blobServices/default"
New-AzRoleAssignment -ObjectId $adfv2_id.Identity.PrincipalId -RoleDefinitionName "Storage Blob Data Contributor" -Scope  "/subscriptions/$sub_id/resourceGroups/$rg/providers/Microsoft.Storage/storageAccounts/$adls/blobServices/default/containers/sqldbdata"

# Turn on firewall
Update-AzStorageAccountNetworkRuleSet -ResourceGroupName $rg -Name $adls -DefaultAction Deny

# Set service endpoints for storage and SQL to subnet
Get-AzVirtualNetwork -ResourceGroupName $rg -Name $vnet | Set-AzVirtualNetworkSubnetConfig -Name "shir" -AddressPrefix "10.100.0.0/24" -ServiceEndpoint "Microsoft.Storage", "Microsoft.SQL" | Set-AzVirtualNetwork

# Add firewall rules
$subnet = Get-AzVirtualNetwork -ResourceGroupName $rg -Name $vnet | Get-AzVirtualNetworkSubnetConfig -Name "shir"
Add-AzStorageAccountNetworkRule -ResourceGroupName $rg -Name $adls -VirtualNetworkResourceId $subnet.Id