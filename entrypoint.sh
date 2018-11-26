#!/usr/bin/dumb-init /bin/sh

set -e

exec -c "fluentd -c $FLUENT_CONF $@"
