resource "aws_codebuild_project" "codebuild" {
  name         = var.SET_POLICY == "web_pipeline"? "${var.ENV}-${var.PROJECT_NAME}-codebuild" : "${var.ENV}-${var.PROJECT_NAME}-gitops-pipeline"
  service_role = aws_iam_role.RoleCodebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"

    dynamic "environment_variable" {
      for_each = local.ENV_VARIABLE
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }

    dynamic "environment_variable" {
      for_each = var.ADDED_ENV
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

  source {
    type = "CODEPIPELINE"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group-${var.PROJECT_NAME}"
      stream_name = "log-stream-${var.PROJECT_NAME}"
    }
  }

}

resource "aws_iam_role" "RoleCodebuild" {
  name = "Codebuild_role_${var.CODEPIPELINE_NAME}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "Codebuild_role_policy" {
  name   = "Codebuild_${var.CODEPIPELINE_NAME}"
  role   = aws_iam_role.RoleCodebuild.name
  policy = var.SET_POLICY == "web_pipeline" ? data.aws_iam_policy_document.codebuild_policy.json : data.aws_iam_policy_document.gitops_policy.json
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    actions   = ["dynamodb:*"]
    resources = ["*"]
  }
  statement {
    actions   = ["kms:*"]
    resources = ["*"]
  }
  statement {
    actions = [
      "dynamodb:*"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/*"]
  }
  statement {
    actions = [
      "dynamodb:*"
    ] 
    resources = ["arn:aws:dynamodb:*:*:table/*"]
  }
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      var.S3_HOST_ARN == null ? "*" : "${var.S3_HOST_ARN}/*",
      var.S3_HOST_ARN == null ? "*" : "${var.S3_HOST_ARN}",
      "${aws_s3_bucket.codepipeline_bucket.arn}/*",
      "${aws_s3_bucket.codepipeline_bucket.arn}"
    ]
  }
  statement {
    actions = [
      "codebuild:*"
    ]
    resources = ["${aws_codebuild_project.codebuild.arn}/*"]
  }

  statement {
    actions = [
      "acm:ListCertificates",
      "cloudfront:*",
      "iam:ListServerCertificates",
      "waf:ListWebACLs",
      "waf:GetWebACL",
      "wafv2:ListWebACLs",
      "wafv2:GetWebACL",
      "kinesis:ListStreams",
      "kinesis:DescribeStream",
      "iam:ListRoles",
      "codepipeline:GetPipeline",
      "codepipeline:ListTagsForResource",
      "codepipeline:DeletePipeline",
      "codepipeline:UpdatePipeline"
    ]
    resources = ["*"]
  }
  
  statement {
    actions = [
      "acm:DescribeCertificate", // only for custom domains
      "acm:ListCertificates",    // only for custom domains
      "acm:RequestCertificate",  // only for custom domains
      "cloudfront:CreateCloudFrontOriginAccessIdentity",
      "cloudfront:CreateDistribution",
      "cloudfront:CreateInvalidation",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListCloudFrontOriginAccessIdentities",
      "cloudfront:ListDistributions",
      "cloudfront:ListDistributionsByLambdaFunction",
      "cloudfront:ListDistributionsByWebACLId",
      "cloudfront:ListFieldLevelEncryptionConfigs",
      "cloudfront:ListFieldLevelEncryptionProfiles",
      "cloudfront:ListInvalidations",
      "cloudfront:ListPublicKeys",
      "cloudfront:ListStreamingDistributions",
      "cloudfront:UpdateDistribution",
      "iam:AttachRolePolicy",
      "iam:CreateRole",
      "iam:CreateServiceLinkedRole",
      "iam:GetRole",
      "iam:PutRolePolicy",
      "iam:PassRole",
      "lambda:CreateFunction",
      "lambda:EnableReplication",
      "lambda:DeleteFunction",            // only for custom domains
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:PublishVersion",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:ListTags",                  // for tagging lambdas
      "lambda:TagResource",               // for tagging lambdas
      "lambda:UntagResource",             // for tagging lambdas
      "route53:ChangeResourceRecordSets", // only for custom domains
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets",   // only for custom domains
      "s3:CreateBucket",
      "s3:GetAccelerateConfiguration",
      "s3:GetObject",                     // only if persisting state to S3 for CI/CD
      "s3:ListBucket",
      "s3:PutAccelerateConfiguration",
      "s3:PutBucketPolicy",
      "s3:PutObject",
      "lambda:ListEventSourceMappings",
      "lambda:CreateEventSourceMapping",
      "iam:UpdateAssumeRolePolicy",
      "iam:DeleteRolePolicy",
      "sqs:CreateQueue", // SQS permissions only needed if you use Incremental Static Regeneration. Corresponding SQS.SendMessage permission needed in the Lambda role
      "sqs:DeleteQueue",
      "sqs:GetQueueAttributes",
      "sqs:SetQueueAttributes"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "gitops_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["dynamodb:*"]
    resources = ["*"]
  }

  statement {
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    actions = [
      "dynamodb:*"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/*"]
  }

  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.codepipeline_bucket.arn}/*",
      "${aws_s3_bucket.codepipeline_bucket.arn}"
    ]
  }

  statement {
    actions = [
      "codebuild:*"
    ]
    resources = ["${aws_codebuild_project.codebuild.arn}/*"]
  }

  statement {
    actions = [
      "acm:ListCertificates",
      "cloudfront:*",
      "iam:ListServerCertificates",
      "waf:ListWebACLs",
      "waf:GetWebACL",
      "wafv2:ListWebACLs",
      "wafv2:GetWebACL",
      "kinesis:ListStreams",
      "kinesis:DescribeStream",
      "iam:ListRoles"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ssm:*",
      "codestar-notifications:*",
      "ssm:ListTagsForResource",
      "codepipeline:*",
      "codebuild:*",
      "kms:*",
      "s3:*",
      "SNS:*",
      "codestar-connections:*",
      "iam:*",
      "cloudformation:*",
      "chatbot:*"
    ]
    resources = ["*"]
  }
}