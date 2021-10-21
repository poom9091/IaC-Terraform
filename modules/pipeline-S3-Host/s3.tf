resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = "${lower(var.ENV)}-${lower(var.PROJECT_NAME)}-pipeline"
  acl           = "private"
  force_destroy = true
}