#!/usr/bin/env bash

set -e # exit immediately after any error

echo "
#############################################################################################################
### STEP : Secure Promotion via Supply Chain CLI
###
### - Promote third party images
### - Promote service-mesh images
### - Promote service image
#############################################################################################################
"

#
# 0. Import functions
#
. "${WORKDIR}/scripts/pipeline/function/promote.sh"

#
# 1. Promote third party images (all environment variables prefixed by THIRD_PARTY_IMAGE_")
#
THIRD_PARTY_IMAGES=$(env | grep "THIRD_PARTY_IMAGE_" | cut -d "=" -f 2)
echo ">>> Requesting docker promotion for the third party images :"

# shellcheck disable=SC2068
for image in ${THIRD_PARTY_IMAGES[@]}; do
  run_promote_image "${image}"
done

#
# 2. Promote service-mesh images
#
SERVICE_MESH_IMAGES=$(env | grep "SERVICE_MESH_IMAGE_" | cut -d "=" -f 2)
echo ">>> Requesting promotion for service-mesh images :"

# shellcheck disable=SC2068
for image in ${SERVICE_MESH_IMAGES[@]}; do
  run_promote_image "${image}"
done

#
# 3. Promote service image
#
echo ">>> Request promotion for service image :"
run_promote_image "${IMAGE_TAG}" "${CODEBUILD_RESOLVED_SOURCE_VERSION}" "${GITHUB_REPOSITORY}" "${ROLETYPE}"