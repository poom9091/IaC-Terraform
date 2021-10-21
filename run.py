import os 
import fileinput

STAGE = ["develop","uat","pord"]

BRANCH = os.environ.get('GIT_BRANCH')
REPO_NAME= os.environ.get('GIT_REPO_SLUG')


def terraform_remote_state():
    os.chdir('remote-state')
    os.system('terraform init')
    os.system('terraform apply -input=false -auto-approve || true')
    dynamodb = os.system('terraform output dynamodb_remote_state_name')
    s3 = os.system('terraform output S3_remote_state_name')
    set_backend_directory(dynamodb,s3)
    os.chdir('../')

def set_backend_directory(dynamodb,s3):
    os.chdir(f"../{BRANCH}")
    with fileinput.FileInput("remotestate.tf", inplace=True, backup='.bak') as file:
        for line in file:
            print (line.replace("(S3_remote_state_name)", s3), end='')
            print (line.replace("(dynamodb_remote_state_name)", dynamodb), end='')
            print (line.replace("(stage)", BRANCH), end='')

def terraform_plan():
    os.chdir('develop')
    os.system('terraform init')
    os.system('terraform plan')

def terraform_apply(path_branch):
    terraform_remote_state()
    os.chdir(path_branch)
    os.system('terraform init')
    os.system('terraform apply -input=false -auto-approve')



if BRANCH in STAGE :
    print(f"deploy Terraform branch {BRANCH}")
    terraform_apply(BRANCH)
else:
    print("test Terraform")
    terraform_plan()




    