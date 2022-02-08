#!/bin/bash
CONTAINER=msc_configsvr0_1

echo "========================================"
echo " configure configsvr"
echo "========================================"

echo "create replica set"
docker exec -ti "${CONTAINER}" mongosh --eval 'rs.initiate(
    {
      _id: "configsvr",
      configsvr: true,
      members: [
        { _id: 0, host: "configsvr0:27017", priority: 2 },
        { _id: 1, host: "configsvr1:27017", priority: 0 },
        { _id: 2, host: "configsvr2:27017", priority: 0 }
      ]
    }
)' || exit 2
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
