param ($resourceGroupName, $sqlServerName, $privateEndpointName, $privateEndpointConnectionName, $vnetName, $location, $sqlSnet, $nonphiResourceGroupName, $isphi)
   Write-Host $resourceGroupName
   Write-Host $sqlServerName
   Write-Host $privateEndpointName
   Write-Host $privateEndpointConnectionName
   Write-Host $vnetName
   Write-Host $location

    $rg = ''
    if($isphi -eq $true){
        $rg = $resourceGroupName
    }else {
        $rg = $nonphiResourceGroupName
    }


   ## Place SQL server into variable. Replace <sql-server-name> with your server name ##
    $server = Get-AzSqlServer -ResourceGroupName $rg -ServerName $sqlServerName

    ## Create private endpoint connection. ##
    $parameters1 = @{
        Name = $privateEndpointConnectionName
        PrivateLinkServiceId = $server.ResourceID
        GroupID = 'sqlserver'
    }
    $privateEndpointConnection = New-AzPrivateLinkServiceConnection @parameters1

    ## Place virtual network into variable. ##
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName

    $subnet = $vnet `
    | Select -ExpandProperty Subnets `
    | Where-Object  {$_.Name -eq $sqlSnet}

    Write-Host $subnet

    ## Disable private endpoint network policy ##
    $vnet.Subnets[0].PrivateEndpointNetworkPolicies = "Disabled"
    $vnet | Set-AzVirtualNetwork

    ## Create private endpoint
    $parameters2 = @{
        ResourceGroupName = $rg
        Name = $privateEndpointName
        Location = $location
        Subnet = $vnet.Subnets[0]
        PrivateLinkServiceConnection = $privateEndpointConnection
    }
    New-AzPrivateEndpoint @parameters2