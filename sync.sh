#!/bin/bash
cd "$(dirname "$0")"
if [ ! "$1" == "--force" -o "$1" == "-f" ]; then
    read -p "Preparing to override files in ${HOME} directory. Do you want to proceed? (y/n) " reply
    if [[ ! ${reply} =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi
rsync --exclude ".git/" --exclude "sync.sh" --exclude "readme.md" -av . ~
