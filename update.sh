#!/bin/bash

if [[ ${1} == "checkdigests" ]]; then
    export DOCKER_CLI_EXPERIMENTAL=enabled
    image="cr.hotio.dev/hotio/base"
    tag="alpine"
    manifest=$(docker manifest inspect ${image}:${tag})
    [[ -z ${manifest} ]] && exit 1
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-amd64.Dockerfile  && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}.*\$#FROM ${image}@${digest}#g" ./linux-arm64.Dockerfile  && echo "${digest}"
elif [[ ${1} == "tests" ]]; then
    echo "List installed packages..."
    docker run --rm --entrypoint="" "${2}" apk -vv info | sort
    echo "Check if app works..."
    app_url="http://localhost:8080"
    docker run --network host -d --name service "${2}"
    currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL "${app_url}" > /dev/null) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done
    curl -fsSL "${app_url}" > /dev/null
    status=$?
    echo "Show docker logs..."
    docker logs service
    exit ${status}
elif [[ ${1} == "screenshot" ]]; then
    app_url="http://localhost:8080"
    docker run --rm --network host -d --name service "${2}"
    currenttime=$(date +%s); maxtime=$((currenttime+60)); while (! curl -fsSL "${app_url}" > /dev/null) && [[ "$currenttime" -lt "$maxtime" ]]; do sleep 1; currenttime=$(date +%s); done
    docker run --rm --network host --entrypoint="" -u "$(id -u "$USER")" -v "${GITHUB_WORKSPACE}":/usr/src/app/src zenika/alpine-chrome:with-puppeteer node src/puppeteer.js
    exit 0
else
    vuetorrent_version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/wdaan/vuetorrent/releases/latest" | jq -r .tag_name | sed s/v//g)
    [[ -z ${vuetorrent_version} ]] && exit 1
    qbts_latest_release="$(curl -fsSL https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/dependency-version.json | jq -r '.qbittorrent')"
    full_version="$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/userdocs/qbittorrent-nox-static/releases" | jq -r 'first(.[] | select(.tag_name | contains ("release-'"${qbts_latest_release}"'_v1.2.")) | .tag_name)')"
    version=$(echo "${full_version}" | sed -e "s/release-//g" -e "s/_.*//g")
    [[ -z ${version} ]] && exit 1
    old_version=$(jq -r '.version' < VERSION.json)
    changelog=$(jq -r '.changelog' < VERSION.json)
    [[ "${old_version}" != "${version}" ]] && changelog="https://github.com/qbittorrent/qbittorrent/compare/release-${old_version}...release-${version}"
    echo '{"version":"'"${version}"'","full_version":"'"${full_version}"'","vuetorrent_version":"'"${vuetorrent_version}"'","changelog":"'"${changelog}"'"}' | jq . > VERSION.json
fi
