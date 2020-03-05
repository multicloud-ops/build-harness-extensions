#!/bin/bash
BUILD_HARNESS_ORG=${1:-cloudposse}
BUILD_HARNESS_PROJECT=${2:-build-harness}
BUILD_HARNESS_BRANCH=${3:-master}
# These will need to be used if a private repo is going to be cloned
GITHUB_USER=${4}
GITHUB_TOKEN=${5}
GITHUB_HOST=${6:-github.com}

if [[ "${GITHUB_TOKEN}" == "" ]]; then
  # No secret
  GITHUB_REPO_SECRET="https://"
else
  GITHUB_REPO_SECRET="https://${GITHUB_USER}:${GITHUB_TOKEN}@"
fi

GITHUB_REPO="${GITHUB_HOST}/${BUILD_HARNESS_ORG}/${BUILD_HARNESS_PROJECT}.git"


if [ "$BUILD_HARNESS_PROJECT" ] && [ -d "$BUILD_HARNESS_PROJECT" ]; then
  echo "Removing existing $BUILD_HARNESS_PROJECT"
  rm -rf "$BUILD_HARNESS_PROJECT"
fi

echo "Cloning ${GITHUB_REPO}#${BUILD_HARNESS_BRANCH}..."
git clone -b $BUILD_HARNESS_BRANCH $GITHUB_REPO_SECRET$GITHUB_REPO
