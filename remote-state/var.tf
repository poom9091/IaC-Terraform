variable "AWS_REGION"{
    default= "eu-west-1"
}

variable "GIT_REPO_NAME" {}
variable "GIT_BRANCH" {}

locals{
    S3_REMOTE = "${var.GIT_BRANCH}-${var.GIT_REPO_NAME}-s3-terraform-state"
    DynamoDB_REMOTE = "${var.GIT_BRANCH}-${var.GIT_REPO_NAME}-dynamodb-terraform-state"
    S3_REMOTE_CHATBOT = "chatbot-${var.GIT_REPO_NAME}-s3-terraform-state"
}
