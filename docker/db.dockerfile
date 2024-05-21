FROM postgres:14-alpine
COPY docker/init.sql /docker-entrypoint-initdb.d/