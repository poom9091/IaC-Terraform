import os 
import subprocess
import sys
import fileinput

env = ["develop","uat","prod"]
# def getGarameter(env):
def getReponame():
    getReponame = subprocess.Popen('basename -s .git `git config --get remote.origin.url`',
        shell=True,
        stdout=subprocess.PIPE
    )
    out, err = getReponame.communicate()
    repo_name=out.decode('ascii').strip() 
    return repo_name

def setBackend(env):
    repo = getReponame() 
    for e in env:
        subprocess.call(["terraform","init"],cwd="./remote-state")
        os.chdir('./remote-state')
        os.system('echo $TF_VAR_GIT_REPO_NAME')
        os.system('pwd')
        os.system("terraform apply -input=false -auto-approve -var='GIT_REPO_NAME={}' -var='GIT_BRANCH={}' -var-file='../settingaws.tfvars' || true".format(repo,e))
        subprocess.call(["chmod","+x","./script/setbackend.sh"])
        os.system("./script/setbackend.sh {}".format(e))

setBackend(env)
