variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central India"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-monitoring-prod"
}

variable "vm_name" {
  description = "Monitoring VM name"
  type        = string
  default     = "vm-monitoring-prod"
}

variable "workspace_name" {
  description = "Log Analytics workspace"
  type        = string
  default     = "law-monitoring-prod"
}

variable "admin_username" {
  description = "Linux VM admin username"
  type        = string
  default     = "azureadmin"
}

variable "admin_source_cidr" {
  description = "Allowed SSH source CIDR"
  type        = string
  default     = "0.0.0.0/0"
}