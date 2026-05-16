FROM nocobase/nocobase:2.1.0-beta.33-full

# Bake the quickjs-chunks fix script into the image and patch the official
# entrypoint to invoke it right before `yarn start`. This keeps the fix
# independent of any bind-mount / Coolify storage-scripts wiring.
COPY storage-scripts/000-fix-quickjs.sh /usr/local/bin/fix-quickjs.sh
RUN chmod +x /usr/local/bin/fix-quickjs.sh \
 && sed -i 's|cd /app/nocobase && yarn start --quickstart|/usr/local/bin/fix-quickjs.sh; cd /app/nocobase \&\& yarn start --quickstart|' /app/docker-entrypoint.sh \
 && grep -q "/usr/local/bin/fix-quickjs.sh" /app/docker-entrypoint.sh
