# Build slim JRE for final image
FROM eclipse-temurin:17-jdk-alpine AS jre-builder

ARG SUWAYOMI_RELEASE_TAG
ARG SUWAYOMI_RELEASE_FILENAME
ARG SUWAYOMI_RELEASE_DOWNLOAD_URL
ARG BUILD_DATE
ARG GIT_COMMIT

ADD $SUWAYOMI_RELEASE_DOWNLOAD_URL .

RUN mkdir ./unpacked &&\
    cd ./unpacked &&\
    unzip ../$SUWAYOMI_RELEASE_FILENAME &&\
    cd .. &&\
    # Get dependencies
    $JAVA_HOME/bin/jdeps \
        --ignore-missing-deps \
        --print-module-deps \
        -q \
        --recursive \
        --multi-release 17 \
        --class-path="./unpacked/BOOT-INF/lib/*" \
        --module-path="./unpacked/BOOT-INF/lib/*" \
        ./$SUWAYOMI_RELEASE_FILENAME >./deps.info &&\
    # Create JRE for our specific dependencies
    $JAVA_HOME/bin/jlink \
        --verbose \
        --add-modules $(cat ./deps.info) \
        --strip-debug \
        --no-man-pages \
        --no-header-files \
        --compress=2 \
        --output /suwa-jre-17

#Final image
FROM alpine:3.21.3

LABEL org.opencontainers.image.title="Suwayomi Container" \
    org.opencontainers.image.authors="https://github.com/mamotromico, https://github.com/suwayomi" \
    org.opencontainers.image.url="https://github.com/Mamotromico/Suwayomi-Server-podman/pkgs/container/swuayomi-server, https://github.com/Suwayomi/Suwayomi-Server-docker/pkgs/container/tachidesk" \
    org.opencontainers.image.source="https://github.com/Mamotromico/Suwayomi-Server-podman, https://github.com/Suwayomi/Suwayomi-Server-docker" \
    org.opencontainers.image.description="This image is used to start suwayomi server in a container, modified for better compatibility with rootless pods on podman" \
    org.opencontainers.image.vendor="mamotromico, suwayomi" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version=$SUWAYOMI_RELEASE_TAG \
    org.opencontainers.image.licenses="MPL-2.0" \
    suwayomi.docker_commit=$SUWAYOMI_DOCKER_GIT_COMMIT \
    suwayomi.release_tag=$SUWAYOMI_RELEASE_TAG \
    suwayomi.filename=$SUWAYOMI_RELEASE_FILENAME \
    suwayomi.download_url=$SUWAYOMI_RELEASE_DOWNLOAD_URL

ENV JAVA_HOME=/opt/jdk/jdk-17
ENV PATH="${JAVA_HOME}/bin:${PATH}"
ENV SUWAYOMI_RELEASE_FILENAME=$SUWAYOMI_RELEASE_FILENAME

COPY --from=jre-builder /suwa-jre-17 $JAVA_HOME
COPY --from=jre-builder /$SUWAYOMI_RELEASE_FILENAME /home/suwayomi

EXPOSE 4567
ENTRYPOINT java -jar /home/suwayomi/${SUWAYOMI_RELEASE_FILENAME}
