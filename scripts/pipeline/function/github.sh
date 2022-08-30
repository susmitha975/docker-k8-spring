#!/usr/bin/env bash

#############################################################################
### This file gathers functions related to GitHub : release, auto-merge, ...
#############################################################################

#
# Auto-merges the last opened PR created by Kate for current commit.
#
function run_automerge_pr_for_commit {
  local wait=30
  echo -n ">>> Waiting for $wait seconds so that we won't try to retrieve the Pull Request too fast..."
  sleep $wait
  echo " done"

  echo ">>> Retrieving the Pull Request number"
  local pull_request_number="$(gh pr list -R "${GITHUB_NAMESPACE_REPOS_REPOSITORY}" -S "${CODEBUILD_RESOLVED_SOURCE_VERSION}" --json number -q .[0].number)"

  echo ">>> Auto-merging Pull Request #${pull_request_number}"
  gh pr review -R "${GITHUB_NAMESPACE_REPOS_REPOSITORY}" -a ${pull_request_number}
  gh pr merge -R "${GITHUB_NAMESPACE_REPOS_REPOSITORY}" -s ${pull_request_number}
}

#
# Creates GitHub release
#
function run_create_github_release {
  local notes="Release content tracked in Jira, see https://jira.concur.com/projects/FGM?selectedItem=com.atlassian.jira.jira-projects-plugin%3Arelease-page&status=unreleased"

  echo ">>> Creating release ${NEW_VERSION} from commit ${CODEBUILD_RESOLVED_SOURCE_VERSION}"
  gh release create "${NEW_VERSION}" --target "${CODEBUILD_RESOLVED_SOURCE_VERSION}" -n "${notes}"
}