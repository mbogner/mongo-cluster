#!/bin/bash
export COMPOSE_PROJECT_NAME=msc

docker-compose up -d

./setup_configsvr.sh
./setup_shard.sh 0
./setup_shard.sh 1
./setup_mongos.sh msc_mongos0_1 0
./setup_mongos.sh msc_mongos0_1 1

echo "DONE with $0"