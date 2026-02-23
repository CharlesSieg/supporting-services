FROM nginx:alpine

COPY index.html.template /usr/share/nginx/html/index.html.template
COPY services.json.template /usr/share/nginx/html/services.json.template
COPY healthcheck.sh /healthcheck.sh
COPY entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
