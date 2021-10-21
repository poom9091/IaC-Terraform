resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${lower(var.PROJECT_NAME)}-artifact/${lower(var.CODEPIPELINE_NAME)}"
  acl           = "private"
  force_destroy = true
}