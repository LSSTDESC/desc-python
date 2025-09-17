#!/bin/bash

MAIN_BRANCH="main"

set -e

release() {
  VERSION_NBR=$(cat VERSION)
  if [ -z "$VERSION_NBR" ]; then
    VERSION_NBR="0.0.1"
  fi

  NEW_VERSION=$1
  if [ -z "$NEW_VERSION" ]; then
    NEW_VERSION="${VERSION_NBR%.*}.$((${VERSION_NBR##*.} + 1))"
  fi

  echo "Attempt to release version $VERSION_NBR and start working for $NEW_VERSION"

  # detect current branch
  BRANCH=$(git rev-parse --abbrev-ref HEAD)

  if [[ "$BRANCH" != "$MAIN_BRANCH" ]]; then
    echo "ERROR: Checkout $MAIN_BRANCH branch before tagging."
    exit 1
  fi

  if [ -z "$(git status --porcelain)" ]; then
    git pull origin $DEV_BRANCH

    VERSION=v$VERSION_NBR
    git tag -a $VERSION -m "Version $VERSION"
    git push origin $MAIN_BRANCH --tags

    echo $NEW_VERSION >VERSION
    git add VERSION
    git commit -a -m "Start dev for v$NEW_VERSION."
    git push origin $MAIN_BRANCH
  else
    echo "ERROR: Working directory is not clean, commit or stash changes."
  fi
}

release $1
