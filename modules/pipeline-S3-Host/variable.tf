## Pipeline Setting
variable "CODEPIPELINE_NAME" {}

## S3 Host ARN for setting policy
variable "S3_HOST_ARN" {
  default = null
}

## Project name
variable "PROJECT_NAME" {}
variable "ENV" {}

# Setting Codedstar 
variable "REPO_IP" {}
variable "BRANCH_NAME" {}

## SLACK ID 
variable "SLACK_CHANNEL_ID" {}
variable "SLACK_WORKSPACE_ID" {}

## Bucket S3 Host Name
variable "BUCKET_S3_HOST_NAME" {
  default = "null"
}

# Cloud Front ID 
variable "AWS_CF_DISTRIBUTION_ID" { default = "null" }

# variable "ENV_VARIABLE" {} 
locals {
  ENV_VARIABLE = {
    BUCKET_S3_HOST_NAME    = var.BUCKET_S3_HOST_NAME
    AWS_CF_DISTRIBUTION_ID = var.AWS_CF_DISTRIBUTION_ID
  }
}

# Environment variable
variable "ADDED_ENV" {
  default = {
    "null" = "null"
  }
}


variable "SET_POLICY" {
  default = "web_pipeline"

}