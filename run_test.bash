#!/usr/bin/env bash

# This file will run a test of the AAD2 setup here.
# The output will not be rigorously tested, yet. It will only test for presence of files,
# not necessarily for content. That can be done (*), but one step at a time...
#
# * To do that, we need to set random seeds and ensure that the same random number progressions
# are followed. And, we want to do that. There is much to do. Working at all is the goal right now.

# To run it, run the following from within the directory where the file is found.
# bash run_test.bash

( cd tests && cp -a inputs outputs )

#### General settings
source ./settings.bash
Container_Dir="/programs/code-temp"

Host_Dir="$(pwd)/tests/outputs"

COMMAND="""docker run \
    --rm -it \
    -u antibodydocking \
    --name ad_tester \
    --mount \
    type=bind,src=${Host_Dir},dst=${Container_Dir} \
    ${ImageName}:${ImageTag} \
    bash -c \" source /home/antibodydocking/.bashrc \
      && AD_Setup ${Container_Dir} \
      && AD_Evaluate ${Container_Dir} \
      && AD_Run_AD ${Container_Dir} \
      && AD_Analyze ${Container_Dir} \" """

echo "Starting a container with this command:
${COMMAND}
"
( eval ${COMMAND} ) || {  echo "error starting ad container" && exit 1 ; }

COMMAND="""diff -I CreationDate tests/outputs/histogram_sorted.eps tests/correct-outputs/histogram_sorted.eps"""

echo "Testing the output using this command:
${COMMAND}
"
if [ -z "$(${COMMAND})" ] ; then
	echo "The test passed."
else
	echo "The test failed."
fi

echo "Removing test output."
( cd tests && rm -rf outputs )
