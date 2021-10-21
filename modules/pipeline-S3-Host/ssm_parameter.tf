
resource "aws_ssm_parameter" "sns_paratermer" {
  name  =  var.SET_POLICY == "web_pipeline" ? "/Terraform/SNS_Topic/Noti_Pipeline/${lower(var.ENV)}_${lower(var.PROJECT_NAME)}" : "/Terraform/SNS_Topic/Noti_Pipeline/${lower(var.ENV)}_${lower(var.PROJECT_NAME)}_gitops_pipeline"
  # name  = "/Terraform/SNS_Topic/Noti_Pipeline/${lower(var.ENV)}"
  type  = "String"
  value = aws_sns_topic.codepipeline.id
}
