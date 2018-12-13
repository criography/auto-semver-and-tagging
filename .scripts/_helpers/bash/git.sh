#!/bin/bash


# fun: get_semver branch
# txt: retrieve package.json's version from a local branch or remote master
# opt: branch: 'master' for remote master, 'branch' or omitted to use current, local branch
# use: get_semver 'master'
# use: get_semver 'branch'
# use: get_semver
get_semver() {
    if [[ "$1" == "master" ]]; then
       JSON="git show origin/master:package.json"
    else
       JSON="cat ./package.json"
    fi

    PACKAGE=$($JSON | grep "version" | head -1 | cut -d\" -f4)

    echo "$PACKAGE"
}



# fun: get_current_branch
# txt: extract current branch name
# use: get_current_branch
get_current_branch() {
    echo $(git rev-parse --abbrev-ref HEAD)
}



# fun: get_highest_tag
# txt: extract highest remote tag number
# use: get_highest_tag
get_highest_local_tag() {
    echo $(git tag | tail -n 1)
}


# fun: get_latest_remote_tag
# txt: extract highest local tag number
# use: get_latest_remote_tag
get_latest_remote_tag() {
    echo $(git ls-remote --tags --sort=committerdate | tail -1 | cut -d "/" -f 3)
}


# fun: prune_tags
# txt: remove local git tags that are no longer on the remote repository
# use: prune_tags
prune_tags() {
    git fetch --prune origin "+refs/tags/*:refs/tags/*"
}
