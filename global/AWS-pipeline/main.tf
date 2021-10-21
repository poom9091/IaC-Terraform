provider "aws" {
    region = var.AWS_REGION
}

module "iac-codepipeline" {
    source = "../../modules/pipeline-S3-Host"
    CODEPIPELINE_NAME = local.PIPELINE_NAME
    ## Setting project
    PROJECT_NAME = var.PROJECT_IAC_NAME
    ENV = "${var.ENV_NAME}"
    ## Setting Codestart
    REPO_IP = var.REPO_IAC_ID
    BRANCH_NAME = var.BRANCH_NAME
    ## Slack ID
    SLACK_CHANNEL_ID = var.SLACK_CHANNEL
    SLACK_WORKSPACE_ID = var.SLACK_WORKSPACE
    ## Environment variable (require) 
    BUCKET_S3_HOST_NAME = "null" 
    AWS_CF_DISTRIBUTION_ID = "null" 
    ADDED_ENV = local.ENV_VARIABLE
    SET_POLICY = "gitops"

}