# Primary Table Outputs
output "table_name" {
  description = "The name of the DynamoDB table"
  value       = try(aws_dynamodb_table.table[0].name, null)
}

output "table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = try(aws_dynamodb_table.table[0].arn, null)
}

output "table_id" {
  description = "The ID of the DynamoDB table"
  value       = try(aws_dynamodb_table.table[0].id, null)
}

output "table_hash_key" {
  description = "The hash key of the DynamoDB table"
  value       = try(aws_dynamodb_table.table[0].hash_key, null)
}

output "table_range_key" {
  description = "The range key of the DynamoDB table"
  value       = try(aws_dynamodb_table.table[0].range_key, null)
}

output "table_billing_mode" {
  description = "The billing mode of the DynamoDB table"
  value       = try(aws_dynamodb_table.table[0].billing_mode, null)
}

output "table_stream_arn" {
  description = "The ARN of the Table Stream"
  value       = try(aws_dynamodb_table.table[0].stream_arn, null)
}

output "table_stream_label" {
  description = "A timestamp, in ISO 8601 format, for this stream"
  value       = try(aws_dynamodb_table.table[0].stream_label, null)
}

output "table_stream_view_type" {
  description = "The stream view type of the DynamoDB table"
  value       = try(aws_dynamodb_table.table[0].stream_view_type, null)
}

output "table_point_in_time_recovery" {
  description = "Point-in-time recovery settings"
  value       = try(aws_dynamodb_table.table[0].point_in_time_recovery, null)
}

output "table_ttl" {
  description = "TTL configuration"
  value       = try(aws_dynamodb_table.table[0].ttl, null)
}

output "table_global_secondary_indexes" {
  description = "Global Secondary Indexes configuration"
  value       = try(aws_dynamodb_table.table[0].global_secondary_index, null)
}

# Replica Table Outputs
output "replica_arn" {
  description = "The ARN of the replica table"
  value       = try(aws_dynamodb_table_replica.replica_table[0].arn, null)
}

output "replica_id" {
  description = "The ID of the replica table"
  value       = try(aws_dynamodb_table_replica.replica_table[0].id, null)
}

output "replica_global_table_arn" {
  description = "The ARN of the global table for the replica"
  value       = try(aws_dynamodb_table_replica.replica_table[0].global_table_arn, null)
}

# Convenience Outputs
output "table_exists" {
  description = "Whether the primary table exists"
  value       = length(aws_dynamodb_table.table) > 0
}

output "replica_exists" {
  description = "Whether the replica table exists"
  value       = length(aws_dynamodb_table_replica.replica_table) > 0
}

output "table_region" {
  description = "The AWS region where the table is located"
  value       = data.aws_region.current.name
} 