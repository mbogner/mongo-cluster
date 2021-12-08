#!/bin/bash
SHARD=$1
if [[ "" == "${SHARD}" ]]; then
  echo "missing shard-number"
  echo "usage: $0 <shard-number>"
  exit 1
fi

echo "========================================"
echo " configure shard${SHARD}"
echo "========================================"

CONTAINER="msc_shard${SHARD}svr0_1"

echo "create replica set"
docker exec -ti "${CONTAINER}" mongosh --eval 'rs.initiate(
    {
      _id: "shard'"$SHARD"'",
      members: [
        { _id: 0, host : "shard'"$SHARD"'svr0:27017" },
        { _id: 1, host : "shard'"$SHARD"'svr1:27017" },
        { _id: 2, host : "shard'"$SHARD"'svr2:27017" }
      ]
    }
)
' || exit 2
echo "created replica set"

echo "waiting for election to finish"
sleep 10

echo "disable telemetry"
docker exec -ti "${CONTAINER}" mongosh --eval 'disableTelemetry()' || exit 3
echo "disabled telemetry"

echo "create user"
docker exec -ti "${CONTAINER}" mongosh --eval 'db.getSiblingDB("admin").createUser({
	user: "admin",
  pwd: "admin123",
  roles: [ { role: "root", db: "admin" } ]})' || exit 4
echo "created user"

echo "test authentication"
docker exec -ti "${CONTAINER}" mongosh --eval 'db.getSiblingDB("admin").auth("admin", "admin123")' || exit 5
echo "authenticated successfully"

echo "DONE"
exit 0
