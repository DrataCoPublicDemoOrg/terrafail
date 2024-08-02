

resource "azurerm_resource_group" "TerraFailWeb_rg" {
  name     = "TerraFailWeb_rg"
  location = "East US"
}

# ---------------------------------------------------------------------
# Web App
# ---------------------------------------------------------------------
resource "azurerm_linux_web_app" "TerraFailWeb_linux" {
  name                       = "TerraFailWeb_linux"
  resource_group_name        = azurerm_resource_group.TerraFailWeb_rg.name
  location                   = azurerm_resource_group.TerraFailWeb_rg.location
  service_plan_id            = azurerm_service_plan.TerraFailWeb_service_plan.id
  client_certificate_enabled = false
  client_certificate_mode    = "Optional"

  site_config {
    cors {
      allowed_origins = ["*"]
    }
    minimum_tls_version      = 1.2
    remote_debugging_enabled = true

    ip_restriction {
      action     = "Allow"
      ip_address = "0.0.0.0/0"
    # Drata: Ensure that [azurerm_linux_web_app.site_config.ip_restriction.ip_address] is explicitly defined and narrowly scoped to only allow trusted sources to access Web App
    }
  }
}

resource "azurerm_windows_web_app" "TerraFailWeb_windows" {
  name                       = "TerraFailWeb_windows"
  resource_group_name        = azurerm_resource_group.TerraFailWeb_rg.name
  location                   = azurerm_resource_group.TerraFailWeb_rg.location
  service_plan_id            = azurerm_service_plan.TerraFailWeb_service_plan.id
  client_certificate_enabled = false
  client_certificate_mode    = "Optional"

  site_config {
    cors {
      allowed_origins = ["*"]
    }
    minimum_tls_version      = 1.2
    remote_debugging_enabled = true
    ip_restriction {
      action     = "Allow"
      ip_address = "0.0.0.0/0"
    # Drata: Ensure that [azurerm_windows_web_app.site_config.ip_restriction.ip_address] is explicitly defined and narrowly scoped to only allow trusted sources to access Web App
    }
  }
}

# ---------------------------------------------------------------------
# Service Plan
# ---------------------------------------------------------------------
resource "azurerm_service_plan" "TerraFailWeb_service_plan" {
  name                = "TerraFailWeb_service_plan"
  resource_group_name = azurerm_resource_group.TerraFailWeb_rg.name
  location            = azurerm_resource_group.TerraFailWeb_rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}
