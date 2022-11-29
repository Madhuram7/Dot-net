param ($resourceGroupName, $sqlServerName, $privateEndpointName, $vnetName, $nonphiResourceGroupName, $isphi)
   Write-Host $resourceGroupName
   Write-Host $sqlServerName
   Write-Host $privateEndpointName
   Write-Host $vnetName

   $rg = ''
    if($isphi -eq $true){
        $rg = $resourceGroupName
    }else {
        $rg = $nonphiResourceGroupName
    }

    ## Place virtual network into variable. ##
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName

    $zone = Get-AzPrivateDnsZone -ResourceGroupName $resourceGroupName -Name 'privatelink.database.windows.net'

    ## Create private dns zone. ##
    $parameters1 = @{
        ResourceGroupName = $rg
        Name = 'privatelink.database.windows.net'
    }

    if($zone -eq $null){
        $zone = New-AzPrivateDnsZone @parameters1
    }
    
    ## Create dns network link. ##
    $parameters2 = @{
        ResourceGroupName = $rg
        Name = $privateEndpointName
        VirtualNetworkId = $vnet.Id
        ZoneName = $zone
    }
    $link = New-AzPrivateDnsVirtualNetworkLink @parameters2

    ## Create DNS configuration ##
    # $parameters3 = @{
    #     Name = 'privatelink.database.windows.net'
    #     PrivateDnsZoneId = $zone.ResourceId
    # }
    # $config = New-AzPrivateDnsZoneConfig @parameters3 -Force

    # ## Create DNS zone group. ##
    # $groupName = "sqlservergroup"
    # $parameters4 = @{
    #     ResourceGroupName = $resourceGroupName
    #     PrivateEndpointName = $privateEndpointName
    #     Name = $privateEndpointName + $groupName
    #     PrivateDnsZoneConfig = $config
    # }
    # New-AzPrivateDnsZoneGroup @parameters4