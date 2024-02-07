#!/bin/bash
set -e
nightwalker_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/CallMeBruce/nightwalker/commits/main" | jq -re .sha)
vuetorrent_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/vuetorrent/vuetorrent/releases/latest" | jq -re .tag_name)
full_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -re '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"')
version=$(sed -e "s/release-//g" -e "s/_.*//g" <<< "${full_version}")
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg full_version "${full_version}" \
    --arg vuetorrent_version "${vuetorrent_version}" \
    --arg nightwalker_version "${nightwalker_version}" \
    '.version = $version | .full_version = $full_version | .vuetorrent_version = $vuetorrent_version | .nightwalker_version = $nightwalker_version' <<< "${json}" | tee VERSION.json
