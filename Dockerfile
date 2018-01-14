FROM node:8-alpine
LABEL description="A GraphQL API created by reflection over a PostgreSQL schmea https://github.com/postgraphql/postgraphql"

ENV POSTGRAPHQL_VERSION="3.5.4"

# alpine linux standard doesn't include bash, and postgraphql scripts have #! bash
RUN apk add --update bash su-exec \
  && yarn global add postgraphql@$POSTGRAPHQL_VERSION \
  && rm -rf /var/cache/apk/*

# explicitly set user/group IDs
RUN addgroup -g 1999 postgraphql \
  && adduser -D -u 1999 -G postgraphql postgraphql

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5000
CMD ["postgraphql"]
