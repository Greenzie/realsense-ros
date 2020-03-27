#! /bin/bash

set -eo pipefail

alias dch='DEBEMAIL="$(git config --get user.email)" DEBFULLNAME="$(git config --get user.name)" dch'

echo "Merging with upstream and pushing. Be PREPARED for deb version bump"

{ git remote add upstream https://github.com/IntelRealSense/realsense-ros.git; }\
  || { echo "skipping... upstream already exists"; }

git pull upstream development
dch -i "Version bump"
dch -r  # and version bump, fix the version, other details
cd ..

echo "I recommend updating git:"
echo
echo 'git commit -m "merge with upstream"'
echo 'git push'
echo
echo

