#!/bin/bash
# Copyright (c) 2022, NVIDIA CORPORATION.
##############################################
# kvikIO CPU conda upload script for CI      #
##############################################
# Adopted from https://github.com/tmcdonell/travis-scripts/blob/dfaac280ac2082cd6bcaba3217428347899f2975/update-accelerate-buildbot.sh

set -e

# Setup 'gpuci_retry' for upload retries (results in 4 total attempts)
export GPUCI_RETRY_MAX=3
export GPUCI_RETRY_SLEEP=30

# Set default label options if they are not defined elsewhere
export LABEL_OPTION=${LABEL_OPTION:-"--label main"}

# Skip uploads unless BUILD_MODE == "branch"
if [ "${BUILD_MODE}" != "branch" ]; then
  echo "Skipping upload"
  return 0
fi

# Skip uploads if there is no upload key
if [ -z "$MY_UPLOAD_KEY" ]; then
  echo "No upload key"
  return 0
fi

################################################################################
# SETUP - Get conda file output locations
################################################################################

gpuci_logger "Get conda file output locations"
# export LIBKVIKIO_FILE=`conda build --no-build-id --croot "$WORKSPACE/.conda-bld" conda/recipes/libkvikio --output`
export KVIKIO_FILE=$(conda build --no-build-id --croot "${CONDA_BLD_DIR}" conda/recipes/kvikio --python=$PYTHON --output)

################################################################################
# UPLOAD - Conda packages
################################################################################

gpuci_logger "Starting conda uploads"
# gpuci_retry anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai} ${LABEL_OPTION} --skip-existing ${LIBKVIKIO_FILE} --no-progress
gpuci_retry anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai} ${LABEL_OPTION} --skip-existing ${KVIKIO_FILE} --no-progress
