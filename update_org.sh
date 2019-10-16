#! /bin/bash

DEFAULT_SERVER="https://github.com"
GH_ORG=$1
SERVER=$DEFAULT_SERVER
if [[ $2 ]]; then 
    SERVER=$2
fi


usage() { 
    echo "Usage: $0 <github_org> [git_server_url]"  
    exit 1  
} 

# $1: server url
# $2: org path or repo path
base_url() {
    if [[ $GH_ORG == "github" ]] ; then
        echo $1
    else
        echo "$1/$2"
    fi
}

# $1: folder value (from line in file)
folder() {
    if [[ $GH_ORG == "github" ]] ; then
        echo $1
    else
        echo "$GH_ORG/$1"
    fi
}


if [[ $# -eq 0 ]] ; then
    usage
fi

# this is the base url for the repos
BASE_URL=$( base_url $SERVER $GH_ORG )

if [[ ! -e "./$GH_ORG.txt" ]]; then
    echo "The file '$GH_ORG.txt' does not exist."
    exit 1
fi


# read the lines in the file into a `repos` array
IFS=$'\n' read -d '' -r -a repos < "./$GH_ORG.txt"

echo "-----Start updating $BASE_URL repos-----"
for i in "${repos[@]}"
do
    # tokenize line, space delimited (REPO SERVER)
    IFS=$' ' read REPO SERVER <<< $i
    # if not specified, use the default server
    if [ !$SERVER ] ; then
        SERVER=$DEFAULT_SERVER
    fi

    FOLDER=$( folder $REPO )
    echo "-----Updating $FOLDER-----"
    # if the repo does not exist, we clone it
    if [[ ! -d $FOLDER ]]; then
        echo "Cloning the repo $i..."
        # re-calc BASE_URL
        BASE_URL=$( base_url $SERVER $GH_ORG )
        git clone $BASE_URL/$REPO $FOLDER
        cd $FOLDER
        # grab all remote branches and track them locally
        for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master `; do
            git branch --track ${branch#remotes/origin/} $branch
        done
        cd ../..
    fi
    cd $FOLDER
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
    # prune local tracking branches that have their remotes deleted
    git remote prune origin
    cd ../..
done

echo "-----Done updating $BASE_URL repos-----"
