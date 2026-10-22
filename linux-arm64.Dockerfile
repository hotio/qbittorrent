# syntax=docker/dockerfile:1
# check=skip=InvalidDefaultArgInFrom
ARG UPSTREAM_IMAGE
ARG UPSTREAM_TAG_SHA

FROM ${UPSTREAM_IMAGE}:${UPSTREAM_TAG_SHA}
EXPOSE 8080
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="8080/tcp" LIBTORRENT="v2"

RUN ln -s "${CONFIG_DIR}" "${APP_DIR}/qBittorrent"

ARG VERSION_LIB1
ARG VERSION_LIB2
RUN curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${VERSION_LIB1%%/*}/aarch64-qbittorrent-nox" > "${APP_DIR}/qbittorrent-nox-lib1" && \
    chmod 755 "${APP_DIR}/qbittorrent-nox-lib1" && \
    curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${VERSION_LIB2%%/*}/aarch64-qbittorrent-nox" > "${APP_DIR}/qbittorrent-nox-lib2" && \
    chmod 755 "${APP_DIR}/qbittorrent-nox-lib2"

COPY root/ /
RUN find /etc/s6-overlay/s6-rc.d -name "run*" -execdir chmod +x {} +
