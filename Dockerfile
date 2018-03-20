FROM debian:stretch

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
        curl \
        freetds-dev \
        libsqlite3-dev \
        make \
        sbcl \
    && rm -rf /var/lib/apt/lists/*

ENV PG_LOADER_VERSION 3.4.1
ADD https://github.com/dimitri/pgloader/releases/download/v${PG_LOADER_VERSION}/pgloader-bundle-${PG_LOADER_VERSION}.tgz /tmp/pgloader.tgz

RUN mkdir -p /opt/src \
    && tar --extract --ungzip --file=/tmp/pgloader.tgz --directory=/opt/src/ \
    && rm /tmp/pgloader.tgz

RUN cd /opt/src/pgloader-bundle-${PG_LOADER_VERSION} \
    && make \
    && cp bin/pgloader /usr/local/bin/

ENTRYPOINT ["pgloader"]
