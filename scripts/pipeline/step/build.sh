#!/usr/bin/env bash

set -e # exit immediately after any error

echo "
#############################################################################################################
### STEP : Build
###
### - Run Gradle build
#############################################################################################################
"

#
# 1. Run Gradle build
#
GRADLE_ARGUMENTS="clean build sonarqube"
echo ">>> Running Gradle command with args : ${GRADLE_ARGUMENTS}"
./gradlew ${GRADLE_ARGUMENTS}