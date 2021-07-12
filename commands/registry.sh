#!/usr/bin/env bash

## author: KleiberXD

set -e

registry_help() {
    cat <<EOF

Manage local registry.

Usage:  kad registry [COMMAND] [OPTIONS]

Commands:
  clean    Remove all images from local registry
  init     Init local registry
  ls       List images from local registry
  mirror   Mirror image to the local registry, use image flag
  rm       Remove image from local registry, use image flag

Options:
      --debug   Enable debug mode
  -i, --image   Image name, including registry and tag

Run 'kad COMMAND --help' for more information about a given command.
EOF
}

clean_local_registry() {
    echo "clean"
}

init_local_registry() {
    if ! sudo docker top registry > /dev/null 2>&1; then
        echo "Starting registry ${DOCKER_REGISTRY}..."
        sudo docker run -d -p 5000:5000 --restart=always --name registry registry:2
    else
        echo "Registry ${DOCKER_REGISTRY} already exists"
    fi
}

list_images_from_registry() {
    docker image ls | grep ${DOCKER_REGISTRY} | awk 'BEGIN { printf "IMAGES\n"} { printf "%s:%s\n", $1, $2 }'
}

mirror_images_to_registry() {
    local images=("$@")

    echo "Mirroring images to ${DOCKER_REGISTRY}..."
    for image in "${images[@]}"; do
        echo "Mirroring image ${image}"
        docker pull ${image}
        docker tag ${image} ${DOCKER_REGISTRY}/${image}
        docker push ${DOCKER_REGISTRY}/${image}
    done
    echo "Image mirroring completed successfully"
}

remove_images_from_registry() {
    local images=("$@")

    echo "Removing images from ${DOCKER_REGISTRY}..."
    for image in "${images[@]}"; do
        echo "Removing image ${image}"
        docker image rm ${image}
    done
    echo "Images removal completed successfully"
}

registry_cmd() {
    local command=${1}

    # shift only if the command was not empty
    if [[ ${command} ]]; then
        shift
    fi

    # flag variables
    # we should use a hash table like "declare -A" flags and "${flags[key]}"
    # but MacOS does not support associative array introduces in bash version 4
    local debug=""
    local image=""

    # parse flags and put them in a hash table
    while [[ ${#} -gt 0 ]]; do
        local key=${1}
        case ${key} in
            --debug)
                debug="true"
                shift
                ;;
            --image | -i )
                if [[ ${2} && ${2} != *--* ]]; then
                    image=${2}
                    shift 2
                else
                    echo "Please provide a value for the --image flag."
                    exit 1
                fi
                ;;
            *)
                echo "Invalid parameter: ${key}."
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

    # run command
    case ${command} in
        clean)
            clean_local_registry
        init)
            init_local_registry
            ;;
        ls)
            list_images_from_registry
            ;;
        mirror)
            mirror_images_to_registry ${image}
            ;;
        rm)
            remove_images_from_registry ${image}
            ;;
        --help | -h | *)
            registry_help
            ;;
    esac
}