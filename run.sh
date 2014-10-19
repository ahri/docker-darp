#!/bin/sh

set -ue

name=$(cat NAME)
version=$(cat VERSION)

docker run -d \
    --name darp \
    --restart="always" \
    -p 80:80 \
    "$@" \
    $name:$version \
    home.ahri.net
