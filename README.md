# PostGraphQL Docker Image

Docker image for PostGraphQL

## Environment Variables

- `POSTGRES_USER`: PostgreSQL username.
- `POSTGRES_PASSWORD`: PostgreSQL user's password.
- `POSTGRES_DB`: PostgreSQL database that will be used.
- `POSTGRES_HOST`: PostgreSQL server's hostname or IP address (optional, default: `localhost`).
- `POSTGRES_PORT`: PostgreSQL server's port (optional, default: `5432`).

## Docker Secrets

As an alternative to passing sensitive information via environment variables, _FILE may be appended to the following environment variables `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`.
The initialization script will load the values for those variables from files present in the container. In particular, this can be used to load passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. For example:
```bash
docker run -p 5000:5000 \
  -e POSTGRES_USER_FILE=/run/secrets/postgres-user \
  -e POSTGRES_PASSWORD_FILE=/run/secrets/postgres-passwd \
  -e POSTGRES_DB_FILE=/run/secrets/postgres-db \
  postgraphql
```

## PostGraphQL Configuration

PostGraphQL configuration can be set directly on the run line.
The entrypoint script is made so that any options passed to the docker command will be passed along to the PostGraphQL. From the [PostGraphQL docs](https://github.com/postgraphql/postgraphql/blob/master/docs/cli.md) we see that options can be passed to `postgraphql` command. For example, to set the schema that will be introspected:
```bash
docker run -p 5000:5000 \
  -e POSTGRES_USER=me \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=db \
  postgraphql postgraphql --schema myschema
```

One option that cannot be changed is `--host`. It will be set to `0.0.0.0` in the image entrypoint.
