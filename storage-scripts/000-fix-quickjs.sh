#!/bin/sh
# Workaround for plugin-workflow-javascript packaging bug in beta.33-full:
# quickjs-emscripten webpack chunks (NNN.index.js) sit one directory above
# where dist/index.js requires them from. Symlink them into the expected
# location so the JavaScript node executes without
# "Cannot find module './NNN.index.js'".
#
# Re-runnable: idempotent if-not-exists guards.

set -e
QJSDIR="/app/nocobase/node_modules/@nocobase/plugin-workflow-javascript/dist/node_modules/quickjs-emscripten"
[ -d "$QJSDIR" ] || { echo "[fix-quickjs] $QJSDIR not present, skipping"; exit 0; }
[ -d "$QJSDIR/dist" ] || { echo "[fix-quickjs] $QJSDIR/dist not present, skipping"; exit 0; }

for f in "$QJSDIR"/*.index.js; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  target="$QJSDIR/dist/$base"
  if [ ! -e "$target" ]; then
    ln -s "../$base" "$target"
    echo "[fix-quickjs] linked $base"
  fi
done
echo "[fix-quickjs] done"
