param ($resourceGroupName, $adlsName, $adlsPrivateLinkName, $vnetName, $location, $adlsSnet, $nonphiResourceGroupName, $isphi)
    $rg = ''
    if($isphi -eq $true){
        $rg = $resourceGroupName
    }else {
        $rg = $nonphiResourceGroupName
    }

    $StorageAccount = Get-AzStorageAccount -ResourceGroupName $rg -Name $adlsName 
    
    $privateEndpointConnectionForStorageAccount = New-AzPrivateLinkServiceConnection -Name $adlsPrivateLinkName `
    -PrivateLinkServiceId $StorageAccount.Id `
    -GroupId "file"
    
    $vnet = Get-AzVirtualNetwork -ResourceGroupName  $resourceGroupName -Name $vnetName  
     
    $subnet = $vnet `
    | Select -ExpandProperty Subnets `
    | Where-Object  {$_.Name -eq  $adlsSnet}

    Write-Host $subnet

    ## Disable private endpoint network policy ##
    $vnet.Subnets[0].PrivateEndpointNetworkPolicies = "Disabled"
    $vnet | Set-AzVirtualNetwork

     ## Create private endpoint
    $parameters2 = @{
        ResourceGroupName = $rg
        Name = $adlsPrivateLinkName
        Location = $location
        Subnet = $vnet.Subnets[0]
        PrivateLinkServiceConnection = $privateEndpointConnectionForStorageAccount
    }
    New-AzPrivateEndpoint @parameters2
    
    $zoneforStorageAccount = New-AzPrivateDnsZone -ResourceGroupName $rg `
    -Name "privatelink.dfs.core.windows.net" 
    
    $linkforStorageAccount  = New-AzPrivateDnsVirtualNetworkLink -ResourceGroupName $rg `
    -ZoneName "privatelink.dfs.core.windows.net"`
    -Name $adlsPrivateLinkName `
    -VirtualNetworkId $vnet.Id
    
    #$networkInterfaceforStorageAccount = Get-AzResource -ResourceId $privateEndpointForstorageaccount.NetworkInterfaces[0].Id -ApiVersion "2019-04-01" 
    
    # foreach ($ipconfig in $networkInterfaceforStorageAccount.properties.ipConfigurations) { 
    # foreach ($fqdn in $ipconfig.properties.privateLinkConnectionProperties.fqdns) { 
    #     Write-Host "$($ipconfig.properties.privateIPAddress) $($fqdn)"  
    #     $recordName = $fqdn.split('.',2)[0] 
    #     $dnsZone = $fqdn.split('.',2)[1] 
    #     New-AzPrivateDnsRecordSet -Name $recordName -RecordType A -ZoneName $zoneforStorageAccount  `
    #     -ResourceGroupName $resourceGroupName -Ttl 600 `
    #     -PrivateDnsRecords (New-AzPrivateDnsRecordConfig -IPv4Address $ipconfig.properties.privateIPAddress)  
    # } 
    # }