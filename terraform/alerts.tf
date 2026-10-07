resource "azurerm_monitor_action_group" "monitoring" {
  name                = "ag-monitoring-prod"
  resource_group_name = azurerm_resource_group.monitoring.name
  short_name          = "monitoring"
  enabled             = true

  logic_app_receiver {
    name                    = "logicapp-email"
    resource_id             = azurerm_logic_app_workflow.monitoring.id
    callback_url            = azurerm_logic_app_trigger_http_request.monitoring.callback_url
    use_common_alert_schema = true
  }

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "high_cpu" {
  name                = "alert-high-cpu-prod"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location

  display_name = "High CPU - Monitoring VM"

  description = "Triggers when average CPU utilization is above 80 percent."

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"

  scopes = [
    azurerm_log_analytics_workspace.monitoring.id
  ]

  severity = 2

  criteria {
    query = <<-QUERY
      Perf
      | where ObjectName == "Processor"
      | where CounterName == "% Processor Time"
      | summarize CPUAverage = avg(CounterValue)
        by bin(TimeGenerated, 5m), Computer
    QUERY

    time_aggregation_method = "Average"
    metric_measure_column   = "CPUAverage"
    operator                = "GreaterThan"
    threshold               = 80

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [
      azurerm_monitor_action_group.monitoring.id
    ]

    custom_properties = {
      AlertType   = "High CPU"
      Severity    = "2"
      Environment = "Prod"
    }
  }

  auto_mitigation_enabled = true

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
  }
}