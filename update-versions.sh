#!/bin/bash
nightwalker_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/CallMeBruce/nightwalker/commits/main" | jq -re .sha) || exit 1
vuetorrent_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/vuetorrent/vuetorrent/releases/latest" | jq -re .tag_name) || exit 1
full_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static-legacy/releases/latest/download/dependency-version.json" | jq -re '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"') || exit 1
version=$(sed -e "s/release-//g" -e "s/_.*//g" <<< "${full_version}")
[[ -z ${version} ]] && exit 0
[[ ${version} == null ]] && exit 0
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg full_version "${full_version}" \
    --arg vuetorrent_version "${vuetorrent_version//v/}" \
    --arg nightwalker_version "${nightwalker_version//v/}" \
    '.version = $version | .full_version = $full_version | .vuetorrent_version = $vuetorrent_version | .nightwalker_version = $nightwalker_version' <<< "${json}" | tee VERSION.json
