#!/usr/bin/env bash

## author: KleiberXD

set -e

docker_help() {
    cat <<EOF

Manage docker images.

Usage:  kad deploy [OPTIONS]

Commands:
  build   Build image, use image flag
  clean   Remove all images and containers
  exec    Execute command inside image container, use image and command flags
  push    Push image to the local registry, use image flag
  run     Run image container, use image flag

Options:
  -c, --command   Command to execute
      --debug     Enable debug mode
  -i, --image     Deployment name

Run 'kad COMMAND --help' for more information about a given command.
EOF
}

clean_docker() {
    local number_containers=$(docker container ls --quiet | wc -l)
    local number_images=$(docker images --quiet | wc -l)

    echo "Cleaning docker..."

    if [[ ${number_containers} > 0 ]]; then
        echo "Removing containers from docker..."
        docker rm --force $(docker ps --all --quiet)
        echo "Removing containers completed successfully."
    fi

    if [[ ${number_images} > 0 ]]; then
        echo "Removing images from docker..."
        docker rmi --force $(docker images --all --quiet)
        echo "Removing images completed successfully."
    fi

    echo "Cleaning docker completed successfully."
}

docker_cmd() {
    local command=${1}

    # shift only if the command was not empty
    if [[ ${command} ]]; then
        shift
    fi

    # flag variables
    # we should use a hash table like "declare -A" flags and "${flags[key]}"
    # but MacOS does not support associative array introduces in bash version 4
    local debug=""

    # parse flags and put them in a hash table
    while [[ ${#} -gt 0 ]]; do
        local key=${1}
        case ${key} in
            --debug)
                debug="true"
                shift
                ;;
            *)
                echo "Invalid command: ${key}."
                exit 1
                ;;
            -*)
                echo "Invalid flag: ${key}."
                exit 1
                ;;
        esac
    done

    # set debug if desired
    if [[ ${debug} == "true" ]]; then
        set -x
    fi

    case ${command} in
        clean)
            clean_docker
            ;;
        --help | -h | *)
            docker_help
            ;;
    esac
}

