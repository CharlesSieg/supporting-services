# Supporting Services

A configurable set of containerized services for local development, launched via Docker Compose.

## Services

| Service    | Description                          | Default Port(s)          |
| ---------- | ------------------------------------ | ------------------------ |
| PostgreSQL | Relational database (v17)            | 5432                     |
| MySQL      | Relational database (v8.4)           | 3306                     |
| Redis      | In-memory key-value store (v7)       | 6379                     |
| Valkey     | Redis-compatible key-value store (v8)| 6380                     |
| Milvus     | Vector database (v2.4 standalone)    | 19530 (gRPC), 9091 (HTTP)|

Milvus runs with two internal dependencies (etcd and MinIO) which are managed automatically.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and Docker Compose (v2+)

## Quick Start

```bash
# Start all services
docker compose up -d

# Check health status
docker compose ps

# Stop all services
docker compose down
```

## Configuration

All configurable values are defined in the **`.env`** file at the project root. The defaults work out of the box.

To override values without modifying the committed `.env`, create a **`.env.local`** file — Docker Compose loads it automatically when present, and `.env.local` is git-ignored.

### Ports

| Variable                   | Default |
| -------------------------- | ------- |
| `POSTGRES_PORT`            | 5432    |
| `MYSQL_PORT`               | 3306    |
| `REDIS_PORT`               | 6379    |
| `VALKEY_PORT`              | 6380    |
| `MILVUS_PORT`              | 19530   |
| `MILVUS_HTTP_PORT`         | 9091    |
| `MILVUS_MINIO_PORT`        | 9000    |
| `MILVUS_MINIO_CONSOLE_PORT`| 9001   |

### Credentials

| Variable              | Default    |
| --------------------- | ---------- |
| `POSTGRES_USER`       | postgres   |
| `POSTGRES_PASSWORD`   | postgres   |
| `POSTGRES_DB`         | postgres   |
| `MYSQL_ROOT_PASSWORD` | mysql      |
| `MYSQL_USER`          | mysql      |
| `MYSQL_PASSWORD`      | mysql      |
| `MYSQL_DATABASE`      | mysql      |

## Connecting to Services

### PostgreSQL

```bash
psql -h localhost -p 5432 -U postgres -d postgres
```

Connection string: `postgresql://postgres:postgres@localhost:5432/postgres`

### MySQL

```bash
mysql -h 127.0.0.1 -P 3306 -u mysql -pmysql mysql
```

Connection string: `mysql://mysql:mysql@127.0.0.1:3306/mysql`

### Redis

```bash
redis-cli -p 6379
```

Connection URL: `redis://localhost:6379`

### Valkey

```bash
valkey-cli -p 6380
# or use redis-cli, which is wire-compatible:
redis-cli -p 6380
```

Connection URL: `redis://localhost:6380`

### Milvus

gRPC endpoint: `localhost:19530`
HTTP health endpoint: `http://localhost:9091/healthz`

Python (pymilvus):

```python
from pymilvus import connections
connections.connect(host="localhost", port="19530")
```

## Data Persistence

Each service stores its data in a named Docker volume. Data survives `docker compose down` but is removed by `docker compose down -v`.

| Service  | Volume             |
| -------- | ------------------ |
| Postgres | `postgres_data`    |
| MySQL    | `mysql_data`       |
| Redis    | `redis_data`       |
| Valkey   | `valkey_data`      |
| Milvus   | `milvus_data`      |
| etcd     | `milvus_etcd_data` |
| MinIO    | `milvus_minio_data`|

## Running a Subset of Services

Start only the services you need:

```bash
docker compose up -d postgres redis
```

## Logs

```bash
# All services
docker compose logs -f

# Single service
docker compose logs -f postgres
```

## Resetting Data

To wipe all data and start fresh:

```bash
docker compose down -v
docker compose up -d
```
