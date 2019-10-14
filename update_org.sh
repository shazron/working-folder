#! /bin/bash

usage() { 
    echo "Usage: $0 <github_org>"  
    exit 1  
} 

if [[ $# -eq 0 ]] ; then
    usage
fi

# simple update, nothing fancy, gets things done
# run from the parent folder CWD (all repos will be siblings)

# this is the base url for the repos
GH_ORG=$1
BASE_URL="https://github.com/$GH_ORG"

if [[ ! -e "./$GH_ORG.txt" ]]; then
    echo "The file '$GH_ORG.txt' does not exist."
    exit 1
fi

# read the lines in the file into a `repos` array
IFS=$'\n' read -d '' -r -a repos < "./$GH_ORG.txt"

echo "-----Start updating $BASE_URL repos-----"
for i in "${repos[@]}"
do
    echo "-----Updating $GH_ORG/$i-----"
    # if the repo does not exist, we clone it
    if [[ ! -d "$GH_ORG/$i" ]]; then
        echo "Cloning the repo $i..."
        git clone $BASE_URL/$i "$GH_ORG/$i"
        cd "$GH_ORG/$i"
        for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master `; do
            git branch --track ${branch#remotes/origin/} $branch
        done
        cd ../..
    fi
    cd "$GH_ORG/$i"
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
    cd ../..
done

echo "-----Done updating $BASE_URL repos-----"
