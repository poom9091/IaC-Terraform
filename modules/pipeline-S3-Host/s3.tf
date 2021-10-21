resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = "${lower(var.PROJECT_NAME)}-arti/${lower(var.ENV)}"
  acl           = "private"
  force_destroy = true
}