#
# CPU Utilization
#
resource "datadog_monitor" "cpu_utilization" {
  name    = "[${var.environment}] Cloud SQL CPU Utilization {{#is_alert}}{{{comparator}}} {{threshold}}% ({{value}}%){{/is_alert}}{{#is_warning}}{{{comparator}}} {{warn_threshold}}% ({{value}}%){{/is_warning}}"
  message = "${coalesce(var.cpu_utilization_message, var.message)}"

  type = "metric alert"

  query = <<EOF
  ${var.cpu_utilization_time_aggregator}(${var.cpu_utilization_timeframe}):
    avg:gcp.cloudsql.database.cpu.utilization{${var.filter_tags}}
    by {database_id} * 100
  > ${var.cpu_utilization_threshold_critical}
EOF

  thresholds {
    warning  = "${var.cpu_utilization_threshold_warning}"
    critical = "${var.cpu_utilization_threshold_critical}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = true
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.cpu_utilization_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:cloud-sql", "team:claranet", "created-by:terraform", "${var.cpu_utilization_extra_tags}"]
}

#
# Disk Utilization
#
resource "datadog_monitor" "disk_utilization" {
  name    = "[${var.environment}] Cloud SQL Disk Utilization {{#is_alert}}{{{comparator}}} {{threshold}}% ({{value}}%){{/is_alert}}{{#is_warning}}{{{comparator}}} {{warn_threshold}}% ({{value}}%){{/is_warning}}"
  message = "${coalesce(var.disk_utilization_message, var.message)}"

  type = "metric alert"

  query = <<EOF
  ${var.disk_utilization_time_aggregator}(${var.disk_utilization_timeframe}):
    avg:gcp.cloudsql.database.disk.utilization{${var.filter_tags}}
    by {database_id} * 100
    > ${var.disk_utilization_threshold_critical}
EOF

  thresholds {
    warning  = "${var.disk_utilization_threshold_warning}"
    critical = "${var.disk_utilization_threshold_critical}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = true
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.disk_utilization_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:cloud-sql", "team:claranet", "created-by:terraform", "${var.disk_utilization_extra_tags}"]
}

#
# Disk Utilization Forecast
#
resource "datadog_monitor" "disk_utilization_forecast" {
  name    = "[${var.environment}] Cloud SQL Disk Utilization could reach {{#is_alert}}{{threshold}}%{{/is_alert}} in a near future"
  message = "${coalesce(var.disk_utilization_forecast_message, var.message)}"

  type = "metric alert"

  query = <<EOF
  ${var.disk_utilization_forecast_time_aggregator}(${var.disk_utilization_forecast_timeframe}):
    forecast(
      avg:gcp.cloudsql.database.disk.utilization{${var.filter_tags}} by {database_id} * 100,
      '${var.disk_utilization_forecast_algorithm}',
      ${var.disk_utilization_forecast_deviations},
      interval='${var.disk_utilization_forecast_interval}',
      ${var.disk_utilization_forecast_algorithm == "linear" ? format("history='%s',model='%s'", var.disk_utilization_forecast_linear_history, var.disk_utilization_forecast_linear_model): ""}
      ${var.disk_utilization_forecast_algorithm == "seasonal" ? format("seasonality='%s'", var.disk_utilization_forecast_seasonal_seasonality): ""}
    )
  >= ${var.disk_utilization_forecast_threshold_critical}
EOF

  thresholds {
    critical          = "${var.disk_utilization_forecast_threshold_critical}"
    critical_recovery = "${var.disk_utilization_forecast_threshold_critical_recovery}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.disk_utilization_forecast_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:cloud-sql", "team:claranet", "created-by:terraform", "${var.disk_utilization_forecast_extra_tags}"]
}

#
# Memory Utilization
#
resource "datadog_monitor" "memory_utilization" {
  name    = "[${var.environment}] Cloud SQL Memory Utilization {{#is_alert}}{{{comparator}}} {{threshold}}% ({{value}}%){{/is_alert}}{{#is_warning}}{{{comparator}}} {{warn_threshold}}% ({{value}}%){{/is_warning}}"
  message = "${coalesce(var.memory_utilization_message, var.message)}"

  type = "metric alert"

  query = <<EOF
  ${var.memory_utilization_time_aggregator}(${var.memory_utilization_timeframe}):
    avg:gcp.cloudsql.database.memory.utilization{${var.filter_tags}}
    by {database_id} * 100
  > ${var.memory_utilization_threshold_critical}
EOF

  thresholds {
    warning  = "${var.memory_utilization_threshold_warning}"
    critical = "${var.memory_utilization_threshold_critical}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = true
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.memory_utilization_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:cloud-sql", "team:claranet", "created-by:terraform", "${var.memory_utilization_extra_tags}"]
}

#
# Memory Utilization Forecast
#
resource "datadog_monitor" "memory_utilization_forecast" {
  name    = "[${var.environment}] Cloud SQL Memory Utilization could reach {{#is_alert}}{{threshold}}%{{/is_alert}} in a near future"
  message = "${coalesce(var.memory_utilization_forecast_message, var.message)}"

  type = "query alert"

  query = <<EOF
  ${var.memory_utilization_forecast_time_aggregator}(${var.memory_utilization_forecast_timeframe}):
    forecast(
      avg:gcp.cloudsql.database.memory.utilization{${var.filter_tags}} by {database_id} * 100,
      '${var.memory_utilization_forecast_algorithm}',
      ${var.memory_utilization_forecast_deviations},
      interval='${var.memory_utilization_forecast_interval}',
      ${var.memory_utilization_forecast_algorithm == "linear" ? format("history='%s',model='%s'", var.memory_utilization_forecast_linear_history, var.memory_utilization_forecast_linear_model): ""}
      ${var.memory_utilization_forecast_algorithm == "seasonal" ? format("seasonality='%s'", var.memory_utilization_forecast_seasonal_seasonality): ""}
      )
    >= ${var.memory_utilization_forecast_threshold_critical}
EOF

  thresholds {
    critical          = "${var.memory_utilization_forecast_threshold_critical}"
    critical_recovery = "${var.memory_utilization_forecast_threshold_critical_recovery}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = false
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.memory_utilization_forecast_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:cloud-sql", "team:claranet", "created-by:terraform", "${var.memory_utilization_forecast_extra_tags}"]
}

#
# Failover Unavailable
#
resource "datadog_monitor" "failover_unavailable" {
  name    = "[${var.environment}] Cloud SQL Failover Unavailable"
  message = "${coalesce(var.failover_unavailable_message, var.message)}"

  type = "metric alert"

  query = <<EOF
  ${var.failover_unavailable_time_aggregator}(${var.failover_unavailable_timeframe}):
    avg:gcp.cloudsql.database.available_for_failover{${var.filter_tags}}
    by {database_id}
  <= ${var.failover_unavailable_threshold_critical}
EOF

  thresholds {
    critical = "${var.failover_unavailable_threshold_critical}"
  }

  notify_audit        = false
  locked              = false
  timeout_h           = 0
  include_tags        = true
  require_full_window = false
  notify_no_data      = true
  renotify_interval   = 0

  evaluation_delay = "${var.evaluation_delay}"
  new_host_delay   = "${var.new_host_delay}"

  silenced = "${var.failover_unavailable_silenced}"

  tags = ["env:${var.environment}", "type:cloud", "provider:gcp", "resource:cloud-sql", "team:claranet", "created-by:terraform", "${var.failover_unavailable_extra_tags}"]
}