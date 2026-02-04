# Terraform - DynamoDB Table Module

This Terraform module provides all the necessary resources to create and manage a DynamoDB table with support for:
- Range keys (optional)
- Global Secondary Indexes (optional)
- TTL (Time To Live) configuration (optional)
- Point-in-time recovery
- DynamoDB Streams
- Table replication

## Usage

### Basic Table (Hash Key Only)

```hcl
module "basic_table" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 1"

  application_name = "my-app"
  table_name       = "users"
  environment      = "development"
  hash_key         = "user_id"
}
```

### Table with Range Key

```hcl
module "table_with_range_key" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 1"

  application_name = "my-app"
  table_name       = "orders"
  environment      = "development"
  hash_key         = "user_id"
  range_key        = "order_id"
}
```

### Table with Global Secondary Indexes

```hcl
module "table_with_gsi" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 1"

  application_name = "my-app"
  table_name       = "products"
  environment      = "development"
  hash_key         = "product_id"
  range_key        = "category"

  global_secondary_indexes = [
    {
      name      = "category_price_index"
      hash_key  = "category"
      range_key = "price"
    },
    {
      name      = "status_index"
      hash_key  = "status"
      # range_key is optional
    }
  ]
}
```

### Table with TTL

```hcl
module "table_with_ttl" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 1"

  application_name = "my-app"
  table_name       = "sessions"
  environment      = "development"
  hash_key         = "session_id"
  ttl_column       = "expires_at"
}
```

### Replica Table

```hcl
module "replica_table" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 1"

  replica          = true
  global_table_arn = module.primary_table.table_arn
}
```

## Outputs

### Primary Table Outputs
- `table_name` - The name of the DynamoDB table
- `table_arn` - The ARN of the DynamoDB table
- `table_id` - The ID of the DynamoDB table
- `table_hash_key` - The hash key of the DynamoDB table
- `table_range_key` - The range key of the DynamoDB table
- `table_billing_mode` - The billing mode of the DynamoDB table
- `table_stream_arn` - The ARN of the Table Stream
- `table_stream_label` - A timestamp, in ISO 8601 format, for this stream
- `table_stream_view_type` - The stream view type of the DynamoDB table
- `table_point_in_time_recovery` - Point-in-time recovery settings
- `table_ttl` - TTL configuration
- `table_global_secondary_indexes` - Global Secondary Indexes configuration

### Replica Table Outputs
- `replica_arn` - The ARN of the replica table
- `replica_id` - The ID of the replica table
- `replica_global_table_arn` - The ARN of the global table for the replica

### Convenience Outputs
- `table_exists` - Whether the primary table exists (boolean)
- `replica_exists` - Whether the replica table exists (boolean)
- `table_region` - The AWS region where the table is located
