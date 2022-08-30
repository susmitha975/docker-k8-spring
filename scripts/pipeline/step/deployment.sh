#!/usr/bin/env bash

set -e # exit immediately after any error

echo "
#############################################################################################################
### STEP : Deployment via Kate
###
### - Render helm manifests
### - Create PRs against ${GITHUB_NAMESPACE_REPOS_REPOSITORY}
#############################################################################################################
"

#
# 1. Import Kate functions
#
. "${WORKDIR}/scripts/pipeline/function/kate.sh"

#
# 2. Declare deployment functions
#

# stable env
function deploy_eks_integration { run_kate "eks_integration" ; }

#
# 3. Trigger Kate depending on the branch pattern
#
case "${GIT_BRANCH}" in

  "integration")
    deploy_eks_integration
    ;;

  # DEFAULT: Feature branch
  *)
    deploy_eks_integration
    ;;

esac