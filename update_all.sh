#! /bin/bash

# simple update, nothing fancy, gets things done
# run from the parent folder CWD (all repos will be siblings)

# this is the base url for the repos
ORGS_FILE='./all.txt'

if [[ ! -e $ORGS_FILE ]]; then
    echo "The file '$ORGS_FILE' does not exist."
    exit 1
fi

# read the lines in the file into a `repos` array
IFS=$'\n' read -d '' -r -a orgs < $ORGS_FILE

echo "-----Start updating orgs-----"
for i in "${orgs[@]}"
do
    echo "-----Updating org $i-----"
    ./update_org.sh $i
done

echo "-----Done updating orgs-----"
