provider "aws" {
  region     = var.AWS_REGION
}

## S3 WEB HOSTING
module "s3_webhost" {
  source      = "../../modules/s3-webhosting"
  BUCKET_NAME_HOSTING = local.BUCKET_HOSTING
  ENV = var.ENV_NAME
}

## CI/CD pipeline
module "codepipeline" {
  source = "../../modules/pipeline-S3-Host"
  CODEPIPELINE_NAME = local.PIPELINE_NAME
  ## Cloud Front ID
  AWS_CF_DISTRIBUTION_ID = "${module.s3_webhost.cloudfront-id}"
  ## S3 Host ARN for setting policy
  S3_HOST_ARN = "${module.s3_webhost.arn-s3-host}"
  ## Bucket S3 Host 
  BUCKET_S3_HOST_NAME = "${module.s3_webhost.name-s3-host}"
  ## Setting project
  PROJECT_NAME = var.PROJECT_NAME
  ENV = var.ENV_NAME
  ## Setting Codestart
  REPO_IP = var.REPO_ID
  BRANCH_NAME = var.BRANCH_NAME
  ## Slack ID
  SLACK_CHANNEL_ID = var.SLACK_CHANNEL
  SLACK_WORKSPACE_ID = var.SLACK_WORKSPACE
}
