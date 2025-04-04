#!/usr/bin/env bash

##  If you want to override anything in this file, place the override here:
##
##      ${AAD2_Docker}/LocalSettings.sh
##
##  This local-override file is sourced at the bottom of this file.
##  Don't forget to preface your overrides with 'export'

## This must be overridden.
## To override:
##    Set it on the command line as an argument to bin/run_aad2_command.bash
##    Set it inside a local settings file.
##    Set it inside a custom script you write.
##    Some of the executables here (e.g. 'bin/run_test.bash') override it.
## This is the name of the working directory on the host - the one that 
## you can see and interact with without running docker.
##
export LU_WORKING_DIRECTORY="unset" # The local user's working directory

## This is used in bin/run_aad2_command.bash 
## You should override this with the command you want to run. 
##
export AAD2_COMMAND_TO_RUN="AD_Help"

## Overriding these can give you control over the image or the name of the container
##
export AAD2_IMAGE_NAME="antibody-docking"
export AAD2_TAG_NAME="2025-03-31-00-22-blf"
if [ -z "${CONTAINER_NAME_PREFIX}" ] ; then
	tempstr="$(uuidgen)"
	CONTAINER_NAME_PREFIX=${tempstr:0:5}
fi
export AAD2_CONTAINER_NAME="${CONTAINER_NAME_PREFIX}-$( id -un )-aad2"

## Unless you are customizing a lot, you probably want to leave these as-is
#
export AAD2_DOCKER_COMPOSE_FILE="./docker-compose.yaml"
export AAD2_DOCKER_COMPOSE_BUILD_FILE="./docker-compose-build.yaml"
export AAD2_SERVICE_NAME="aad2_environment"

## You should probably not override these unless you have an unusual setup
##
export FROM_IMAGE="thecoulter/boost-1.41_gcc-4.4.7:latest"
export AD_BUILD_PROCS="4"
export IA_USER_ID="7365"
export IA_GROUP_ID="7365"
export LU_USER_ID="$( id -u )"
export LU_GROUP_ID="$( id -g )"
#
## This is the name of the working directory inside the container.
## That is, this is where ${LU_WORKING_DIRECTORY} will be mounted to.
#
export INTERNAL_WORKING_DIR="/home/antibodydocking/workdir/"

## It is necessary to figure out whether we can use docker-compose or must use docker compose.
#
#[webdev@thoreau AAD2_Docker]$ docker-compose version
#bash: docker-compose: command not found...
#[webdev@thoreau AAD2_Docker]$ echo $?
#127
#docker-compose version 
docker-compose version > /dev/null 2>&1
result="$?"
#echo "result is ${result}"
if [ "${result}" == "0" ] ; then
    compose_command="docker-compose"
else
    docker compose version > /dev/null 2>&1
    result="$?"
    if [ "${result}" == "0" ] ; then
        compose_command="docker compose"
    else
        echo "Cannot determine command for using docker compose. Exiting."
        echo "The result from trying 'docker compose version' is ${result}."
        exit ${result}
    fi
fi
echo "The command for using docker compose is >>>${compose_command}<<<"
#[webdev@thoreau AAD2_Docker]$ docker compose version
#Docker Compose version v2.27.1
#[webdev@thoreau AAD2_Docker]$ echo $?
#0

#### Optional settings customization
# Create a file called Local_Settings.bash to override the settings above
if [ -e "Local_Settings.bash" ] ; then
	source Local_Settings.bash
fi

