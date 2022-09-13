#!/bin/bash

if [[ -z ${1} ]]; then
    echo "Usage: ./build.sh amd64"
    echo "       ./build.sh arm64"
    exit 1
fi

image=$(basename "$(git rev-parse --show-toplevel)")
docker build -f "./linux-${1}.Dockerfile" -t "${image}-${1}" $(for i in $(jq -r 'to_entries[] | [(.key | ascii_upcase),.value] | join("=")' < VERSION.json); do out+="--build-arg $i " ; done; echo $out;out="") .
