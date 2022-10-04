#!/usr/bin/env bash
#
# sudo apt install jq wget curl
# usage: github-install user/repo

REPO=pacoorozco/gamify-laravel

##########################################################################
# DO NOT MODIFY BEYOND THIS LINE
##########################################################################
# Script exits immediately if any command within it exits with a non-zero status
set -o errexit
# Script will catch the exit status of a previous command in a pipe.
set -o pipefail
# Script exits immediately if tries to use an undeclared variables.
set -o nounset
# Uncomment this to enable debug
# set -o xtrace

TEMP_DIR=/tmp/gh-install

readonly REPO
readonly TEMP_DIR

update_from_tag() {
    local tag_name=$1

    local url="https://api.github.com/repos/${REPO}/releases/${tag_name}"
    echo "Reading... ${url}"

    local filename
    filename=$(curl -s "${url}" | jq -r '.assets[].name')

    [ -e "/tmp/gh-install/${filename}" ] && rm "${TEMP_DIR}/${filename}"
    echo "Downloading... ${filename}"

    curl --silent "${URL}" | jq -r --arg filename "${filename}" '.assets[] | select(.name == $filename) | .browser_download_url' | wget -i- -q --show-progress -P ${TEMP_DIR}

    unzip -q -o "${TEMP_DIR}/${filename}" -x "tests/*" "storage/*" "README.md" "CONTRIBUTE.md" "CODE_OF_CONDUCT.md" "dist/*"
    [ -e "${filename}" ] && rm "${filename}"
}

update_from_branch() {
    local branch_name=$1

    local url="http://github.com/${REPO}/archive/${branch_name}.zip"

    local filename=${branch_name}.zip
    [ -e "${TEMP_DIR}/${filename}" ] && rm "${TEMP_DIR}/${filename}"
    echo "Downloading... ${filename}"

    curl --silent --location "${url}" --output "${TEMP_DIR}/${filename}"

    update_files "${TEMP_DIR}/${filename}"
    #[ -e "${filename}" ] && rm "${filename}"

}

update_files() {
    local -r zip_file=$1

    unzip -q -o "${zip_file}"

    sources_to_copy=(app config lang server.php artisan composer.json resources bootstrap composer.lock database public routes)

    for source in "${sources_to_copy[@]}"; do
        echo "Updating ${source}..."
        cp -apr "${source}" .
    done
}

main() {

    mkdir -p ${TEMP_DIR}

    while [ $# -gt 0 ]; do

        case $1 in
        -t | --tagged)
            update_from_tag latest
            exit
            ;;
        -b | --branch)
            update_from_branch main
            exit
            ;;
        --) # End of all options.
            shift
            break
            ;;
        -?*)
            echo "Unknown option (ignored): $1"
            ;;
        *) # Default case: No more options, so break out of the loop.
            break
            ;;
        esac

        shift

    done
}

##########################################################################
# Main code
##########################################################################

main "${@}"
