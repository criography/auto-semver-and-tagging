#!/bin/bash

get_current_dir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
}

get_semver() {
    if [[ "$1" == "master" ]]; then
       JSON="git remote update && git show origin/master:package.json"
    else
       JSON="cat ./package.json"
    fi

    PACKAGE=$($JSON | grep "version" | head -1 | cut -d\" -f4)

    echo "$PACKAGE"
}


echo $(get_semver "master") $(get_semver "branch")

# test semvers and attempt to increment
# =======================================
NEW_SEMVER=$(
    node $(get_current_dir)/process.js \
    $(get_semver "master") \
    $(get_semver "branch")
)


echo $NEW_SEMVER

# exit early if errors or manual override
# =======================================
EARLY_EXIT=0

if [[ $NEW_SEMVER == *"master_invalid"* ]]; then
  echo "master invalid"
  EARLY_EXIT=1
fi
if [[ $NEW_SEMVER == *"branch_invalid"* ]]; then
  echo "branch invalid"
  EARLY_EXIT=1
fi
if [[ $NEW_SEMVER == *"branch_higher"* ]]; then
  echo "branch higher"
  EARLY_EXIT=1
fi
if [[ $NEW_SEMVER == *"save_failed"* ]]; then
  echo "save failed"
  EARLY_EXIT=1
fi

if [[ $EARLY_EXIT == 1 ]]; then
  exit
fi




# update package.json
# =======================================
git add ./package.json
git commit -m "incrementing semver like a pro 🤓"
