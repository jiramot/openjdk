FROM alpine:3.12.0

ENV LANG C.UTF-8

RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_ALPINE_VERSION 8.242.08-r2

ONBUILD ARG BUILD_DATE
ONBUILD ARG BUILD_VERSION="-"
ONBUILD ARG VERSION="-"

LABEL org.opencontainers.image.authors="central.the1.engineering@gmail.com" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.source=$BUILD_VERSION

ENV JAVA_OPTS -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=2
ENV VM_OPTS ""
ONBUILD ENV BUILD_VERSION=$BUILD_VERSION
ONBUILD ENV BUILD_DATE=$BUILD_DATE
ONBUILD ENV VERSION=$VERSION

RUN apk --no-cache upgrade && \
    apk add --no-cache ca-certificates && \
    set -x && \
    apk --no-cache add curl bash openjdk8-jre="$JAVA_ALPINE_VERSION" && \
    [ "$JAVA_HOME" = $(docker-java-home) ]  && \
		rm -rf /var/cache/apt/*


COPY ./harden.sh .
RUN chmod +x harden.sh && \
    sh harden.sh

COPY --chown=appuser:appuser docker-entrypoint.sh /usr/local/bin/

USER appuser

CMD ["bash", "docker-entrypoint.sh"]
