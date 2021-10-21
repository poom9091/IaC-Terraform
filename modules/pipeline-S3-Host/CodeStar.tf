resource "aws_codestarconnections_connection" "example" {
  name          = var.PROJECT_NAME
  provider_type = "GitHub"
}

## Codestar Notification in slack