#! /bin/bash

# Cleans a repo
#   1. Removes all Greenkeeper branches
#   2. Prunes local tracking branches that have their remotes deleted

FOLDER_PATH=$1
ORIGIN=${2:-origin}

usage() { 
    echo "Usage: $0 <folder_path> [remote=origin]"
    echo "<folder_path> (required) the path to the git repo folder"
    echo "[remote=origin] (optional) the git remote, defaults to 'origin'"
    exit 1  
} 

if [[ $# -eq 0 ]] ; then
    usage
fi

cd $FOLDER_PATH

# remove all Greenkeeper branches
git ls-remote --heads $ORIGIN  | sed 's?.*refs/heads/??' | grep "^greenkeeper/" | xargs -n 1 git push --delete $ORIGIN

# prune local tracking branches that have their remotes deleted
git remote prune $ORIGIN
