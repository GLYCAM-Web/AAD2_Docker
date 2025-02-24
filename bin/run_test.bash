#!/usr/bin/env bash

# This file will run a test of the AAD2 setup here.

# To run it, run the following from within the top-level AAD2_Docking directory.
# That directory is likely to be named AAD2_Docking
# bash bin/run_test.bash

( cd tests && cp -a inputs outputs )

#### General settings
source ./settings.bash
DATE="$( date +%Y-%m-%d-%H-%M-%S )"
STDOUT_FILE="./logs/run-tests_STDOUT_${DATE}.log"
STDERR_FILE="./logs/run-tests_STDERR_${DATE}.log"

LU_WORKING_DIRECTORY="$(pwd)/tests/outputs"

COMMAND="""docker run \
    --rm -it \
    -u antibodydocking \
    --name aad2_tester \
    --mount \
    type=bind,src=${LU_WORKING_DIRECTORY},dst=${INTERNAL_WORKING_DIR} \
    ${AAD2_IMAGE_NAME}:${AAD2_TAG_NAME} \
    bash -lc \" AD_Setup ${INTERNAL_WORKING_DIR} \
      && AD_Run_Core_Serial ${INTERNAL_WORKING_DIR} \" \
    2>> ${STDERR_FILE} \
    >> ${STDOUT_FILE} """

echo "Starting a container with this command:
${COMMAND}
"
( eval ${COMMAND} ) || {  echo "error starting ad container" && exit 1 ; }

COMMAND="""diff -I CreationDate -I Author tests/outputs/histogram_sorted.eps tests/correct-outputs/histogram_sorted.eps"""

echo "Testing the output using this command:
${COMMAND}
"
if [ -z "$(${COMMAND})" ] ; then
	echo "The test passed."
	echo "Removing test output."
	( cd tests && rm -rf outputs )
else
	echo "The test failed."
	echo "Inspecting the following files might provide clues about why the tests failed:"
	echo "${STDERR_FILE}"
	echo "${STDOUT_FILE}"
	echo "Also take a look at the test output in tests/outputs. Be sure to (re)move it if you run the test again."
fi

