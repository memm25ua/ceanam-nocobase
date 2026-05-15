# Coolify Deployment

This repo is a NocoBase app generated with `create-nocobase-app`.

## Coolify

Create an application from the GitHub repo and use the included `docker-compose.yml`.

Set these environment variables in Coolify:

- `APP_KEY`: use the existing production NocoBase `APP_KEY` when restoring an old database.
- `DB_DATABASE`: `ceanam`
- `DB_USER`: `postgres`
- `DB_PASSWORD`: production database password
- `TZ`: `Europe/Madrid`

Expose the `nocobase` service on internal port `13000`.
Do not publish a host port in Coolify; let Coolify/Traefik route the domain to the internal port.

## Empty Database

For a brand-new database, run this once from the NocoBase container terminal:

```bash
yarn nocobase install --lang=en-US
```

Then restart the service.

## Restored Database

When restoring an existing NocoBase database, do not run `nocobase install`.
Restore the PostgreSQL dump first, copy `storage`/`uploads`, and start the app.

Default login for a new install:

- `admin@nocobase.com`
- `admin123`

## Local Docker Compose

For a local test with port `13000` published:

```bash
docker compose -f docker-compose.yml -f docker-compose.local.yml up -d --build
```
