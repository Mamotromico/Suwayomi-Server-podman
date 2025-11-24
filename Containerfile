# Build slim JRE for final image
FROM docker.io/eclipse-temurin:24-jdk-ubi10-minimal AS jre-builder

ARG SUWAYOMI_RELEASE_TAG
ARG SUWAYOMI_RELEASE_FILENAME
ARG SUWAYOMI_RELEASE_DOWNLOAD_URL
ARG BUILD_DATE
ARG GIT_COMMIT
ARG TINI_RELEASE_TAG

ADD $SUWAYOMI_RELEASE_DOWNLOAD_URL /$SUWAYOMI_RELEASE_FILENAME

RUN mkdir ./unpacked
RUN cd ./unpacked
RUN jar -xf /$SUWAYOMI_RELEASE_FILENAME
RUN cd ..
RUN $JAVA_HOME/bin/jdeps \
        --ignore-missing-deps \
        --print-module-deps \
        -q \
        --recursive \
        --multi-release 17 \
        --class-path="./unpacked/BOOT-INF/lib/*" \
        --module-path="./unpacked/BOOT-INF/lib/*" \
        /$SUWAYOMI_RELEASE_FILENAME >./deps.info
RUN $JAVA_HOME/bin/jlink \
        --add-modules $(cat ./deps.info),jdk.zipfs \
        --strip-debug \
        --no-man-pages \
        --no-header-files \
        --compress=2 \
        --output /suwa-jre-17

#Final image
FROM docker.io/redhat/ubi10-minimal:10.0

ARG SUWAYOMI_RELEASE_TAG
ARG SUWAYOMI_RELEASE_FILENAME
ARG SUWAYOMI_RELEASE_DOWNLOAD_URL
ARG BUILD_DATE
ARG GIT_COMMIT
ARG TINI_RELEASE_TAG

ADD https://github.com/krallin/tini/releases/download/${TINI_RELEASE_TAG}/tini /usr/local/bin/tini

WORKDIR /suwayomi

LABEL org.opencontainers.image.title="Suwayomi Container" \
    org.opencontainers.image.authors="https://github.com/mamotromico, https://github.com/suwayomi" \
    org.opencontainers.image.url="https://github.com/Mamotromico/Suwayomi-Server-podman/pkgs/container/swuayomi-server, https://github.com/Suwayomi/Suwayomi-Server-docker/pkgs/container/tachidesk" \
    org.opencontainers.image.source="https://github.com/Mamotromico/Suwayomi-Server-podman, https://github.com/Suwayomi/Suwayomi-Server-docker" \
    org.opencontainers.image.description="This image is used to start suwayomi server in a container, modified for better compatibility with rootless pods on podman" \
    org.opencontainers.image.vendor="mamotromico, suwayomi" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version=$SUWAYOMI_RELEASE_TAG \
    org.opencontainers.image.licenses="MPL-2.0" \
    suwayomi.docker_commit=$GIT_COMMIT \
    suwayomi.release_tag=$SUWAYOMI_RELEASE_TAG \
    suwayomi.filename=$SUWAYOMI_RELEASE_FILENAME \
    suwayomi.download_url=$SUWAYOMI_RELEASE_DOWNLOAD_URL

ENV JAVA_HOME=/opt/jdk/jdk-17/
ENV PATH="${JAVA_HOME}bin:${PATH}"

COPY --from=jre-builder /suwa-jre-17/ $JAVA_HOME
COPY --from=jre-builder /$SUWAYOMI_RELEASE_FILENAME suwayomi.jar
COPY ./suwayomi.sh /suwayomi/suwayomi.sh
RUN chmod +x /usr/local/bin/tini && \
    chmod +x /suwayomi/suwayomi.sh

EXPOSE 4567
ENTRYPOINT ["tini", "--"]
CMD ["/suwayomi/suwayomi.sh"]
