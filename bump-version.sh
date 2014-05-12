#!/usr/bin/env sh

set -e
set -x

if [ ! -z "$(git status --porcelain)" ]; then
  echo "Please commit all changes before bumping version"
  exit 1
fi

xcrun agvtool bump -all &> /dev/null

MARKETING_VERSION=$(xcrun agvtool what-marketing-version -terse1 | egrep '^\d+')
BUILD_VERSION=$(xcrun agvtool what-version -terse)
FULL_VERSION="${MARKETING_VERSION}-${BUILD_VERSION}"

git tag -a -m ${FULL_VERSION} ${FULL_VERSION}
git commit -a -m "Bump version to ${FULL_VERSION}"
git push --all

echo "Successfully bumped version to ${FULL_VERSION}"
