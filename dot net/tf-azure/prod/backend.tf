terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "vrittfstatefilesa"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}