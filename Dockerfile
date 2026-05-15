FROM node:22-bookworm-slim

WORKDIR /app

ENV NODE_ENV=production \
    APP_ENV=production \
    APP_PORT=13000

RUN corepack enable

COPY package.json yarn.lock ./
COPY lerna.json tsconfig.json tsconfig.server.json vitest.config.mts playwright.config.ts .env.e2e.example ./
COPY packages ./packages

RUN yarn install --production=false \
    && yarn cache clean \
    && mkdir -p storage/uploads storage/plugins storage/db storage/logs

EXPOSE 13000

CMD ["sh", "-c", "yarn nocobase upgrade --skip-code-update && yarn start"]
