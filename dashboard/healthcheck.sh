#!/bin/sh
# Periodically checks each service and writes health.json for the dashboard.

HEALTH_FILE="/usr/share/nginx/html/health.json"

check_tcp() {
  nc -z -w 2 "$1" "$2" > /dev/null 2>&1
}

check_http() {
  curl -sf -o /dev/null -m 3 "$1"
}

while true; do
  # TCP checks
  if check_tcp postgres 5432; then pg="healthy"; else pg="unhealthy"; fi
  if check_tcp mysql 3306;    then my="healthy"; else my="unhealthy"; fi
  if check_tcp redis 6379;    then rd="healthy"; else rd="unhealthy"; fi
  if check_tcp valkey 6379;   then vk="healthy"; else vk="unhealthy"; fi

  # HTTP checks
  if check_http "http://milvus:9091/healthz";                   then mv="healthy"; else mv="unhealthy"; fi
  if check_http "http://milvus-minio:9000/minio/health/live";   then mn="healthy"; else mn="unhealthy"; fi

  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  cat > "${HEALTH_FILE}.tmp" <<EOF
{
  "timestamp": "${timestamp}",
  "services": {
    "postgres": "${pg}",
    "mysql": "${my}",
    "redis": "${rd}",
    "valkey": "${vk}",
    "milvus": "${mv}",
    "minio": "${mn}"
  }
}
EOF

  mv "${HEALTH_FILE}.tmp" "${HEALTH_FILE}"
  sleep 10
done
