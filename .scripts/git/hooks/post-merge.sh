#!/bin/sh

$LATEST_TAG=$(git describe --abbrev=0 --tags)
SEMVER=$($JSON | grep "version" | head -1 | cut -d\" -f4)
# check latest tag
# if tag < master
#   add tag

JSON="cat ./package.json"

git tag $TAG
git push origin $TAG
