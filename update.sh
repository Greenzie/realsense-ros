#! /usr/bin/env bash

set -eo pipefail

echo "Merging with upstream and pushing. Be PREPARED for deb version bump"

{ git remote add upstream https://github.com/IntelRealSense/realsense-ros.git; }\
  || { echo "skipping... upstream already exists"; }
git pull upstream development

DEBEMAIL="$(git config --get user.email)" DEBFULLNAME="$(git config --get user.name)" dch -i "Version bump"
DEBEMAIL="$(git config --get user.email)" DEBFULLNAME="$(git config --get user.name)" dch -r
cd ..

echo "I recommend updating git:"
echo
echo 'git commit -m "merge with upstream"'
echo 'git push'
echo
echo

