# Configure AAD access to logical SQL server
Connect-AzureAD

$aaduser = "eus2-mosaic-dev-adf"
Set-AzSqlServerActiveDirectoryAdministrator -ResourceGroupName $rg -ServerName $sqlserver -DisplayName $aaduser

# log in SQL with AAD (e.g. via portal query editor, SSMS or VSC)
# Execute following SQL statement
#CREATE USER $aaduser FROM EXTERNAL PROVIDER;
#EXEC sp_addrolemember [db_owner], $aaduser;

# Add firewall rules
$vnet = 'eus2-mosaic-dev-shirvnet'
$subnet = Get-AzVirtualNetwork -ResourceGroupName $rg -Name $vnet | Get-AzVirtualNetworkSubnetConfig -Name "shir"
New-AzSqlServerVirtualNetworkRule -ResourceGroupName $rg -ServerName $sqlserver -VirtualNetworkRuleName "shirvnet" -VirtualNetworkSubnetId $subnet.Id