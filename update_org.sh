#! /bin/bash

usage() { 
    echo "Usage: $0 <github_org> [server]"  
    exit 1  
} 

if [[ $# -eq 0 ]] ; then
    usage
fi



# simple update, nothing fancy, gets things done
# run from the parent folder CWD (all repos will be siblings)

GH_ORG=$1
SERVER="https://github.com"
if [[ $2 ]]; then 
    SERVER=$2
fi

# this is the base url for the repos
BASE_URL="$SERVER/$GH_ORG"

# if the org is special cased as 'github', don't append the org to it
if [[ $GH_ORG == "github" ]] ; then
    BASE_URL=$SERVER
fi

if [[ ! -e "./$GH_ORG.txt" ]]; then
    echo "The file '$GH_ORG.txt' does not exist."
    exit 1
fi

# read the lines in the file into a `repos` array
IFS=$'\n' read -d '' -r -a repos < "./$GH_ORG.txt"

echo "-----Start updating $BASE_URL repos-----"
for i in "${repos[@]}"
do
    FOLDER=$GH_ORG/$i
    # if the org is special cased as 'github', don't append the org folder to it
    if [[ $GH_ORG == "github" ]] ; then
        echo "Special github org handling."
        FOLDER=$i
    fi
    echo "-----Updating $FOLDER-----"
    # if the repo does not exist, we clone it
    if [[ ! -d $FOLDER ]]; then
        echo "Cloning the repo $i..."
        git clone $BASE_URL/$i $FOLDER
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
