#!/bin/bash
set -exuo pipefail

full_version_lib1=$(curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -re '. | "release-\(.qbittorrent)_v\(.libtorrent_1_2)"')
build_revision_lib1=$(curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${full_version_lib1}/dependency-version.json" | jq -re '.revision')
full_version_lib2=$(curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json" | jq -re '. | "release-\(.qbittorrent)_v\(.libtorrent_2_0)"')
build_revision_lib2=$(curl -fsSL "https://github.com/userdocs/qbittorrent-nox-static/releases/download/${full_version_lib2}/dependency-version.json" | jq -re '.revision')
version=$(sed -e "s/release-//g" -e "s/_.*//g" <<< "${full_version_lib1}")
json=$(cat VERSION.json)
jq --sort-keys \
    --arg version "${version//v/}" \
    --arg full_version_lib1 "${full_version_lib1}" \
    --arg build_revision_lib1 "${build_revision_lib1}" \
    --arg full_version_lib2 "${full_version_lib2}" \
    --arg build_revision_lib2 "${build_revision_lib2}" \
    '.version = $version | .full_version_lib1 = $full_version_lib1 | .build_revision_lib1 = $build_revision_lib1 | .full_version_lib2 = $full_version_lib2 | .build_revision_lib2 = $build_revision_lib2' <<< "${json}" | tee VERSION.json
