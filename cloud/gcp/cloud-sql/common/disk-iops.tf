
#
# Read IOPS
#
resource "datadog_monitor" "read_iops_limit" {
  count   = var.read_iops_limit_enabled == "true" ? 1 : 0
  name    = "${var.prefix_slug == "" ? "" : "[${var.prefix_slug}]"}[${var.environment}] Cloud SQL Read IOPS limit {{#is_alert}}{{{comparator}}} {{threshold}}% ({{value}}%){{/is_alert}}{{#is_warning}}{{{comparator}}} {{warn_threshold}}% ({{value}}%){{/is_warning}}"
  message = coalesce(var.read_iops_limit_message, var.message)
  type    = "query alert"

  query = <<EOQ
    ${var.read_iops_limit_time_aggregator}(${var.read_iops_limit_timeframe}):
      avg:gcp.cloudsql.database.disk.write_ops_count{${var.filter_tags}} by {database_id}.as_rate() * 100 
      /
      (
        avg:gcp.cloudsql.database.disk.quota{${var.filter_tags}} by {database_id}
        / (1024*1024*1024) * 30
      )
    > ${var.read_iops_limit_threshold_critical}
EOQ

  monitor_thresholds {
    warning  = var.read_iops_limit_threshold_warning
    critical = var.read_iops_limit_threshold_critical
  }

  evaluation_delay    = var.evaluation_delay
  new_group_delay     = var.new_group_delay
  notify_audit        = false
  timeout_h           = var.timeout_h
  include_tags        = true
  require_full_window = false
  notify_no_data      = var.notify_no_data
  no_data_timeframe   = var.read_iops_limit_no_data_timeframe
  renotify_interval   = 0

  tags = concat(["env:${var.environment}", "type:cloud", "provider:gcp", "resource:cloud-sql", "team:claranet", "created-by:terraform"], var.read_iops_limit_extra_tags)
}

#
# Read IOPS
#

variable "read_iops_limit_message" {
  description = "Custom message for the Read IOPS monitor"
  type        = string
  default     = ""
}

variable "read_iops_limit_time_aggregator" {
  description = "Time aggregator for the Read IOPS monitor"
  type        = string
  default     = "avg"
}

variable "read_iops_limit_timeframe" {
  description = "Timeframe for the Read IOPS monitor"
  type        = string
  default     = "last_5m"
}

variable "read_iops_limit_threshold_warning" {
  description = "Read IOPS in percentage (warning threshold)"
  type        = string
  default     = 85
}

variable "read_iops_limit_threshold_critical" {
  description = "Read IOPS in percentage (critical threshold)"
  type        = string
  default     = 95
}

variable "read_iops_limit_enabled" {
  description = "Flag to enable GCP Cloud SQL Read IOPS monitor"
  type        = string
  default     = "true"
}

variable "read_iops_limit_extra_tags" {
  description = "Extra tags for GCP Cloud SQL CPU Utilization monitor"
  type        = list(string)
  default     = []
}

variable "read_iops_limit_no_data_timeframe" {
  description = "Number of minutes before reporting no data"
  type        = string
  default     = 10
}

#
# Write IOPS
#
resource "datadog_monitor" "write_iops_limit" {
  count   = var.write_iops_limit_enabled == "true" ? 1 : 0
  name    = "${var.prefix_slug == "" ? "" : "[${var.prefix_slug}]"}[${var.environment}] Cloud SQL Write IOPS limit {{#is_alert}}{{{comparator}}} {{threshold}}% ({{value}}%){{/is_alert}}{{#is_warning}}{{{comparator}}} {{warn_threshold}}% ({{value}}%){{/is_warning}}"
  message = coalesce(var.write_iops_limit_message, var.message)
  type    = "query alert"

  query = <<EOQ
    ${var.write_iops_limit_time_aggregator}(${var.write_iops_limit_timeframe}):
      avg:gcp.cloudsql.database.disk.read_ops_count{${var.filter_tags}} by {database_id}.as_rate() * 100 
      /
      (
        avg:gcp.cloudsql.database.disk.quota{${var.filter_tags}} by {database_id}
        / (1024*1024*1024) * 30
      )
    > ${var.write_iops_limit_threshold_critical}
EOQ

  monitor_thresholds {
    warning  = var.write_iops_limit_threshold_warning
    critical = var.write_iops_limit_threshold_critical
  }

  evaluation_delay    = var.evaluation_delay
  new_group_delay     = var.new_group_delay
  notify_audit        = false
  timeout_h           = var.timeout_h
  include_tags        = true
  require_full_window = false
  notify_no_data      = var.notify_no_data
  no_data_timeframe   = var.write_iops_limit_no_data_timeframe
  renotify_interval   = 0

  tags = concat(["env:${var.environment}", "type:cloud", "provider:gcp", "resource:cloud-sql", "team:claranet", "created-by:terraform"], var.write_iops_limit_extra_tags)
}

#
# Write IOPS
#

variable "write_iops_limit_message" {
  description = "Custom message for the Read IOPS monitor"
  type        = string
  default     = ""
}

variable "write_iops_limit_time_aggregator" {
  description = "Time aggregator for the Read IOPS monitor"
  type        = string
  default     = "avg"
}

variable "write_iops_limit_timeframe" {
  description = "Timeframe for the Read IOPS monitor"
  type        = string
  default     = "last_5m"
}

variable "write_iops_limit_threshold_warning" {
  description = "Read IOPS in percentage (warning threshold)"
  type        = string
  default     = 85
}

variable "write_iops_limit_threshold_critical" {
  description = "Read IOPS in percentage (critical threshold)"
  type        = string
  default     = 95
}

variable "write_iops_limit_enabled" {
  description = "Flag to enable GCP Cloud SQL Read IOPS monitor"
  type        = string
  default     = "true"
}

variable "write_iops_limit_extra_tags" {
  description = "Extra tags for GCP Cloud SQL CPU Utilization monitor"
  type        = list(string)
  default     = []
}

variable "write_iops_limit_no_data_timeframe" {
  description = "Number of minutes before reporting no data"
  type        = string
  default     = 10
}
