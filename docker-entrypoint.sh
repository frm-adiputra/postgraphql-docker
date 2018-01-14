#!/bin/bash
set -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

if [ "$1" = 'postgraphql' ]; then
	file_env 'POSTGRES_USER'
	if [ -z "$POSTGRES_USER" ]; then
		echo >&2 "error: POSTGRES_USER not provided"
		exit 1
	fi

	file_env 'POSTGRES_PASSWORD'
	if [ -z "$POSTGRES_PASSWORD" ]; then
		echo >&2 "error: POSTGRES_PASSWORD not provided"
		exit 1
	fi

	file_env 'POSTGRES_DB'
	if [ -z "$POSTGRES_DB" ]; then
		echo >&2 "error: POSTGRES_DB not provided"
		exit 1
	fi

	if [ -z "$POSTGRES_HOST" ]; then
		POSTGRES_HOST=localhost
		# echo >&2 "error: POSTGRES_HOST not provided"
		# exit 1
	fi

	if [ -z "$POSTGRES_PORT" ]; then
		POSTGRES_PORT=5432
		# echo >&2 "error: POSTGRES_PORT not provided"
		# exit 1
	fi

	conn="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"
	args=("$@")
	args+=("--connection" "$conn")
  exec su-exec postgraphql "${args[@]}"
fi

exec "$@"
