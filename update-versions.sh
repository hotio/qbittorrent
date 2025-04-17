#!/bin/bash
full_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -re '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"') || exit 1
version=$(sed -e "s/release-//g" -e "s/_.*//g" <<< "${full_version}")
[[ -z ${version} ]] && exit 0
[[ ${version} == null ]] && exit 0
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg full_version "${full_version}" \
    '.version = $version | .full_version = $full_version' <<< "${json}" | tee VERSION.json
