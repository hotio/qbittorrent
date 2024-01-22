ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_ARM64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_ARM64}
EXPOSE 8080
ENV VPN_ENABLED="false" VPN_PROVIDER="generic" VPN_LAN_NETWORK="" VPN_CONF="wg0" VPN_ADDITIONAL_PORTS="" WEBUI_PORTS="8080/tcp,8080/udp" PRIVOXY_ENABLED="false" S6_SERVICES_GRACETIME=180000 S6_STAGE2_HOOK="/init-hook"

VOLUME ["${CONFIG_DIR}"]

RUN ln -s "${CONFIG_DIR}" "${APP_DIR}/qBittorrent"

RUN apk add --no-cache privoxy iptables ip6tables iproute2 openresolv wireguard-tools ipcalc && \
    apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing wireguard-go && \
    apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community libnatpmp

ARG FULL_VERSION

RUN curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static-legacy/releases/download/${FULL_VERSION}/aarch64-qbittorrent-nox" > "${APP_DIR}/qbittorrent-nox" && \
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
RUN chmod +x /init-hook
