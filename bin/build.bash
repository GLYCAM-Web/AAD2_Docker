#!/usr/bin/env bash
#TEST='N'

if [ ! -d 'image/AAD2_Dependencies/VC_1_0' ] ; then
	echo "Please ensure that you have cloned the submodules."
	echo "That should populate image/AAD2 and image/AAD2_Dependencies."
	exit 1
fi

if [ ! -d 'logs' ] ; then
	mkdir logs
fi

source ./settings.bash

DATE="$( date +%Y-%m-%d-%H-%M-%S )"

echo "The image name is ${AAD2_IMAGE_NAME}"
echo "FROM_IMAGE is ${FROM_IMAGE}"

STDERR_FILE="./logs/build_STDERR_${DATE}.log"
STDOUT_FILE="./logs/build_STDOUT_${DATE}.log"
DOCKER_COMMAND="""
    docker compose \
	--file ${AAD2_DOCKER_COMPOSE_BUILD_FILE} \
	build ${AAD2_SERVICE_NAME} \
	2>> ${STDERR_FILE} \
	>> ${STDOUT_FILE}
"""
echo "Building ${AAD2_SERVICE_NAME} on $( hostname ) with command:"
echo ${DOCKER_COMMAND}
if [ "${TEST}" != "Y" ]; then
	eval ${DOCKER_COMMAND}
	result="$?"
	if [ "${result}" != "0" ] ; then
		echo "Something went wrong building the image."
		echo "The exit code is: ${result}."
		exit 1
	else
		echo "An image was successfully built."
	fi
fi

# EXIT_SUCCESS
exit 0
