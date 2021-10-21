 terraform {
     backend "s3"{
         bucket = (S3_remote_state_name)
         key    = "(stage)/terraform.tfstate"
         region = (s3_region)
         dynamodb_table = (dynamodb_remote_state_name)
         encrypt = true
     }
 }

