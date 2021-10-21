resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = lower(var.CODEPIPELINE_NAME)
  acl           = "private"
  force_destroy = true
}