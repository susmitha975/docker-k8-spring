#!/usr/bin/env bash

set -e # exit immediately after any error

#######################################################################################################
### This is the pipeline script that will be run by buildspec.yml
###
### It follows the following steps :
###   1. Initialization : setup environment variables
###         --> if release/hotfix : create GitHub release
###   2. Build : build service and run tests
###   3. Packaging : build and push docker image
###   4. Promotion : promote third party images, service-mesh images, and docker image from step 3.
###   5. Deployment : render helm manifests and create PRs against namespace-repos/raas.
###   6. Post-deployment : additional actions processed for some scenario (auto-merge, E2E tests, ...)
#######################################################################################################

#
# 1. Initialization
#
. "${WORKDIR}/scripts/pipeline/step/initialization.sh"

#
# 2. Build
#
. "${WORKDIR}/scripts/pipeline/step/build.sh"

#
# 3. Packaging
#
. "${WORKDIR}/scripts/pipeline/step/packaging.sh"

#
# 4. Promotion
#
. "${WORKDIR}/scripts/pipeline/step/promotion.sh"

#
# 4. Deployment
#
. "${WORKDIR}/scripts/pipeline/step/deployment.sh"