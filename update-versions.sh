#!/bin/bash
set -exuo pipefail

full_version=$(curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static-legacy/releases/latest/download/dependency-version.json" | jq -re '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"')
version=$(sed -e "s/release-//g" -e "s/_.*//g" <<< "${full_version}")
build_revision=$(curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static-legacy/releases/download/${full_version}/dependency-version.json" | jq -re '.revision')
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg full_version "${full_version}" \
    --arg build_revision "${build_revision}" \
    '.version = $version | .full_version = $full_version | .build_revision = $build_revision' <<< "${json}" | tee VERSION.json
