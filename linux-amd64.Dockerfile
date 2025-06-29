ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 8080
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="8080/tcp,8080/udp"

RUN ln -s "${CONFIG_DIR}" "${APP_DIR}/qBittorrent"

ARG FULL_VERSION
ARG BUILD_REVISION
RUN curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static-legacy/releases/download/${FULL_VERSION}/x86_64-qbittorrent-nox" > "${APP_DIR}/qbittorrent-nox" && \
    chmod 755 "${APP_DIR}/qbittorrent-nox"

COPY root/ /
