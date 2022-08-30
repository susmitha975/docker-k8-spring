#!/usr/bin/env bash

###########################################################################
### This file gathers functions related to promotion via Supply Chain CLI.
###########################################################################

#
# Checks if image has been already promoted.
# Return : "Y" if already promoted, "N" otherwise
#
function is_image_already_promoted {
  local image="${1}"
  local is_already_promoted="N"
  local history_url="https://imagepromotor.cnqr.delivery/retrieve-promo-history?tag=${image}"
  local promoted_log_count=$(curl -s "${history_url}" | jq -r . | grep -c "Image successfully promoted.")

  # There are 5 docker registries, simplest logic to check that image has been promoted to each of them at least once.
  if [ ${promoted_log_count} -ge 5 ]; then
    is_already_promoted="Y"
  fi

  echo "${is_already_promoted}"
}

#
# Promote docker image via Supply Chain CLI.
# Do nothing if image has already been promoted.
#
function run_promote_image {
  local image="${1}"
  local source_commit="${2}" # optional
  local source_repo="${3}" # optional
  local roletype="${4}" # optional

  echo ">>> Checking if image ${image} has already been promoted"
  local already_promoted="$(is_image_already_promoted "${image}")"
  if [ "${already_promoted}" == "Y" ]; then
    echo "    Already promoted, skip."
    return
  fi

  echo ">>> Running docker promotion with the following args/parameters/options :
        SUPPLY_CHAIN_IMAGE=${SUPPLY_CHAIN_IMAGE}
        --image-location=${image}
        --source-commit=${source_commit}
        --source-repo=${source_repo}
        --roletype=${roletype}
  "

  docker run --env-file <(env) \
      "${SUPPLY_CHAIN_IMAGE}" promote docker \
      --image-location "${image}" \
      --source-commit "${source_commit}" \
      --source-repo "${source_repo}" \
      --roletype "${roletype}"
}