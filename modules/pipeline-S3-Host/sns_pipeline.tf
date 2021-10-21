resource "aws_sns_topic" "codepipeline" {
  name = var.CODEPIPELINE_NAME
}

resource "aws_sns_topic_policy" "topic_policy" {
  arn    = aws_sns_topic.codepipeline.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]



    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.codepipeline.arn,
    ]

    sid = "__default_statement_ID"
  }
}

resource "aws_codestarnotifications_notification_rule" "noti_pipeline" {
  name        = "${lower(var.ENV)}-${lower(var.PROJECT_NAME)}"
  resource    = aws_codepipeline.codepipeline.arn
  detail_type = "BASIC"
  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-stage-execution-succeeded",
    "codepipeline-pipeline-manual-approval-needed"
  ]
  target {
    address = aws_sns_topic_policy.topic_policy.arn
  }
}