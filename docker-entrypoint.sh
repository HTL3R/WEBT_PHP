#!/usr/bin/env bash
set -e

# Students edit src/ on the host while Apache serves it from a bind mount. If
# Apache wrote as the stock www-data (uid 33), every file PHP creates (uploads,
# generated files, a database) would land on the host owned by a user the
# student cannot edit. Remapping www-data to the student's own uid/gid keeps
# ownership consistent on both sides.
#
# Only remap when PUID is set, so an exported image still runs standalone with
# its baked-in files. docker-compose.yml sets PUID/PGID; override them if your
# host user is not 1000:1000 (check with `id -u` and `id -g`).
if [ -n "${PUID:-}" ]; then
    groupmod -o -g "${PGID:-$PUID}" www-data
    usermod  -o -u "$PUID" www-data
fi

exec apache2-foreground
