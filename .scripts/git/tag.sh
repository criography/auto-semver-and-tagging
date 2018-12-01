#!/bin/bash

# libs
semver="./.scripts/vendor/semver-tool/src/semver"

# helpers
. ./.scripts/_helpers/bash/filesystem.sh
. ./.scripts/_helpers/bash/git.sh



# Prune tags
# ==========================================
git fetch --prune origin "+refs/tags/*:refs/tags/*"



# Diff the latest master semver with the latest tag.
# Exit early if matching.
# Warn if tag ahead of semver.
# ==========================================
MASTER_SEMVER=$(get_semver "master")
LATEST_TAG=$(get_highest_tag)

SEMVER_DIFF=$(. "$semver"   \
    compare                 \
    "$LATEST_TAG"           \
    "$MASTER_SEMVER"
)

if [[ $SEMVER_DIFF == 1 ]]; then
    echo "Warning: your latest release is ahead of the semver declaration 😱"
    exit
elif [[ $SEMVER_DIFF == 0 ]]; then
    exit
fi



# Tag this puppy up
# ==========================================
git tag $MASTER_SEMVER
git push origin $MASTER_SEMVER
