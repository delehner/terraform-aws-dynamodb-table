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
  default     = null
  nullable    = true
  description = "Table's Range Key. Set to null (or omit) to disable."
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

variable "enable_streams" {
  type        = bool
  default     = true
  description = "Enable DynamoDB Streams on the table."
}

variable "stream_view_type" {
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
  description = "Stream view type. One of KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
}

variable "enable_deletion_protection" {
  type        = bool
  default     = true
  description = "Enable deletion protection on the table."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the table. Note: lifecycle.ignore_changes = [tags] is set on the resource, so changes here are applied on create only."
}

variable "global_secondary_indexes" {
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = optional(string, "ALL")
    non_key_attributes = optional(list(string))
  }))
  default     = []
  description = "List of Global Secondary Index configurations. projection_type defaults to ALL; set to INCLUDE with non_key_attributes for narrower projections, or KEYS_ONLY for the smallest projection."
}
