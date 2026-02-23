# Supporting Services

A configurable set of containerized services for local development, launched via Docker Compose. Every service runs on `localhost` with sensible defaults so you can `docker compose up -d` and start building immediately — no manual setup, no external dependencies.

**Why use this?**

- **Zero configuration** — defaults work out of the box; override anything via `.env.local`.
- **Consistent environments** — every team member gets the same service versions, ports, and credentials.
- **Selective startup** — spin up only the services your project needs (e.g. `docker compose up -d postgres redis`).
- **Persistent data** — named Docker volumes survive restarts; wipe with `docker compose down -v` when needed.
- **Dashboard** — a built-in web UI at [http://localhost:8090](http://localhost:8090) shows every service's ports, credentials, and connection strings at a glance.

## Services

### PostgreSQL (v17) — port 5432

The world's most advanced open-source relational database. Use it for structured data, complex queries, JSONB document storage, full-text search, and anything that benefits from ACID transactions and a rich SQL feature set.

### MySQL (v8.4) — port 3306

A widely-adopted open-source relational database known for its speed and reliability. A common choice for web applications, CMSs, and any workload that needs a battle-tested SQL engine with broad ecosystem support.

### Redis (v7) — port 6379

An in-memory data store used as a cache, message broker, or lightweight database. Supports strings, hashes, lists, sets, sorted sets, streams, and more. Ideal for session storage, rate limiting, real-time leaderboards, and pub/sub messaging.

### Valkey (v8) — port 6380

A community-driven, open-source fork of Redis maintained by the Linux Foundation. Wire-compatible with Redis clients and protocols, so any Redis SDK or CLI works out of the box. Runs on a separate port to allow side-by-side use with Redis.

### Milvus (v2.4) — ports 19530 (gRPC), 9091 (HTTP)

A purpose-built vector database for similarity search and AI applications. Store, index, and query high-dimensional embeddings at scale. Commonly used for semantic search, recommendation systems, RAG pipelines, and image/audio retrieval. Milvus runs with two internal dependencies (etcd and MinIO) which are managed automatically.

### MinIO — ports 9000 (API), 9001 (Console)

An S3-compatible object storage server that serves as Milvus's storage backend. Also usable directly for any workload that needs S3-compatible blob storage locally — upload files, store model artifacts, or test S3 integrations without hitting AWS.

### Dashboard — port 8090

A built-in web UI that displays every service's ports, credentials, and connection strings at a glance. Includes live health monitoring — each service is checked every 10 seconds and displayed with a green (healthy) or red (unhealthy) status indicator.

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
| `DASHBOARD_PORT`           | 8090   |

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

### MinIO

API endpoint: `http://localhost:9000`
Console: [http://localhost:9001](http://localhost:9001)

- **Access key:** `minioadmin`
- **Secret key:** `minioadmin`

MinIO provides S3-compatible object storage used by Milvus. You can also use it directly via any S3-compatible SDK or the `mc` CLI.

### Dashboard

Open [http://localhost:8090](http://localhost:8090) in a browser to view all service connection details and live health status.

Machine-readable endpoints:

| Endpoint | Description |
| -------- | ----------- |
| [/services.json](http://localhost:8090/services.json) | Connection details for all services |
| [/health.json](http://localhost:8090/health.json) | Live health status (updated every 10s) |

```bash
curl http://localhost:8090/services.json
curl http://localhost:8090/health.json
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
