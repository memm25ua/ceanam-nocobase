# Coolify Deployment

This repo deploys NocoBase with Docker Compose.

## Version

The deployment is pinned to the official NocoBase Docker image:

- `nocobase/nocobase:2.1.0-beta.32`

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

The official image entrypoint prepares the bundled app and starts NocoBase. Back up the database and stop the old instance before deploying a beta upgrade.

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

## Upgrade To A Newer Beta

Check the current beta tag:

```bash
npm view @nocobase/cli@beta version
npm view @nocobase/devtools@beta version
```

Then update the `nocobase` service image tag in `docker-compose.yml`, test the Compose deployment locally, commit the change, and push to `main`.
