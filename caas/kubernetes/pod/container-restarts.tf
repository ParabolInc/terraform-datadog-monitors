locals {
  containers_restart_group_by = join(", ", var.containers_restart_group_by)
}


variable "containers_restart_group_by" {
  default     = ["kube_deployment"]
  description = "Select group by element on monitors (phase status)"
}

variable "containers_restart_enabled" {
  description = "Flag to enable Containers restart monitor"
  type        = string
  default     = "true"
}

variable "containers_restart_extra_tags" {
  description = "Extra tags for Containers restart monitor"
  type        = list(string)
  default     = []
}

variable "containers_restart_message" {
  description = "Custom message for Containers restart monitor"
  type        = string
  default     = ""
}

variable "containers_restart_time_aggregator" {
  description = "Monitor aggregator for Containers restart [available values: min, max or avg]"
  type        = string
  default     = "max"
}

variable "containers_restart_timeframe" {
  description = "Monitor timeframe for Containers restart [available values: `last_#m` (1, 5, 10, 15, or 30), `last_#h` (1, 2, or 4), or `last_1d`]"
  type        = string
  default     = "last_1d"
}


resource "datadog_monitor" "containers_restart" {
  count   = var.containers_restart_enabled == "true" ? 1 : 0
  name    = "${var.prefix_slug == "" ? "" : "[${var.prefix_slug}]"}[${var.environment}] Kubernetes Container restarted"
  message = coalesce(var.containers_restart_message, var.message)
  type    = "metric alert"

  query = <<EOQ
    ${var.containers_restart_time_aggregator}(${var.containers_restart_timeframe}):
      default(max:kubernetes.containers.restarts${module.filter-tags-phase.query_alert} by {${local.containers_restart_group_by}}, 0) > 0
EOQ

  monitor_thresholds {
    critical = 0
  }

  evaluation_delay = var.evaluation_delay
  new_host_delay   = var.new_host_delay
  new_group_delay  = var.new_group_delay

  notify_no_data      = false
  renotify_interval   = 0
  notify_audit        = false
  timeout_h           = var.timeout_h
  include_tags        = true
  require_full_window = true

  tags = concat(local.common_tags, var.tags, var.containers_restart_extra_tags)
}
