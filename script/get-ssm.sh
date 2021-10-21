#!/bin/bash

Region=$1
AWS_PROFILE=$2
PATH_SSM="/Terraform/SNS_Topic/Noti_Pipeline/"
PATH_ENV_GLOBAL="../global/AWS-Chatbot/terraform.tfvars"

# if [ -z $Region ] ; then
#     Region="eu-west-1"
# fi

if [ -z $AWS_PROFILE ] ; then
    AWS_PROFILE="Terraform"
fi

if cat $PATH_ENV_GLOBAL | grep 'SNS_LIST' ; then
    sed -i '/^SNS_LIST/d' $PATH_ENV_GLOBAL
fi

List_SSM=`aws ssm get-parameters-by-path \
        --path $PATH_SSM  \
        --query "Parameters[*].{Value:Value}" \
        --output text \
        --region $Region`

if [ $? -ne  0 ] ; then
    List_SSM=`aws ssm get-parameters-by-path \
        --path $PATH_SSM  \
        --query "Parameters[*].{Value:Value}" \
        --output text \
        --region $Region \
        --profile Terraform `
    echo $List_SSM
fi

Name=` echo $List_SSM`
List_SNS_TOPIC=` echo $( echo $Name | sed 's|^|"|' | sed 's|$|"|' ) | sed 's|[[:space:]]|","|g'`
# echo $List_SNS_TOPIC
echo 'SNS_LIST=['$List_SNS_TOPIC']' >> $PATH_ENV_GLOBAL
cat $PATH_ENV_GLOBAL
