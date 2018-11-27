#!/usr/bin/dumb-init /bin/sh

set -e

cat /etc/fluentd/conf/fluentd.conf

fluentd -vv -c $FLUENT_CONF
