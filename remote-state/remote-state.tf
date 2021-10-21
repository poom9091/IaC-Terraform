provider "aws"{
    region     = var.AWS_REGION
}

resource "aws_dynamodb_table" "terraform_lock" {
    name           = lower(local.DynamoDB_REMOTE)
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }
}

resource "aws_s3_bucket" "bucket_backend" {
    bucket = lower(local.S3_REMOTE)
    versioning {
        enabled = true
    }
    object_lock_configuration {
        object_lock_enabled = "Enabled"
    }
}

output "dynamodb_remote_state_name" {
  value = aws_dynamodb_table.terraform_lock.name
}

output "S3_remote_state_name" {
  value = aws_s3_bucket.bucket_backend.bucket
}

output "s3_region" {
    value = var.AWS_REGION
}
