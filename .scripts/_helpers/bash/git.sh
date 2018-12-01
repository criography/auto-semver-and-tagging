#!/bin/bash


# fun: get_semver branch
# txt: retrieve package.json's version from a local branch or remote master
# opt: branch: 'master' or omitted to use current, local branch
# use: sum 'master'
# api: sum
get_semver() {
    if [[ "$1" == "master" ]]; then
       JSON="git show origin/master:package.json"
    else
       JSON="cat ./package.json"
    fi

    PACKAGE=$($JSON | grep "version" | head -1 | cut -d\" -f4)

    echo "$PACKAGE"
}




get_current_branch() {
    echo $(git rev-parse --abbrev-ref HEAD)
}
