resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = var.workspace_name
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
  }
}

resource "azurerm_virtual_machine_extension" "ama" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.monitoring.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
  }
}

resource "azurerm_monitor_data_collection_rule" "monitoring" {
  name                = "dcr-monitoring-prod"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  kind                = "Linux"

  destinations {
    log_analytics {
      name                  = "logAnalyticsDestination"
      workspace_resource_id = azurerm_log_analytics_workspace.monitoring.id
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf", "Microsoft-Syslog"]
    destinations = ["logAnalyticsDestination"]
  }

  data_sources {
    performance_counter {
      name                          = "linux-performance-counters"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60

      counter_specifiers = [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Available MBytes",
        "\\LogicalDisk(_Total)\\% Free Space"
      ]
    }

    syslog {
      name = "linux-syslog"

      facility_names = [
        "auth",
        "authpriv",
        "cron",
        "daemon",
        "kern",
        "syslog",
        "user"
      ]

      log_levels = [
        "Debug",
        "Info",
        "Notice",
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency"
      ]

      streams = ["Microsoft-Syslog"]
    }
  }

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
  }
}

resource "azurerm_monitor_data_collection_rule_association" "monitoring" {
  name                    = "dcra-monitoring-prod"
  target_resource_id      = azurerm_linux_virtual_machine.monitoring.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.monitoring.id

  description = "Associates monitoring DCR with Linux monitoring VM"
}