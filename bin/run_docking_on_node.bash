#!/usr/bin/env bash

### On Thoreau head node, docker-compose does not exist.  One must use docker compose.
### On the compute nodes, docker compose does not exist.  One must use docker-compose.

source ./settings.bash

DATE="$( date +%Y-%m-%d-%H-%M-%S )"
STDOUT_FILE="./logs/run-command_STDOUT_${DATE}.log"
STDERR_FILE="./logs/run-command_STDERR_${DATE}.log"

if [ ! -z "${1}" ] ; then
	LU_WORKING_DIRECTORY="${1}"
fi

if [ "${LU_WORKING_DIRECTORY}" == "unset" ] ; then
	echo "Must specify the local user's working directory."
	exit 1
fi

if [ ! -d "${LU_WORKING_DIRECTORY}" ] ; then
	echo "The specified LU_WORKING_DIRECTORY is not a directory."
	exit 1
fi

export AAD2_COMPOSE_COMMAND="bash -lc \"cd ${INTERNAL_WORKING_DIR} && run_AD_docking\""

echo "The AAD2_COMPOSE_COMMAND is:
>>>${AAD2_COMPOSE_COMMAND}<<<"
echo "The local dir is:
>>>${LU_WORKING_DIRECTORY}<<<"

export LU_WORKING_DIRECTORY

COMMAND="""
${compose_command} \
	--file ${AAD2_DOCKER_COMPOSE_FILE} \
        --project-name ${CONTAINER_NAME_PREFIX} \
	up  
"""
#TEST="Y"
echo "Up:"
echo ${COMMAND}
if [ "${TEST}" != "Y" ]; then
	eval ${COMMAND}
fi
COMMAND="""
${compose_command} \
	--file ${AAD2_DOCKER_COMPOSE_FILE} \
        --project-name ${CONTAINER_NAME_PREFIX} \
        down  
"""
echo "Down:"
echo ${COMMAND}
if [ "${TEST}" != "Y" ]; then
	eval ${COMMAND}
fi

# EXIT_SUCCESS
exit 0
