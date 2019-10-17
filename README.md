# working-folder

Bash script(s) to set up my open source working folder automatically

## Installation

```bash
git clone https://github.com/shazron/working-folder.git <YOUR_WORKING_FOLDER_NAME>
cd <YOUR_WORKING_FOLDER_NAME>
./update_all.sh
```

## Give the scripts permissions (optional, only if they don't work)

1. `chmod +x ./update_org.sh`
2. `chmod +x ./update_all.sh`

## Clone/Update for a particular Github Org

If you have an org called `adobe`, you would have an `adobe.txt` file that lists all the repos in the org that you want to clone or update.

The script will clone the repo if it does not exist, else it will update the repo. It will also stash any working copies before doing an update, then restore the stash after.


`./update_org.sh <github_org>`

## Clone/Update all Github Orgs

Modify the file `all.txt` with a list of your Github orgs to update, one per line.

`./update_all.sh`

## Special `github` org for different repo sources

Modify the file `github.txt` with a list of repos you want to clone from different sources. Specify a server the repo is from, if it is not from Github.com, as the second argument.

`github.txt`
```
shazron/foo
apache/bar
foo/smoo https://mygitserver.com
```

## Using a different Git server (Org File)

1. Create an org file for your repo, e.g. `myorg.txt`
2. In `all.txt`, add `myorg` to a new line
3. On the same line (no. 2 above), add the server location. Now the line looks like this `myorg https://mygitserver.com`
4. Now you can run `./update_all.sh`

To update just that org, do:
`./update_org.sh <YOUR_ORG> <YOUR_GIT_SERVER_URL>` 
