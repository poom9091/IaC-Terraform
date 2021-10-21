variable "AWS_REGION"{
    default= "eu-west-1"
}

variable "GIT_REPO_NAME" {}
variable "GIT_BRANCH" {}

locals{
    DynamoDB_REMOTE = "chatbot-${var.GIT_REPO_NAME}-dynamodb-terraform-state"
    S3_REMOTE_CHATBOT = "chatbot-${var.GIT_REPO_NAME}-s3-terraform-state"
}
