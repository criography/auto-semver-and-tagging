#!/bin/bash

# libs
. ../vendor/semver-tool/src/semver

# helpers
. ../helpers/bash/filesystem.sh
. ../helpers/bash/git.sh



# Exit early if master
# =======================================
if [[ $(get_current_branch) == "master" ]]; then
  exit
fi



# Ensure all refs are current.
# If omitted, it's likely that a stale version of package.json
# will be used to extract the current version from remote master.
# =======================================
git fetch origin master



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
git commit -m "Semvering like a pro" --no-verify
