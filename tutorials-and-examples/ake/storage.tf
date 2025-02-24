#resource "azurerm_storage_account" "example" {
#  name                     = "examplestoraccount"
#  resource_group_name      = data.azurerm_resource_group.rg.name
#  location                 = data.azurerm_resource_group.rg.location
#  account_tier             = "Standard"
#  account_replication_type = "LRS"
#
#  tags = {
#    environment = "staging"
#  }
#}

#resource "azurerm_storage_container" "example" {
#  name                  = "vhds"
#  storage_account_id    = azurerm_storage_account.example.id
#  container_access_type = "private"
#}
