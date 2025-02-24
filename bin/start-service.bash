#!/usr/bin/env bash

#### General settings
source ./settings.bash

COMMAND="docker compose --file docker-compose.yaml  run --rm  AD_environment  bash"

echo "Starting a container with this command:
${COMMAND}
"
( eval ${COMMAND} ) || {  echo "error starting ad container" && exit 1 ; }

