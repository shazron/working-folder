#! /bin/bash

# Updates a repo

FOLDER_PATH=$1

usage() { 
    echo "Usage: $0 <folder_path>"  
    exit 1  
} 

if [[ $# -eq 0 ]] ; then
    usage
fi

cd $FOLDER_PATH

# save the working branch
ACTIVE_BRANCH=$(git symbolic-ref --short HEAD)

# try to push to stack, if changes available
STASH_RC=$(git stash)

# only update master branch
git checkout master
git pull --rebase --all

# go back to the working branch
git checkout $ACTIVE_BRANCH

# we don't want to pop if we didn't push in the first place,
#    if not we will pop a non-related stack item
if [ "$STASH_RC" != "No local changes to save" ]; then
    git stash pop
fi

