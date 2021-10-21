variable "PROJECT_NAME"{
    default = "github-action"
}

variable "SLACK_CHANNEL" {}
variable "SLACK_WORKSPACE" {}

variable "AWS_REGION"{
    default = "eu-west-1"
}

variable "SNS_LIST" {
  type = list(string)
}