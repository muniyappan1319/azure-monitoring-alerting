output "resource_group_name" {
  value = azurerm_resource_group.monitoring.name
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.monitoring.name
}

output "vm_public_ip" {
  value = azurerm_public_ip.monitoring.ip_address
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.monitoring.id
}

output "dcr_id" {
  value = azurerm_monitor_data_collection_rule.monitoring.id
}

output "action_group_id" {
  value = azurerm_monitor_action_group.monitoring.id
}

output "logic_app_name" {
  value = azurerm_logic_app_workflow.monitoring.name
}

output "logic_app_trigger_callback_url" {
  value     = azurerm_logic_app_trigger_http_request.monitoring.callback_url
  sensitive = true
}