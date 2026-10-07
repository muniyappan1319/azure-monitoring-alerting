resource "azurerm_resource_group" "monitoring" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
    Owner       = "Cloud-Engineering"
    CostCenter  = "Learning"
  }
}