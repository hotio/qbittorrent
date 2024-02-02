ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 8080
ARG IMAGE_STATS
ENV IMAGE_STATS=${IMAGE_STATS} WEBUI_PORTS="8080/tcp,8080/udp"

RUN ln -s "${CONFIG_DIR}" "${APP_DIR}/qBittorrent"

ARG FULL_VERSION
RUN curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${FULL_VERSION}/x86_64-qbittorrent-nox" > "${APP_DIR}/qbittorrent-nox" && \
    chmod 755 "${APP_DIR}/qbittorrent-nox"

ARG VUETORRENT_VERSION
RUN curl -fsSL "https://github.com/vuetorrent/vuetorrent/releases/download/v${VUETORRENT_VERSION}/vuetorrent.zip" > "/tmp/vuetorrent.zip" && \
    unzip "/tmp/vuetorrent.zip" -d "${APP_DIR}" && \
    rm "/tmp/vuetorrent.zip" && \
    chmod -R u=rwX,go=rX "${APP_DIR}/vuetorrent"

ARG NIGHTWALKER_VERSION
RUN mkdir "${APP_DIR}/nightwalker" && \
    wget -O - "https://github.com/CallMeBruce/nightwalker/archive/${NIGHTWALKER_VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}/nightwalker" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}/nightwalker"

COPY root/ /
