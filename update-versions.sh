#!/bin/bash

vuetorrent_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/wdaan/vuetorrent/releases/latest" | jq -r .tag_name | sed s/v//g)
[[ -z ${vuetorrent_version} ]] && exit 0
full_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -r '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"')
version=$(echo "${full_version}" | sed -e "s/release-//g" -e "s/_.*//g")
[[ -z ${version} ]] && exit 0
old_version=$(jq -r '.version' < VERSION.json)
changelog=$(jq -r '.changelog' < VERSION.json)
[[ "${old_version}" != "${version}" ]] && changelog="https://github.com/qbittorrent/qbittorrent/compare/release-${old_version}...release-${version}"
version_json=$(cat ./VERSION.json)
jq '.version = "'"${version}"'" | .full_version = "'"${full_version}"'" | .vuetorrent_version = "'"${vuetorrent_version}"'" | .changelog = "'"${changelog}"'"' <<< "${version_json}" > VERSION.json
