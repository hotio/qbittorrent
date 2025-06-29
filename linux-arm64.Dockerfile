ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_ARM64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_ARM64}
EXPOSE 8080
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="8080/tcp,8080/udp" LIBTORRENT="v1"

RUN ln -s "${CONFIG_DIR}" "${APP_DIR}/qBittorrent"

ARG FULL_VERSION_LIB1
ARG BUILD_REVISION_LIB1
ARG FULL_VERSION_LIB2
ARG BUILD_REVISION_LIB2
RUN curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${FULL_VERSION_LIB1}/aarch64-qbittorrent-nox" > "${APP_DIR}/qbittorrent-nox-lib1" && \
    chmod 755 "${APP_DIR}/qbittorrent-nox-lib1" && \
    curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${FULL_VERSION_LIB2}/aarch64-qbittorrent-nox" > "${APP_DIR}/qbittorrent-nox-lib2" && \
    chmod 755 "${APP_DIR}/qbittorrent-nox-lib2"

COPY root/ /
