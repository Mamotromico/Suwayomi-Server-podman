# Build slim JRE
FROM eclipse-temurin:latest AS jre-builder

ARG BUILD_DATE
ARG TACHIDESK_RELEASE_TAG
ARG TACHIDESK_FILENAME
ARG TACHIDESK_RELEASE_DOWNLOAD_URL
ARG TACHIDESK_CONTAINER_GIT_COMMIT

RUN apk add --no-cache binutils

RUN mkdir ./unpacked
RUN cd ./unpacked
RUN unzip ../$TACHIDESK_FILENAME
RUN cd ..
RUN $JAVA_HOME/bind/jdeps \
    --ignore-missing-deps \
    --print-module-deps \
    -q \
    --recursive \
    # --multi-release 17 \
    --class-path="./unpacked/BOOT-INF/lib/*" \
    --module-path="./unpacked/BOOT-INF/lib/*" \
    ./$TACHIDESK_FILENAME > ./deps.info


RUN $JAVA_HOME/bin/jlink \
    --verbose \
    --add-modules $(cat ./deps.info) \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output ./customjre

#Main image
FROM alpine:latest

LABEL org.opencontainers.image.title="Suwayomi Container" \
      org.opencontainers.image.authors="https://github.com/mamotromico, https://github.com/suwayomi" \
      org.opencontainers.image.url="https://github.com/Mamotromico/Suwayomi-Server-podman/pkgs/container/tachidesk, https://github.com/Mamotromico/Suwayomi-Server-podman/pkgs/container/tachidesk" \
      org.opencontainers.image.source="https://github.com/Mamotromico/Suwayomi-Server-podman, https://github.com/Suwayomi/Suwayomi-Server-docker" \
      org.opencontainers.image.description="This image is used to start suwayomi server in a container, modified for better compatibility with rootless pods on podman" \
      org.opencontainers.image.vendor="mamotromico, suwayomi" \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.version=$TACHIDESK_RELEASE_TAG \
      tachidesk.docker_commit=$TACHIDESK_DOCKER_GIT_COMMIT \
      tachidesk.release_tag=$TACHIDESK_RELEASE_TAG \
      tachidesk.filename=$TACHIDESK_FILENAME \
      download_url=$TACHIDESK_RELEASE_DOWNLOAD_URL \
      org.opencontainers.image.licenses="MPL-2.0"

# install unzip to unzip the server-reference.conf from the jar
RUN apk add unzip

# Create a user to run as
RUN userdel -r ubuntu
RUN mkdir -p ~/.local/share/Tachidesk
RUK mkdir -p ~/startup

# Copy the app into the container
RUN curl -s --create-dirs -L $TACHIDESK_RELEASE_DOWNLOAD_URL -o ~/startup/$TACHIDESK_FILENAME
COPY scripts/create_server_conf.sh ~/create_server_conf.sh
COPY scripts/startup_script.sh ~/startup_script.sh

EXPOSE 4567
CMD ["~/startup_script.sh"]

# vim: set ft=dockerfile:
