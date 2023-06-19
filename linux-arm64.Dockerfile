ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_ARM64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_ARM64}
EXPOSE 8080
ENV VPN_ENABLED="false" VPN_LAN_NETWORK="" VPN_CONF="wg0" VPN_ADDITIONAL_PORTS="" WEBUI_PORTS="8080/tcp,8080/udp" PRIVOXY_ENABLED="false" S6_SERVICES_GRACETIME=180000

VOLUME ["${CONFIG_DIR}"]

RUN apk add --no-cache privoxy iptables iproute2 openresolv wireguard-tools ipcalc && \
	apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing wireguard-go

COPY root/ /
RUN chmod -R +x /etc/cont-init.d/ /etc/services.d/ /etc/cont-finish.d/
