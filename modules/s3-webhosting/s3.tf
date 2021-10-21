resource "aws_s3_bucket" "host" {
  bucket = "${lower(var.PROJECT_NAME)}-host/${lower(var.BUCKET_NAME_HOSTING)}"
  acl    = "public-read"
  versioning {
    enabled = true
  }
  force_destroy = true
  website {
    index_document = "index.html"
  }
}


resource "aws_s3_bucket_policy" "host" {
  bucket = aws_s3_bucket.host.id
  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PermissionForObjectOperations"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          "${aws_s3_bucket.host.arn}/*",
        ]
      },
    ]
  })
}