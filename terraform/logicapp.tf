resource "azurerm_logic_app_workflow" "monitoring" {
  name                = "logic-monitoring-prod"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
    Role        = "Alert-Notification"
  }
}

resource "azurerm_logic_app_trigger_http_request" "monitoring" {
  name         = "monitoring-alert-trigger"
  logic_app_id = azurerm_logic_app_workflow.monitoring.id

  method = "POST"

  schema = <<SCHEMA
{
  "type": "object",
  "properties": {}
}
SCHEMA
}