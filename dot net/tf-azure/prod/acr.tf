resource "azurerm_container_registry" "acr1" {
  name                     = var.acr_name
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  sku                      = var.acr_sku
  admin_enabled            = true
}



