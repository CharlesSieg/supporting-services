#!/bin/sh
envsubst < /usr/share/nginx/html/index.html.template > /usr/share/nginx/html/index.html
envsubst < /usr/share/nginx/html/services.json.template > /usr/share/nginx/html/services.json
exec nginx -g 'daemon off;'
