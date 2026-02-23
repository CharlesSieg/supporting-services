# CLAUDE.md — Supporting Services

## Project Overview

This project provides containerized local development services via Docker Compose. Configuration lives in `.env` (committed defaults) and `.env.local` (local overrides, git-ignored).

## Service Connection Details

All services run on `localhost` with the ports and credentials listed below. These are the **defaults** from `.env` — if the user has overridden values in `.env.local`, read that file to get the actual values.

### PostgreSQL

- **Host:** localhost
- **Port:** 5432
- **User:** postgres
- **Password:** postgres
- **Database:** postgres
- **Connection string:** `postgresql://postgres:postgres@localhost:5432/postgres`

### MySQL

- **Host:** 127.0.0.1
- **Port:** 3306
- **Root password:** mysql
- **User:** mysql
- **Password:** mysql
- **Database:** mysql
- **Connection string:** `mysql://mysql:mysql@127.0.0.1:3306/mysql`

### Redis

- **Host:** localhost
- **Port:** 6379
- **Connection URL:** `redis://localhost:6379`

### Valkey

- **Host:** localhost
- **Port:** 6380 (maps to internal 6379)
- **Connection URL:** `redis://localhost:6380`
- Wire-compatible with Redis clients.

### Milvus

- **Host:** localhost
- **gRPC port:** 19530
- **HTTP port:** 9091
- **Health check:** `http://localhost:9091/healthz`
- Connect via pymilvus: `connections.connect(host="localhost", port="19530")`

### MinIO (Milvus object storage)

- **API endpoint:** localhost:9000
- **Console:** localhost:9001
- **Access key:** minioadmin
- **Secret key:** minioadmin

### Dashboard

- **URL:** `http://localhost:8090`
- Shows all service connection details in a web UI.

## Common Commands

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# Check service health
docker compose ps

# View logs
docker compose logs -f [service-name]

# Reset all data
docker compose down -v && docker compose up -d
```

## Notes

- Always check if `.env.local` exists before assuming default ports/credentials.
- Data is stored in named Docker volumes and persists across restarts. Use `docker compose down -v` to wipe data.
- Milvus depends on etcd and MinIO containers — these start automatically.
- Valkey and Redis run on different ports (6380 and 6379 respectively) to avoid conflicts.
