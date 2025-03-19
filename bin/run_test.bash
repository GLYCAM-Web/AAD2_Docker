#!/usr/bin/env bash

# This file will run a test of the AAD2 setup here.

# To run it, run the following from within the top-level AAD2_Docking directory.
# That directory is likely to be named AAD2_Docking
# bash bin/run_test.bash


#### General settings
source ./settings.bash
DATE="$( date +%Y-%m-%d-%H-%M-%S )"
STDOUT_FILE="./logs/run-tests_STDOUT_${DATE}.log"
STDERR_FILE="./logs/run-tests_STDERR_${DATE}.log"

ERRORS="0"
TESTS="0"


##################################
##  First Test
##################################

# Testing an entire 5-replica run
( cd tests && cp -a inputs.all-five outputs.all-five )
LU_WORKING_DIRECTORY="$(pwd)/tests/outputs.all-five"

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
( eval ${COMMAND} ) || {  echo "FATAL: error starting ad container" && exit 1 ; }

TESTS="$((TESTS+1))"

COMMAND="""diff -I CreationDate -I Author tests/outputs.all-five/histogram_sorted.eps tests/correct-outputs.all-five/histogram_sorted.eps"""

echo "Testing the output using this command:
${COMMAND}
"
Response="$(${COMMAND} 2>&1)" 
result="$?"
if [ "${result}" == "0" ] ; then
	echo "The 5-replica test passed."
	echo "Removing test output."
	( cd tests && rm -rf outputs.all-five )
else
	echo "The 5-replica test failed."
	echo "If any response was returned, it appears between the following lines:"
	echo "----------------------------------------------------------------------------------------"
	echo "${Response}"
	echo "----------------------------------------------------------------------------------------"
	echo "Inspecting the following files might provide clues about why the tests failed:"
	echo "${STDERR_FILE}"
	echo "${STDOUT_FILE}"
	echo "Also take a look at the test output in tests/outputs.all-five. Be sure to (re)move it if you run the test again."
	ERRORS="$((ERRORS+1))"
fi


##################################
##  Second Test
##################################

# Testing generation of a pdbqt file if a non-H atom name contains a capital H
( cd tests && cp -a inputs.support-CH3 outputs.support-CH3 )
LU_WORKING_DIRECTORY="$(pwd)/tests/outputs.support-CH3"

COMMAND="""docker run \
    --rm -it \
    -u antibodydocking \
    --name aad2_tester \
    --mount \
    type=bind,src=${LU_WORKING_DIRECTORY},dst=${INTERNAL_WORKING_DIR} \
    ${AAD2_IMAGE_NAME}:${AAD2_TAG_NAME} \
    bash -lc \" AD_Setup ${INTERNAL_WORKING_DIR}  \
      && AD_Evaluate ${INTERNAL_WORKING_DIR} \" \
    2>> ${STDERR_FILE} \
    >> ${STDOUT_FILE} """

echo "Starting a container with this command:
${COMMAND}
"
( eval ${COMMAND} ) || {  echo "FATAL: error starting ad container" && exit 1 ; }

TESTS="$((TESTS+1))"

COMMAND="""diff tests/outputs.support-CH3/ligand.pdbqt tests/correct-outputs.support-CH3/ligand.pdbqt"""

echo "Testing the output using this command:
${COMMAND}
"
Response="$(${COMMAND} 2>&1)" 
result="$?"
if [ "${result}" == "0" ] ; then
	echo "The test for support of atom name 'CH3' passed."
	echo "Removing test output."
	( cd tests && rm -rf outputs.support-CH3 )
else
	echo "The CH3-support test failed."
	echo "If any response was returned, it appears between the following lines:"
	echo "----------------------------------------------------------------------------------------"
	echo "${Response}"
	echo "----------------------------------------------------------------------------------------"
	echo "Inspecting the following files might provide clues about why the tests failed:"
	echo "${STDERR_FILE}"
	echo "${STDOUT_FILE}"
	echo "Also take a look at the test output in tests/outputs.support-CH3. Be sure to (re)move it if you run the test again."
	ERRORS="$((ERRORS+1))"
fi

if [ "${ERRORS}" != "0" ] ; then
	echo "Of the ${TESTS} that ran, ${ERRORS} had errors."
	echo "The tests failed."
	exit 1
else
	echo "Of the ${TESTS} that ran, ${ERRORS} had errors."
	echo "The tests passed."
fi

