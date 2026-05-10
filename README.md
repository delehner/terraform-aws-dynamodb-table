# Terraform - DynamoDB Table Module

This Terraform module provides all the necessary resources to create and manage a DynamoDB table with support for:
- Range keys (optional)
- Global Secondary Indexes (optional, with configurable projection)
- TTL (Time To Live) configuration (optional)
- Point-in-time recovery
- DynamoDB Streams (toggleable)
- Deletion protection (toggleable)
- Caller-supplied tags
- Table replication

The table is named `<application_name>.<table_name>.<environment>`.

## Recommended pattern: single-table design

The module is designed to be wrapped per-monorepo so every workload picks up
the same defaults (naming, PITR, streams, deletion protection). For
canonical wrapper examples, see:

- [`Swrming/platform-monorepo` → `iac/modules/dynamodb-table`](https://github.com/Swrming/platform-monorepo/tree/main/iac/modules/dynamodb-table)
- [`Swrming/website-monorepo` → `iac/modules/dynamodb-table`](https://github.com/Swrming/website-monorepo/tree/main/iac/modules/dynamodb-table)

Both wrappers use a single-table design (`hash_key = "pk"`,
`range_key = "sk"`, optional `ttl_column = "ttl"`) and add GSIs only when a
new access pattern can't be served by the base table.

## Usage

### Basic Table (Hash Key Only)

```hcl
module "basic_table" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 0.1"

  application_name = "my-app"
  table_name       = "users"
  environment      = "development"
  hash_key         = "user_id"
}
```

### Single-table design with TTL

```hcl
module "main_table" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 0.1"

  application_name = "my-app"
  table_name       = "main"
  environment      = "development"
  hash_key         = "pk"
  range_key        = "sk"
  ttl_column       = "ttl"
}
```

### Table with Global Secondary Indexes

```hcl
module "table_with_gsi" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 0.1"

  application_name = "my-app"
  table_name       = "main"
  environment      = "development"
  hash_key         = "pk"
  range_key        = "sk"

  global_secondary_indexes = [
    # Default: projection_type = "ALL" — best for dashboard-style
    # list/find access patterns that need full items.
    {
      name      = "gsi_user_id"
      hash_key  = "gsi1pk"
      range_key = "gsi1sk"
    },

    # Narrow projection to save storage / write cost.
    {
      name               = "status_index"
      hash_key           = "status"
      projection_type    = "INCLUDE"
      non_key_attributes = ["updated_at"]
    },

    # Smallest projection — index returns only the GSI keys plus the
    # base table's primary key.
    {
      name            = "status_keys_only"
      hash_key        = "status"
      projection_type = "KEYS_ONLY"
    },
  ]
}
```

#### GSI projection options

| `projection_type` | What's projected                                                                  | When to use                                                       |
| ----------------- | --------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `ALL` (default)   | Every attribute on the item                                                       | Dashboard list/find/revoke flows that need the full item          |
| `INCLUDE`         | GSI keys + base table's primary key + the attributes in `non_key_attributes`      | Read a small, fixed projection — saves storage and write throughput |
| `KEYS_ONLY`       | GSI keys + base table's primary key                                               | Existence checks; you'll fetch the full item from the base table   |

DynamoDB always projects the table's primary key into every GSI — you
don't need to list it in `non_key_attributes`.

### Table without streams or deletion protection

```hcl
module "ephemeral_table" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 0.1"

  application_name           = "my-app"
  table_name                 = "scratch"
  environment                = "development"
  hash_key                   = "pk"
  enable_streams             = false
  enable_deletion_protection = false
}
```

### Replica Table

```hcl
module "replica_table" {
  source  = "app.terraform.io/<organization>/dynamodb-table/aws"
  version = "~> 0.1"

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
- `table_stream_arn` - The ARN of the Table Stream (null when streams are disabled)
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

## Migrating from `0.0.x` to `0.1.0`

- **`range_key = ""` no longer means "no range key".** Use `null` (or omit
  the argument). Callers that pass a typed `string` variable through to
  the module — including the wrapper modules linked above — are not
  affected.
- **GSI `projection_type` default changed from `INCLUDE` (with
  `non_key_attributes = [<table hash key>, <table range key>]`) to
  `ALL`.** Terraform will plan a GSI recreation on the next apply.
  To preserve the old behavior verbatim, set per-GSI:

  ```hcl
  projection_type    = "INCLUDE"
  non_key_attributes = ["<table hash key>", "<table range key>"]
  ```
