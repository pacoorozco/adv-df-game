#!/usr/bin/env bash
#
# sudo apt install jq wget curl
# usage: github-install [--branch|--tagged]

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

TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp/}$(basename "$0").XXXXXXXXXXXX")

FOLDER_INSIDE_ZIP_FILE=gamify-laravel-main

SOURCES_TO_SYNC=(app config lang server.php artisan composer.json resources bootstrap composer.lock database public routes)

readonly REPO
readonly TEMP_DIR
readonly FOLDER_INSIDE_ZIP_FILE
readonly SOURCES_TO_SYNC

update_from_tag() {
    local -r tag_name=$1

    local -r url="https://api.github.com/repos/${REPO}/releases/${tag_name}"

    local filename
    filename=$(curl -s "${url}" | jq -r '.assets[].name')

    echo "Downloading tag '${tag_name}' to ${filename}..."
    [ -e "${TEMP_DIR}/${filename}" ] && rm "${TEMP_DIR}/${filename}"

    curl --silent "${url}" | jq -r --arg filename "${filename}" '.assets[] | select(.name == $filename) | .browser_download_url' | wget --input-file=- --quiet --show-progress --directory-prefix="${TEMP_DIR}"

    extract_files "${TEMP_DIR}/${filename}" "${TEMP_DIR}/${FOLDER_INSIDE_ZIP_FILE}"

    update_files "${TEMP_DIR}/${FOLDER_INSIDE_ZIP_FILE}"
}

update_from_branch() {
    local branch_name=$1

    local url="http://github.com/${REPO}/archive/${branch_name}.zip"

    local filename=${branch_name}.zip

    echo "Downloading branch '${branch_name}' to ${filename}..."
    [ -e "${TEMP_DIR}/${filename}" ] && rm "${TEMP_DIR}/${filename}"

    wget --quiet --show-progress --directory-prefix="${TEMP_DIR}" "${url}"

    extract_files "${TEMP_DIR}/${filename}" "${TEMP_DIR}"

    update_files "${TEMP_DIR}/${FOLDER_INSIDE_ZIP_FILE}"
}

update_from_zip() {
    local -r zip_file=$1

    extract_files "${zip_file}" "${TEMP_DIR}"

    update_files "${TEMP_DIR}/${zip_file%.zip}"
}

extract_files() {
    local -r zip_file=$1
    local -r target=$2

    echo "Extracting files to ${target}..."
    unzip -q -o -d "${target}" "${zip_file}"
}

update_files() {
    local -r source_dir=$1

    for source in "${SOURCES_TO_SYNC[@]}"; do
        echo "Updating ${source}..."
        cp -apr "${source_dir}/${source}" .
    done
}

main() {

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
