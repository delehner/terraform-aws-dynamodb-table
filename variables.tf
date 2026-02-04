variable "application_name" {
  type        = string
  description = "Application's name."
}

variable "environment" {
  type        = string
  description = "Environment where the resource is running."
}

variable "table_name" {
  type        = string
  description = "Table's name."
}

variable "hash_key" {
  type        = string
  default     = "uuid"
  description = "Table's Hash Key."
}

variable "range_key" {
  type        = string
  default     = ""
  description = "Table's Range Key."
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "Table's billing mode."
}

variable "replica" {
  type        = bool
  default     = false
  description = "Set to true when the table is a replica."
}

variable "ttl_column" {
  type        = string
  default     = ""
  description = "TTL column."
}

variable "global_table_arn" {
  type        = string
  default     = ""
  description = "Set global table ARN when replica is set to true."
}

variable "enable_point_in_time_recovery" {
  type        = bool
  default     = true
  description = "Enable point in time recovery."
}

variable "global_secondary_indexes" {
  type = list(object({
    name      = string
    hash_key  = string
    range_key = optional(string)
  }))
  default     = []
  description = "List of Global Secondary Index configurations. Each object should contain name, hash_key, and optionally range_key."
}