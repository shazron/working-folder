#! /bin/bash

# Clones a repo, with all its branches

GIT_URL=$1
FOLDER_PATH=$2

usage() { 
    echo "Usage: $0 <git_url> <folder_path>"  
    exit 1  
} 

if [[ $# -eq 0 ]] ; then
    usage
fi


echo "Cloning the repo $GIT_URL..."
git clone $GIT_URL $FOLDER_PATH
cd $FOLDER_PATH
# grab all remote branches and track them locally
for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master `; do
    git branch --track ${branch#remotes/origin/} $branch
done
