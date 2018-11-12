#!/bin/bash

# libs
semver="./.scripts/vendor/semver-tool/src/semver"

# helpers
. ./.scripts/_helpers/bash/filesystem.sh
. ./.scripts/_helpers/bash/git.sh




# Exit early if master
# =======================================
if [[ $(get_current_branch) == "master" ]]; then
    exit
fi



# Ensure all refs are current.
# If omitted, it's likely that a stale version
# of package.json will be used to extract the
# current version from remote master.
# =======================================
git fetch origin master



# Diff the semvers and exit early if branch is
# higher than master (assuming manual bump)
# ==========================================
MASTER_SEMVER=$(get_semver "master")
BRANCH_SEMVER=$(get_semver "branch")

SEMVER_DIFF=$(. "$semver"   \
    compare                 \
    "$BRANCH_SEMVER"  \
    "$MASTER_SEMVER"
)

if [[ $SEMVER_DIFF == 1 ]]; then
    exit
fi



# Bump up the semver and update the file
# ==========================================
NEW_SEMVER=$(. "$semver" bump patch "$MASTER_SEMVER")
sed -i -e \
    "s/\"version\": \"$BRANCH_SEMVER\"/\"version\": \"$NEW_SEMVER\"/g" \
    ./package.json



# Create new commit
# ==========================================
git add ./package.json
git commit -m "🏆 Semvering like a pro 🏆" --no-verify
