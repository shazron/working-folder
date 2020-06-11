#! /bin/bash

# Auxiliary script for run.sh
# First argument is always the repo path

# Global Variables
#   SEARCH_TERM - if set it will do a `git grep` on the search term in the repo
#   GREENKEEPER_CLEAN - if set it will clean any Greenkeeper branches. Ok to run since GK is now defunct 

./update.sh $1

if [ -n "$SEARCH_TERM" ]; then
    ./search.sh $1 $SEARCH_TERM
fi

if [ -n "$GREENKEEPER_CLEAN" ]; then
    ./clean.sh $1
fi



