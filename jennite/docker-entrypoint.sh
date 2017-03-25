#!/bin/bash
set -e

if [ "$1" = 'app' ]; then
    exec /opt/mica/bin/start.sh
fi

exec "$@"
