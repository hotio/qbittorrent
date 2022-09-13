#!/bin/bash

export DOCKER_CLI_EXPERIMENTAL=enabled
version_json=$(cat ./VERSION.json)
upstream_image=$(jq -r '.upstream_image' <<< "${version_json}")
upstream_tag=$(jq -r '.upstream_tag' <<< "${version_json}")
if [[ ${upstream_image} == null || ${upstream_tag} == null ]]; then
    jq '.upstream_image = "'"cr.hotio.dev/hotio/base"'" | .upstream_tag = "'"alpine"'"' <<< "${version_json}" > VERSION.json
    exit 0
fi
manifest=$(docker manifest inspect "${upstream_image}:${upstream_tag}")
[[ -z ${manifest} ]] && exit 1
upstream_digest_amd64=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest')
upstream_digest_arm64=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest')
jq '.upstream_digest_amd64 = "'"${upstream_digest_amd64}"'" | .upstream_digest_arm64 = "'"${upstream_digest_arm64}"'"' <<< "${version_json}" > VERSION.json
