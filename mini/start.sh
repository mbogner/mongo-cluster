#!/bin/bash
export COMPOSE_PROJECT_NAME=msc

docker-compose up -d || exit 1

./setup_configsvr.sh
./setup_shard.sh ${COMPOSE_PROJECT_NAME} 0
./setup_shard.sh ${COMPOSE_PROJECT_NAME} 1
./setup_mongos.sh ${COMPOSE_PROJECT_NAME}_mongos0_1 0
./setup_mongos.sh ${COMPOSE_PROJECT_NAME}_mongos0_1 1

echo "DONE with $0"