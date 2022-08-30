#!/usr/bin/env bash

##############################################################################################
### This file gathers functions related to Kate (k8s.groovy replacement for Secure Pipeline).
##############################################################################################

#
# Run Kate
#
function run_kate {
  local prefix="${1}"

  mkdir -p "${KATE_OUTPUT_DIR}"

  echo ">>> Cleaning output directory before calling Kate (otherwise PRs will be created for all remaining files)"
    # shellcheck disable=SC2046
    # shellcheck disable=SC2012
    if [ $(ls "${KATE_OUTPUT_DIR}" | wc -l) -gt 0 ]; then
      # shellcheck disable=SC2115
      rm -r "${KATE_OUTPUT_DIR}"/*
      echo ">>> output directory cleaned..!!!"
    fi

    echo ">>> Running Kate command with the following values :
            prefix=${prefix}
    "

  docker run --rm --env-file <(env) \
    -v "${KATE_INPUT_DIR}":/input \
    -v "${KATE_OUTPUT_DIR}":/output \
    "${KATE_IMAGE}" --prefix="${prefix}" /input /output


  echo ">>> Rendered manifest folder structure :"
  ls -lh "${KATE_OUTPUT_DIR}"/*/*
}