resource "aws_codepipeline" "codepipeline" {
  name     = var.CODEPIPELINE_NAME
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
    encryption_key {
      id   = data.aws_kms_alias.s3.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = var.REPO_IP
        BranchName       = var.BRANCH_NAME
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild.id
      }
    }
  }
}
data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}


resource "aws_iam_role" "codepipeline_role" {
  name = "Codepipeline_role_${var.CODEPIPELINE_NAME}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "Codepipeline_policy_${var.CODEPIPELINE_NAME}"
  role   = aws_iam_role.codepipeline_role.name
  policy = data.aws_iam_policy_document.policy-pipeline.json
}


data "aws_iam_policy_document" "policy-pipeline" {
  statement {
    actions = ["s3:Get*", "s3:Put*"]
    resources = [
      "${aws_s3_bucket.codepipeline_bucket.arn}",
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"
    ]
  }

  statement {
    actions = ["codestar-connections:UseConnection"]
    resources = [
      "${aws_codestarconnections_connection.example.arn}"
    ]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = [
      "*"
    ]
  }
}