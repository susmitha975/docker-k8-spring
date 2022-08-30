#!/usr/bin/env bash

set -e # exit immediately after any error

echo "
#############################################################################################################
### STEP : Packaging
###
### - Build and Push the Docker image
### - Export the IMAGE_DIGEST to be injected in k8s manifests
#############################################################################################################
"

#
# 1. Prepare Docker build arguments
#

echo ">>> path directory to $(pwd)"

##cd ./build/libs
##ls -la
DOCKER_BUILD_ARGS="-f ./Dockerfile -t ${IMAGE_TAG}"

#
# 2. Run Docker build
#
echo ">>> Running Docker build with the following arguments : ${DOCKER_BUILD_ARGS}"
docker build ${DOCKER_BUILD_ARGS} .

#
# 3. Login to Quay
#
echo ">>> Login to ${QUAY_HOSTNAME}"
echo -n "${QUAY_ROBOT_TOKEN}" | docker login -u="${QUAY_ROBOT_USERNAME}" --password-stdin "${QUAY_HOSTNAME}"

#
# 4. Push to Quay
#
echo ">>> Running Docker push command with tag ${IMAGE_TAG}"
docker push "${IMAGE_TAG}"

#
# 5. Export IMAGE_DIGEST
#
export IMAGE_DIGEST=$(docker inspect ${IMAGE_TAG} | jq -r '.[].RepoDigests | .[0]' | grep -oP 'sha256:[0-9a-f]{64}$')
echo ">>> Exported IMAGE_DIGEST=${IMAGE_DIGEST}"