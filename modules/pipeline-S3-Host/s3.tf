resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${lower(var.PROJECT_NAME)}-artifact"
  bucket_prefix = "${lower(var.ENV)}-pipeline"
  acl           = "private"
  force_destroy = true
}