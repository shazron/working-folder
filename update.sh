#! /bin/bash

# #############################################################################
#
# Gets or updates git repositories from a config file (config.txt)
# 
# config.txt
# ----------
# In the config.txt file, for each line, specify each repo in the ORG/REPO 
# format, optionally specifying a server url as the second word on the line
#     e.g. foo/bar https://my_git_server.com
#
# Usage
# -----
# update.sh <ORG_FILTER>
#    ORG_FILTER: set to the ORG that you want to update, all other orgs 
#                are ignored
#
# #############################################################################

CONFIG_FILE="config.txt"
DEFAULT_SERVER="https://github.com"

# the first arg if available, is the org filter
ORG_FILTER=$1

usage() { 
    echo "Usage: $0 <github_org>"  
    exit 1  
} 

if [[ $# > 1 ]] ; then
    usage
fi

if [[ ! -e "./$CONFIG_FILE" ]]; then
    echo "The config file '$CONFIG_FILE' does not exist."
    exit 1
fi

# read the lines in the file into a `repos` array
IFS=$'\n' read -d '' -r -a repos < "./$CONFIG_FILE"

echo "-----Start updating repos-----"
for i in "${repos[@]}"
do
    # skip any lines that start with '#' (comments)
    if [[ $i = \#* ]] ; then
        continue
    fi

    # tokenize line, space delimited (REPO_TOKEN SERVER)
    IFS=$' ' read REPO_TOKEN SERVER <<< $i

    # # skip any empty lines
    if [ -z !$REPO_TOKEN ] ; then
        continue
    fi

    # if SERVER not specified, use the default server
    if [ !$SERVER ] ; then
        SERVER=$DEFAULT_SERVER
    fi

    # tokenize REPO_TOKEN, `/` delimited (ORG/REPO)
    ORG=$(dirname $REPO_TOKEN)
    REPO=$(basename $REPO_TOKEN)

    # if a filter is set
    if [ $ORG_FILTER ] ; then
        # filter no match, we skip to the next item in the loop
        if [[ $ORG_FILTER != $ORG ]] ; then
            continue
        fi
    fi

    echo "-----Updating $SERVER/$REPO_TOKEN-----"
    # if the repo does not exist, we clone it
    if [[ ! -d $REPO_TOKEN ]]; then
        echo "Cloning the repo $i..."
        git clone $SERVER/$REPO_TOKEN $REPO_TOKEN
        cd $REPO_TOKEN
        # grab all remote branches and track them locally
        for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master `; do
            git branch --track ${branch#remotes/origin/} $branch
        done
        cd ../..
    fi
    cd $REPO_TOKEN
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

echo "-----Done updating repos-----"
