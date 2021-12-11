#!/bin/bash
CONTAINER=$1
SHARD=$2
if [[ "" == "${CONTAINER}" || "" == "${SHARD}" ]] ; then
  echo "missing shard-number"
  echo "usage: $0 <container-name> <shard-number>"
  exit 1
fi

echo "========================================"
echo " add shard${SHARD}"
echo "========================================"

echo "disable telemetry"
docker exec -ti "${CONTAINER}" mongosh --eval 'disableTelemetry()' || exit 3
echo "disabled telemetry"

echo "add shard ${SHARD}"
docker exec -ti "${CONTAINER}" mongosh --eval 'db.getSiblingDB("admin").auth("admin", "admin123"); sh.addShard("shard'"${SHARD}"'/shard'"${SHARD}"'svr0:27017")' || exit 6
echo "added shard ${SHARD} successfully"

echo "DONE"
exit 0
