// SLACK
variable "SLACK_CHANNEL" {
  default = "test"
}
variable "SLACK_WORKSPACE" {
  default = "test"
}

// Project name
variable "PROJECT_NAME" {
  default = "test"
}

//Environment
variable "ENV_NAME"{
  default = "develop"
}

# AWS Region
variable "AWS_REGION" {
    default = "eu-west-1"
}

variable "ServerSide" {
  default = false
}

# Repository setting 
variable "REPO_ID" {}
variable "BRANCH_NAME" {
    default = "master"
}

# Dynamic Setting Service Name
locals {
  #S3 Hosting
  BUCKET_HOSTING = "${var.ENV_NAME}-${var.PROJECT_NAME}-Hosting"

  #S3 pipeline artifact
  BUCKET_S3 = "${var.ENV_NAME}-${var.PROJECT_NAME}-S3-artifact"

  #Codepipeline name 
  PIPELINE_NAME = "${var.ENV_NAME}-${var.PROJECT_NAME}-Pipeline"

}