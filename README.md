# working-folder

Bash script(s) to set up my open source working folder automatically

## Give the scripts permissions

`chmod +x ./update_org.sh`
`chmod +x ./update_all.sh`

## Clone/Update for a particular Github Org

If you have an org called `adobe`, you would have an `adobe.txt` file that lists all the repos in the org that you want to clone or update.

The script will clone the repo if it does not exist, else it will update the repo. It will also stash any working copies before doing an update.


`./update_org.sh <github_org>`

## Clone/Update all Github Orgs

Modify the file `all.txt` with a list of your Github orgs to update, one per line.

`./update_all.sh`

