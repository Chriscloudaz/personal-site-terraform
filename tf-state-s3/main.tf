variable "prefix" {
  type        = string
  description = "Prefix for file names."
  default     = "parbsol"
}

locals {
  table_name  = format("%s-%s", var.prefix, "table")
  bucket_name = format("%s-%s", var.prefix, "tf-state-bucket")
}

resource "aws_s3_bucket" "parbtech" {
  bucket = local.bucket_name

  tags = {
    Name    = local.bucket_name
    Project = "Personal-Site"
  }
}

resource "aws_s3_bucket_public_access_block" "parbtech" {
  bucket = aws_s3_bucket.parbtech.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "parbtech" {

  hash_key         = "LockID"
  name             = local.table_name
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  read_capacity    = 5
  write_capacity   = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}