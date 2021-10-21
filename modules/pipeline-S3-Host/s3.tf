resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${lower(var.PROJECT_NAME)}-artifact/${lower(var.ENV)}-pipeline"
  acl           = "private"
  force_destroy = true
}