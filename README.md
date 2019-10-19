# working-folder

Bash script(s) to set up my open source working folder automatically

## Installation

```bash
git clone https://github.com/shazron/working-folder.git <YOUR_WORKING_FOLDER_NAME>
cd <YOUR_WORKING_FOLDER_NAME>
./update.sh
```

## Give the script permissions (optional, only if they don't work)

`chmod +x ./update.sh`

## config.txt to specify your git repo list

In the `config.txt` file add a line for each `ORG/REPO` you want to clone or update.

```
# These are repos for the foo project
foo/bar
foo/baz

# These are repos for the yoo project
yoo/hoo
```

Empty lines and lines starting with the character `#` are ignored.

## Clone/update for a particular org

`./update.sh <github_org>`

## Clone/update all

`./update.sh`

## Specifying a server for a repo

Add a second word in the line, to specify the git server to connect to for the repo

`config.txt`
```
shazron/foo
apache/bar
foo/smoo https://mygitserver.com
```