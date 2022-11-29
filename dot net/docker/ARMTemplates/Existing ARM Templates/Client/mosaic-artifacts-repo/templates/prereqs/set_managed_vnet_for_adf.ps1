param($resourceGroupName, $datafactoryName)
    Write-Host $resourceGroupName
    Write-Host $datafactoryName

    $datafactory = Get-AzDataFactoryV2IntegrationRuntime -ResourceGroupName $resourceGroupName -DataFactoryName 'test-df-eu2' -Name 'AutoResolveIntegrationRuntime'

    # Set-AzDataFactoryV2IntegrationRuntime -ResourceGroupName 'rg-test-dfv2' -DataFactoryName 'test-df-eu2' -Name 'AutoResolveIntegrationRuntime' `
    #                                         -Description 'New description' -Type 'Managed'

    $datafactory | Set-AzDataFactoryV2IntegrationRuntime