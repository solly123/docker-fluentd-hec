#!/usr/bin/dumb-init /bin/sh

set -e

fluentd -c $FLUENT_CONF
