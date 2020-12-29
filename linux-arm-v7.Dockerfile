FROM ghcr.io/hotio/base@sha256:63541494a6b6e37e2913c1ebc0ee45a4d046965fb453bba5e8d2c688ba18463a

ARG DEBIAN_FRONTEND="noninteractive"

EXPOSE 8080

ARG VERSION

RUN mkdir "${APP_DIR}/.config" && ln -s "${CONFIG_DIR}/app" "${APP_DIR}/.config/qBittorrent"

RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        gnupg && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 7CA69FC4 && echo "deb http://ppa.launchpad.net/qbittorrent-team/qbittorrent-stable/ubuntu focal main" | tee /etc/apt/sources.list.d/qbitorrent.list && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        qbittorrent-nox=${VERSION} && \
# clean up
    apt purge -y gnupg && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY root/ /
