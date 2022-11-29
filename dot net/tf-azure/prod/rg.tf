# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = var.rg_name
  location = var.rg_location
}


