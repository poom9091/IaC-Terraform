provider "aws" {
  region     = var.AWS_REGION
}

module "chatbot_slack_configuration" {
  source  = "waveaccounting/chatbot-slack-configuration/aws"
  version = "1.0.0"

  configuration_name = "awschatbot-${var.PROJECT_NAME}"
  iam_role_arn       = aws_iam_role.awschatbot_role.arn
  slack_channel_id   = var.SLACK_CHANNEL
  slack_workspace_id = var.SLACK_WORKSPACE

  sns_topic_arns = var.SNS_LIST 
}

resource "aws_iam_role" "awschatbot_role" {
    name = "awschatbot-role-${var.PROJECT_NAME}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "chatbot.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "awschatbot_role_policy" {
  name = "awschatbot_policy"
  role = aws_iam_role.awschatbot_role.name
  policy = data.aws_iam_policy_document.awschatbot_policy.json
}

data "aws_iam_policy_document" "awschatbot_policy" {
    statement{
        actions=[
            "cloudwatch:Describe*",
            "cloudwatch:Get*",
            "cloudwatch:List*"
        ]
        resources = ["*"] 
    }
}