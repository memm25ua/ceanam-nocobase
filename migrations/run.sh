#!/bin/sh
# Apply SQL migrations in alphabetical order against the bound Postgres.
# Idempotent files only — re-run every deploy.

set -e

: "${DB_USER:?DB_USER not set}"
: "${DB_DATABASE:?DB_DATABASE not set}"
: "${PGPASSWORD:?PGPASSWORD not set}"

echo "Running SQL migrations against ${DB_DATABASE} as ${DB_USER}..."

found=0
for f in /migrations/*.sql; do
  [ -e "$f" ] || continue
  found=1
  echo ">>> Applying $f"
  psql -h postgres -U "$DB_USER" -d "$DB_DATABASE" -v ON_ERROR_STOP=1 -f "$f"
done

if [ "$found" = "0" ]; then
  echo "No migration files found in /migrations."
fi

echo "Migrations done."
