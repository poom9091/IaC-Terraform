#!/bin/bash
stage=$1
dynamodb=$(terraform output dynamodb_remote_state_name)
# s3=$(terraform output S3_remote_state_name)
region=$(terraform output s3_region)
# s3_chatbot=$(terraform output S3_remote_state_name_chatbot)


echo $stage
echo $dynamodb
# echo $s3
echo region

if [ $stage == 'chatbot' ] ; then
    s3_chatbot=$(terraform output S3_remote_state_name_chatbot)
    echo $s3_chatbot
    sed -i "s|(dynamodb_remote_state_name)|$dynamodb|g" ../global/AWS-Chatbot/remotestate.tf
    sed -i "s|(S3_remote_state_name)|$s3_chatbot|g" ../global/AWS-Chatbot/remotestate.tf
    sed -i "s|(stage)|$stage|g" ../global/AWS-Chatbot/remotestate.tf
    sed -i "s|(s3_region)|$region|g" ../global/AWS-Chatbot/remotestate.tf
    cat ../global/AWS-Chatbot/remotestate.tf
elif [ $stage == 'pipeline' ] ; then
    s3=$(terraform output S3_remote_state_name)
    echo $s3
    sed -i "s|(dynamodb_remote_state_name)|$dynamodb|g" ../global/AWS-pipeline/remotestate.tf
    sed -i "s|(S3_remote_state_name)|$s3|g" ../global/AWS-pipeline/remotestate.tf
    sed -i "s|(stage)|$stage|g" ../global/AWS-pipeline/remotestate.tf
    sed -i "s|(s3_region)|$region|g" ../global/AWS-pipeline/remotestate.tf
    cat ../global/AWS-pipeline/remotestate.tf
else
    s3=$(terraform output S3_remote_state_name)
    echo $s3
    sed -i "s|(dynamodb_remote_state_name)|$dynamodb|g" ../environment/$stage/remotestate.tf
    sed -i "s|(S3_remote_state_name)|$s3|g" ../environment/$stage/remotestate.tf
    sed -i "s|(stage)|$stage|g" ../environment/$stage/remotestate.tf
    sed -i "s|(s3_region)|$region|g" ../environment/$stage/remotestate.tf
    cat  ../environment/$stage/remotestate.tf
fi