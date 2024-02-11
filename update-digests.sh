#!/bin/bash
json=$(cat VERSION.json)
upstream_image=$(jq -re '.upstream_image' <<< "${json}")
upstream_tag=$(jq -re '.upstream_tag' <<< "${json}")
manifest=$(skopeo inspect --raw "docker://${upstream_image}:${upstream_tag}") || exit 1
upstream_digest_amd64=$(jq -re '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest' <<< "${manifest}")
upstream_digest_arm64=$(jq -re '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest' <<< "${manifest}")
jq --sort-keys \
    --arg upstream_digest_amd64 "${upstream_digest_amd64}" \
    --arg upstream_digest_arm64 "${upstream_digest_arm64}" \
    '.upstream_digest_amd64 = $upstream_digest_amd64 | .upstream_digest_arm64 = $upstream_digest_arm64' <<< "${json}" | tee VERSION.json
