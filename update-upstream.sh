#!/bin/bash
json=$(cat VERSION.json)
upstream_image=$(jq -re '.upstream_image' <<< "${json}")
upstream_image_base=$(basename "${upstream_image}")
upstream_tag=$(jq -re '.upstream_tag' <<< "${json}")
tags_json=$(curl -fsSL "https://hotio.dev/containers/${upstream_image_base}-tags.json") || exit 1
commit_sha=$(jq -r --arg tag "${upstream_tag}" '.[$tag].commit_sha' <<< "${tags_json}")
upstream_tag_sha=${upstream_tag}-${commit_sha:0:7}
jq --sort-keys \
    --arg upstream_tag_sha "${upstream_tag_sha}" \
    '.upstream_tag_sha = $upstream_tag_sha' <<< "${json}" | tee VERSION.json
