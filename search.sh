#! /bin/bash

# Finds text in a git repo

FOLDER_PATH=$1
SEARCHTEXT=$2

usage() { 
    echo "Usage: $0 <folder_path> <search_text>"
    echo "<folder_path> (required) the path to the git repo folder"
    echo "<search_text> (required) the text to search for"
    exit 1  
} 

if [[ $# -eq 0 ]] ; then
    usage
fi

cd $FOLDER_PATH

git --no-pager grep --line-number -e "$2"