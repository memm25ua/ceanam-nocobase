# Repository Rules

- Do not install dependencies locally in this repository. Avoid `yarn install`, `npm install`, local Docker builds, or local NocoBase startup unless the user explicitly overrides this rule.
- Make code/configuration changes directly in the repository files.
- Push finished changes to the `main` branch.
- Let Coolify build, deploy, and validate the application after the push.
- For NocoBase upgrades, pin package versions in `package.json`; Coolify must perform the container build and run the deployment startup command.
