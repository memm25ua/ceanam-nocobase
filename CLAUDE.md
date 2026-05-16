# About This Repository

This is a minimal deployment repo for managing a NocoBase instance hosted remotely on Coolify. It contains only Docker/deployment configuration — there is no application source code here. The actual NocoBase app runs on the remote Coolify server and is managed via the `nb` CLI and NocoBase skills.

# Repository Rules

- Prefer reproducing build and dependency issues locally before pushing fixes.
- Push finished changes to the `main` branch so Coolify can deploy them.
- For NocoBase upgrades, pin package versions in `package.json` and keep deployment files aligned with the tested build path.

# NocoBase Interactions

When the user asks about anything related to how the NocoBase app looks, behaves, or should be changed (UI, pages, blocks, fields, data models, workflows, plugins, ACL, etc.), **always invoke the appropriate `nb` skill** rather than writing raw code or commands. Available skills include:

- `nocobase-ui-builder` — add/edit pages, blocks, fields, actions (default for UI work)
- `nocobase-data-modeling` — collections, fields, relations
- `nocobase-plugin-development` — build custom plugins
- `nocobase-workflow-manage` — workflows and automations
- `nocobase-acl-manage` — roles and permissions
- `nocobase-plugin-manage` — enable/disable plugins
- `nocobase-env-manage` — runtime lifecycle and CLI maintenance
- `nocobase-data-analysis` — query and analyze business data

# SQL Migrations

The `migrations/` directory contains raw SQL scripts that complement the NocoBase data-modeling layer when constraints cannot be expressed through the framework (e.g. multi-column CHECK, XOR, conditional uniqueness). They are idempotent and applied manually after the NocoBase schema is in place.

Apply order is numeric (`001_`, `002_`, …). To run a migration:

```bash
# Via Coolify shell on the Postgres container:
psql "$DATABASE_URL" -f /path/to/migrations/001_check_constraints.sql

# Or against a local dev DB:
psql -h localhost -U nocobase -d nocobase -f migrations/001_check_constraints.sql
```

Document any new migration here when added.

