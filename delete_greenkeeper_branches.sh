#!/bin/bash

# Description:
#     Delete all `greenkeeper/*` branches of your remote.
# Instructions:
#     The 1st argument is the name of your remote, defaults to 'origin'

ORIGIN=${1:-origin} 

git ls-remote --heads $ORIGIN  | sed 's?.*refs/heads/??' | grep "^greenkeeper/" | xargs -n 1 git push --delete $ORIGIN