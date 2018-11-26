FROM ruby:2.5.1-slim

LABEL maintainer="Gimi Liang <zliang@splunk.com>"

ARG HTTPS_PROXY

# skip runtime bundler installation
ENV FLUENTD_DISABLE_BUNDLER_INJECTION 1
ENV FLUENT_CONF /etc/fluentd/conf

RUN set -e \
 && export http_proxy=$HTTPS_PROXY \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends libjemalloc1 jq \
 && buildDeps="make gcc wget g++" \
 && apt-get install -y --no-install-recommends $buildDeps \
 && gem install -N fluentd -v "1.2.0" \
 && gem install -N fluent-plugin-systemd -v "0.3.1" \
 && gem install -N fluent-plugin-concat -v "2.2.2" \
 && gem install -N fluent-plugin-prometheus -v "1.0.1" \
 && gem install -N fluent-plugin-jq -v "0.5.1" \
 && gem install -N fluent-plugin-splunk-hec -v "1.0.1" \
 && gem install -N oj -v "3.5.1" \
 && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
 && wget -e use_proxy=yes -e http_proxy=$HTTPS_PROXY -e https_proxy=$HTTPS_PROXY -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_$dpkgArch \
 && chmod +x /usr/bin/dumb-init \
 && apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* $GEM_HOME/cache/*.gem \
 && mkdir -p /fluentd/etc

 # See https://packages.debian.org/stretch/amd64/libjemalloc1/filelist
ENV LD_PRELOAD "/usr/lib/x86_64-linux-gnu/libjemalloc.so.1"
COPY entrypoint.sh /fluentd/entrypoint.sh

ENTRYPOINT ["/fluentd/entrypoint.sh"]
CMD ["-h"]
