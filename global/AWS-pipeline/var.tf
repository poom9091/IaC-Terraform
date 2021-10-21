# AWS Region
variable "AWS_REGION" {
    default = "eu-west-1"
}

## SLACK
variable "SLACK_CHANNEL" {
  default = "test"
}
variable "SLACK_WORKSPACE" {
  default = "test"
}

variable "ENV_NAME"{
}

# Repository setting 
variable "REPO_IAC_ID" {}
variable "BRANCH_NAME" {
    default = "master"
}

variable "PROJECT_IAC_NAME" {
  default = "test"
}

#variable "SSR" {
  #default = false 
#}

# Dynamic Setting Service Name
locals {
  #Codepipeline name 
  PIPELINE_NAME = "${var.ENV_NAME}-${var.PROJECT_IAC_NAME}-gitops" 
  ENV_VARIABLE = { 
    ENV = "${var.ENV_NAME}" == "main" || "${var.ENV_NAME}" ==  "master" ? "prod" : "${var.ENV_NAME}" ,
    REGION = var.AWS_REGION ,
    REPO_PROJECT_NAME = var.PROJECT_IAC_NAME ,
    REPO_PROJECT_BRANCH = var.BRANCH_NAME,
    SLACK_WORKSPACE = var.SLACK_WORKSPACE
    SLACK_CHANNEL = var.SLACK_CHANNEL
  }
} 
