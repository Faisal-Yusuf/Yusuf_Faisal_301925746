# FAHAJ MongoDB Setup Documentation

## 1. MongoDB Installation

MongoDB Community Server was installed in the GitHub Codespace environment.

- **MongoDB version:** 8.0.38
- **MongoDB Shell (mongosh):** 2.14.2
- **Database:** FAHAJ
- **Operating environment:** GitHub Codespaces

## 2. Database Storage

The MongoDB database files are stored outside the project repository to keep database files separate from project source files.

- **Data directory:** `/workspaces/mongodb-data`
- **Backup directory:** `/workspaces/mongodb-data-backup`

## 3. Starting the MongoDB Server

The MongoDB server was started using the following command:

```bash
mongod --dbpath /workspaces/mongodb-data --bind_ip 127.0.0.1
```

The server listens on the local loopback address `127.0.0.1` using port `27017`.

## 4. Connecting to MongoDB

The MongoDB Shell was opened using:

```bash
mongosh "mongodb://127.0.0.1:27017"
```

The following commands were used to verify the connection:

```javascript
db.version()
db.runCommand({ ping: 1 })
```

The server returned version `8.0.38` and a successful ping response:

```javascript
{ ok: 1 }
```

## 5. Database Verification

The existing FAHAJ database was accessed using:

```javascript
use FAHAJ
show collections
```

The `WatchModels` collection was present. The `FAHAJ Classic` document was also retrieved successfully, confirming that the existing database records were accessible.

## 6. Screenshot Evidence

The MongoDB connection verification screenshot is saved at:

`screenshot/Yusuf_Faisal_301925746_MongoDBConnection.png`

## 7. Security and Storage Notes

- MongoDB is configured to listen on `127.0.0.1`, rather than an externally accessible network interface.
- Database files are stored outside the Git repository.
- Database files and credentials are not included in the project repository.