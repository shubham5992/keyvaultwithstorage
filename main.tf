resource "azurerm_resource_group" "resourcest" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sto" {
  name                     = var.storageaccountname
  resource_group_name      = azurerm_resource_group.resourcest.name
  location                 = var.location
  account_tier             =var.account_tier
  account_replication_type = var.account_replication_type

  depends_on = [ azurerm_resource_group.resourcest ]
}

resource "azurerm_storage_container" "storagecont" {
  name                  = "stcontainer"
  storage_account_name  = azurerm_storage_account.sto.name
  container_access_type = "private"

  depends_on = [ azurerm_storage_account.sto ]
}


resource "azurerm_key_vault" "example" {
  name                        = var.azurerm_key_vault
  location                    = var.location
  resource_group_name         = azurerm_resource_group.resourcest.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}


data "azurerm_client_config" "current" {
  # Add your configuration details here
}
