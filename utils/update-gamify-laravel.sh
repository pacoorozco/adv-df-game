#!/usr/bin/env bash
#
# sudo apt install jq wget curl
# usage: github-install user/repo
set -e

REPO=pacoorozco/gamify-laravel

mkdir -p /tmp/gh-install
URL="https://api.github.com/repos/${REPO}/releases/latest"
echo "Reading... ${URL}"

FILENAME=$(curl -s "${URL}" | jq -r '.assets[].name')
[ -e "/tmp/gh-install/${FILENAME}" ] && rm "/tmp/gh-install/${FILENAME}"
echo "Downloading... ${FILENAME}"

curl -s "${URL}" | jq -r --arg filename "${FILENAME}" '.assets[] | select(.name == $filename) | .browser_download_url' | wget -i- -q --show-progress -P /tmp/gh-install

unzip -q -o "/tmp/gh-install/${FILENAME}" -x "tests/*" "storage/*" "README.md" "CONTRIBUTE.md" "CODE_OF_CONDUCT.md" "dist/*"
[ -e "${FILENAME}" ] && rm "${FILENAME}"


