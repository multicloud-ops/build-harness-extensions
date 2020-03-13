#!/bin/bash
BUILD_HARNESS_EXTENSIONS_ORG=${1}
BUILD_HARNESS_EXTENSIONS_PROJECT=${2}
BUILD_HARNESS_EXTENSIONS_BRANCH=${3}
GITHUB_USER=${4}
GITHUB_TOKEN=${5}
GITHUB_HOST=${6:-github.com}

if [[ "${GITHUB_TOKEN}" == "" ]]; then
  # No secret
  GITHUB_REPO_SECRET="https://"
else
  GITHUB_REPO_SECRET="https://${GITHUB_USER}:${GITHUB_TOKEN}@"
fi

GITHUB_REPO="${GITHUB_HOST}/${BUILD_HARNESS_EXTENSIONS_ORG}/${BUILD_HARNESS_EXTENSIONS_PROJECT}.git"

# Note - whatever the extension project's name, we're calling it 'build-harness-extensions'
if [ -d "build-harness-extensions" ]; then
  echo "Removing existing build-harness-extensions"
  rm -rf "build-harness-extensions"
fi

echo "Cloning ${GITHUB_REPO}#${BUILD_HARNESS_EXTENSIONS_BRANCH}..."
# Note - whatever the extension project's name, we're calling it 'build-harness-extensions'
git clone -c advice.detachedHead=false --depth=1 -b $BUILD_HARNESS_EXTENSIONS_BRANCH $GITHUB_REPO_SECRET$GITHUB_REPO build-harness-extensions
