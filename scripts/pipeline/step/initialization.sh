#!/usr/bin/env bash

set -e # exit immediately after any error

echo "
#########################################################################################
### STEP : Initialization
###
### - Setup environment variables for the pipeline
### - Conditional tasks :
###     --> release/hotfix : create GitHub release
#########################################################################################
"

#
# 0. Import functions
#
. "${WORKDIR}/scripts/pipeline/function/github.sh"
. "${WORKDIR}/scripts/pipeline/function/notification.sh"

#
# 1. Set possible versions variables
#
CURRENT_RELEASE=$(gh release -R "${GITHUB_REPOSITORY}" view --json name | jq -r .name)
SPLIT_RELEASE=(${CURRENT_RELEASE//./ })
MAJOR=${SPLIT_RELEASE[0]}
MINOR=${SPLIT_RELEASE[1]}
POINT=${SPLIT_RELEASE[2]}
GIT_SHORT_COMMIT=$(git log -n 1 --format=%h)

LONG_CURRENT_VERSION="${CURRENT_RELEASE}${GIT_SHORT_COMMIT}"
NEXT_SHORT_RELEASE_VERSION="${MAJOR}.$(expr ${MINOR} + 1).0"
NEXT_LONG_RELEASE_VERSION="${NEXT_SHORT_RELEASE_VERSION}-${GIT_SHORT_COMMIT}"
NEXT_SHORT_HOTFIX_VERSION="${MAJOR}.${MINOR}.$(expr ${POINT} + 1)"

echo ">>> The possible new versions are:
        feature|deploy:   ${LONG_CURRENT_VERSION}
        develop:          ${NEXT_LONG_RELEASE_VERSION}
        release:          ${NEXT_SHORT_RELEASE_VERSION}
        hotfix:           ${NEXT_SHORT_HOTFIX_VERSION}
"

#
# 2. Declare environment variables with default values
#
export NEW_VERSION="${LONG_CURRENT_VERSION}"
export IS_FEATURE_BRANCH="N"
export IS_RELEASE_HOTFIX_BRANCH="N"
export BRANCH_PATTERN="feature"

#
# 3. Updates environment variables based on branch pattern
#
case "${GIT_BRANCH}" in
  "current")
    NEW_VERSION="${NEXT_LONG_RELEASE_VERSION}"
    BRANCH_PATTERN="current"
    ;;
  "main")
      NEW_VERSION="${NEXT_LONG_RELEASE_VERSION}"
      BRANCH_PATTERN="main"
      ;;
  "release"|"release/"*)
    NEW_VERSION="${NEXT_SHORT_RELEASE_VERSION}"
    IS_RELEASE_HOTFIX_BRANCH="Y"
    BRANCH_PATTERN="release"
    ;;
  "hotfix"|"hotfix/"*)
    NEW_VERSION="${NEXT_SHORT_HOTFIX_VERSION}"
    IS_RELEASE_HOTFIX_BRANCH="Y"
    BRANCH_PATTERN="hotfix"
    ;;
  *)
    IS_FEATURE_BRANCH="Y"
    ;;
esac

#
# 4. Additional environment variables
#
export IMAGE_TAG="${QUAY_HOSTNAME}/${QUAY_REPOSITORY}:${NEW_VERSION}"

export SERVICE_MESH_IMAGE_INTEGRATION="${QUAY_HOSTNAME}/servicemesh/integration:${SERVICE_MESH_VERSION}"

export KATE_INPUT_DIR="${WORKDIR}/helm/document-compliance-gateway"
export KATE_OUTPUT_DIR="${WORKDIR}/helm/document-compliance-gateway/rendered"

#
# 5. Initialization output
#
echo ">>> Initialization output :"
env

#
# 6. Send slack notification
#
#send_slack_message "Branch: ${GIT_BRANCH}" "#87ceeb" "Build started with version ${NEW_VERSION} (pattern: ${BRANCH_PATTERN})"

#
# 7. Create GitHub release (release/hotfix only)
#
#if [ "${IS_RELEASE_HOTFIX_BRANCH}" == "Y" ]; then
#  run_create_github_release
#fi