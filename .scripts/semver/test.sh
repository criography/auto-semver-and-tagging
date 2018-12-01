#!/usr/bin/env bash

# libs
semver="./.scripts/vendor/semver-tool/src/semver"


# helpers
. ./.scripts/helpers/bash/filesystem.sh
. ./.scripts/helpers/bash/git.sh

. "$semver" compare 2.1.3 3.2.1


# Exit early if master
# =======================================
if [[ $(get_current_branch) == "master" ]]; then
  echo "poop"
else
    echo "boob"
fi
