# Create an s3 bucket
resource "aws_s3_bucket" "monitoring" {
  bucket = "${var.s3_bucket_name_for_monitoring}"
  acl    = "private"
  tags = {
    Name        = "Monitoring"
  }
}

resource "aws_s3_bucket_public_access_block" "monitoring" {
  bucket = aws_s3_bucket.monitoring.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets =  true
}
