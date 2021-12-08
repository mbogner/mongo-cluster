Mongo Shared Cluster
--------------------

You need mongosh (mongo shell) to follow these steps to login to the instances.

```bash
# MacOS
brew install mongosh
```

# Configuration Server Replica Set

```bash
mongosh mongodb://127.0.0.1:27001
```

```js
rs.initiate(
    {
      _id: "configsvr",
      configsvr: true,
      members: [
        { _id: 0, host : "configsvr0:27017" },
        { _id: 1, host : "configsvr1:27017" },
        { _id: 2, host : "configsvr2:27017" }
      ]
    }
)
rs.status()
```

# Shard Replica Sets

## Shard0 Replica Set

```bash
mongosh mongodb://127.0.0.1:27004
```

```js
rs.initiate(
    {
      _id: "shard0",
      members: [
        { _id: 0, host : "shard0svr0:27017" },
        { _id: 1, host : "shard0svr1:27017" },
        { _id: 2, host : "shard0svr2:27017" }
      ]
    }
)
rs.status()
```

## Shard1 Replica Set

```bash
mongosh mongodb://127.0.0.1:27007
```

```js
rs.initiate(
    {
      _id: "shard1",
      members: [
        { _id: 0, host : "shard1svr0:27017" },
        { _id: 1, host : "shard1svr1:27017" },
        { _id: 2, host : "shard1svr2:27017" }
      ]
    }
)
rs.status()
```

# Add shards to cluster

## Add shard0

```bash
mongosh mongodb://127.0.0.1:27017
```

```js
sh.addShard("shard0/shard0svr0:27017,shard0svr1:27017,shard0svr2:27017")
sh.status()
```

## Add shard1

```bash
mongosh mongodb://127.0.0.1:27017
```

```js
sh.addShard("shard1/shard1svr0:27017,shard1svr1:27017,shard1svr2:27017")
sh.status()
```

# Create Database

```bash
mongosh mongodb://127.0.0.1:27017
```

```js
use demodb
```

## Commands

```
// show databases
show dbs

// show active db
db

// switch to another db
use <dbname>

show collections

// create new collection
db.createCollection("<name>")

// enable sharding for db - just allows sharding for single collections - this isn't global
sh.enableSharding("<dbname>")

// shard a collection - shardkey is used to select shard and it needs a type - example uses title field with hash key
sh.shardCollection("<dbname>.<collectionName>", {"title": "hashed"})

// see sharding info
db.<collectionName>.getShardDistribution()

// list records
db.<collectionName>.find()

// create index for existing table
db.<collectionName>.createIndex({"title": "hashed"})
```