data "aws_region" "current" {}

resource "aws_dynamodb_table" "table" {
  count = var.replica ? 0 : 1

  name                        = "${var.application_name}.${var.table_name}.${var.environment}"
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  billing_mode                = var.billing_mode
  stream_enabled              = var.enable_streams
  stream_view_type            = var.enable_streams ? var.stream_view_type : null
  deletion_protection_enabled = var.enable_deletion_protection
  tags                        = var.tags

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  attribute {
    name = var.hash_key
    type = "S"
  }

  dynamic "attribute" {
    for_each = var.range_key != null ? [var.range_key] : []
    content {
      name = attribute.value
      type = "S"
    }
  }

  dynamic "attribute" {
    for_each = toset([for gsi in var.global_secondary_indexes : gsi.hash_key])
    content {
      name = attribute.value
      type = "S"
    }
  }

  dynamic "attribute" {
    for_each = toset([for gsi in var.global_secondary_indexes : gsi.range_key if gsi.range_key != null])
    content {
      name = attribute.value
      type = "S"
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.projection_type == "INCLUDE" ? global_secondary_index.value.non_key_attributes : null
    }
  }

  dynamic "ttl" {
    for_each = var.ttl_column != "" ? [var.ttl_column] : []
    content {
      attribute_name = ttl.value
      enabled        = true
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_dynamodb_table_replica" "replica_table" {
  count = var.replica ? 1 : 0

  global_table_arn = var.global_table_arn
  tags             = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
