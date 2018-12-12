#!/bin/bash

# libs
semver="./.scripts/vendor/semver-tool/src/semver"

# helpers
. ./.scripts/_helpers/bash/filesystem.sh
. ./.scripts/_helpers/bash/git.sh
. ./.scripts/_helpers/bash/log.sh



# Diff the latest master semver with the latest tag.
# Exit early if matching.
# Warn if tag ahead of semver.
# ==========================================
LATEST_TAG=$(get_latest_remote_tag)
MASTER_SEMVER=$(get_semver "master")

SEMVER_DIFF=$(. "$semver"   \
    compare                 \
    "$LATEST_TAG"           \
    "$MASTER_SEMVER"
)

if [[ $SEMVER_DIFF == 1 ]]; then
    log_error "DRAMA AHEAD: your latest tag ($LATEST_TAG) is ahead of the package.json ($MASTER_SEMVER)!"
    exit
elif [[ $SEMVER_DIFF == 0 ]]; then
    log_warn "Wait, what? The $MASTER_SEMVER tag is already there. Probably double-check it."
    exit
fi



# Tag this puppy up
# ==========================================
git tag $MASTER_SEMVER master
git push origin $MASTER_SEMVER
log_success "Yay. So excitement. Such crazy. The $MASTER_SEMVER tag has been created to match package.json."
