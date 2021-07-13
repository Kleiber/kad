#!/usr/bin/env bash

## author: KleiberXD

set -e

registry_help() {
    cat <<EOF

Manage local registry.

Usage:  kad registry [COMMAND] [OPTIONS]

Commands:
  clean    Remove all images from local registry
  down     Delete local registry
  init     Init local registry
  ls       List images from local registry
  mirror   Mirror image to the local registry
  rm       Remove image from local registry

Options:
      --debug   Enable debug mode
  -i, --image   Image name, including registry and tag

Run 'kad COMMAND --help' for more information about a given command.
EOF
}

required() {
    local flag=${1}
    local value=${2}
    if [[ ! ${value} ]]; then
        echo "Requires the use of the ${flag} flag."
        exit 1
    fi
}

not_required() {
    local flag=${1}
    local value=${2}
    if [[ ${value} ]]; then
        echo "Not require the use of the ${flag} flag."
        exit 1
    fi
}

clean_local_registry() {
    if ! docker images | grep ${DOCKER_REGISTRY} >/dev/null 2>&1; then
        echo "Nothing to clean from ${DOCKER_REGISTRY} registry."
        exit 1
    fi

    echo "Cleaning ${DOCKER_REGISTRY} registry..."

    local images_ids=$(docker images | grep ${DOCKER_REGISTRY} | awk '{ printf "%s\n", $3 }')

    echo "Removing containers using a registry image..."
    for image_id in ${images_ids}; do
        if ! docker ps --filter ancestor=${image_id} >/dev/null 2>&1; then
            docker rm -f $(docker ps --quiet --filter ancestor=${image_id})
        fi
    done
    echo "Removing containers completed successfully."

    echo "Removing dependent child images using a registry image..."
    for image_id in ${images_ids}; do
        if ! docker images --filter since=${image_id} >/dev/null 2>&1; then
            docker inspect --format='{{.Id}} {{.Parent}}' $(docker images --quiet --filter since=${image_id}) | \
                cut -d' ' -f1 | \
                cut -d: -f2 | \
                xargs docker rmi
        fi
    done
    echo "Removing dependent child images completed successfully."

    echo "Removing images from registry..."
    for image_id in ${images_ids}; do
        docker rmi --force ${image_id}
    done
    echo "Removing images completed successfully."

    echo "Cleaning registry completed successfully."
}

down_local_registry() {
    if ! docker top registry > /dev/null 2>&1; then
        echo "Registry ${DOCKER_REGISTRY} was not initialized."
        exit 1
    fi

    echo "Deleting registry ${DOCKER_REGISTRY}..."
    docker rm -f $(docker container ls | grep registry | awk '{ printf "%s\n", $1 }')
    echo "Deleting registry completed successfully."
}

init_local_registry() {
    if docker top registry > /dev/null 2>&1; then
        echo "Registry ${DOCKER_REGISTRY} already exists."
        exit 1
    fi

    echo "Starting registry ${DOCKER_REGISTRY}..."
    docker run -d -p 5000:5000 --restart=always --name registry registry:2
    echo "Starting registry completed successfully."
}

list_images_from_registry() {
    if ! docker images | grep ${DOCKER_REGISTRY} >/dev/null 2>&1; then
        echo "Nothing to list from ${DOCKER_REGISTRY} registry."
        exit 1
    fi

    docker image ls | grep ${DOCKER_REGISTRY} | awk 'BEGIN { printf "REGISTRY/IMAGE TAG\n"} {print $1, $2}' | column -t
}

mirror_images_to_registry() {
    local image=${1}

    echo "Mirroring image ${image} to ${DOCKER_REGISTRY} registry..."
    docker pull ${image}
    docker tag ${image} ${DOCKER_REGISTRY}/${image}
    docker push ${DOCKER_REGISTRY}/${image}
    echo "Image mirroring completed successfully."
}

remove_images_from_registry() {
    local image=${1}

    if ! docker images | grep ${DOCKER_REGISTRY}/${image} >/dev/null 2>&1; then
        echo "Not found Image ${image} in the ${DOCKER_REGISTRY} registry."
        exit 1
    fi

    local image_id=$(docker images | grep ${DOCKER_REGISTRY}/${image} | awk '{ printf "%s\n", $3 }')

    echo "Removing containers using ${image} image..."
    if ! docker ps --filter ancestor=${image_id} >/dev/null 2>&1; then
        docker rm -f $(docker ps --quiet --filter ancestor=${image_id}})
    fi
    echo "Removing containers completed successfully."

    echo "Removing dependent child images using ${image} image..."
    if ! docker images --filter since=${image_id} >/dev/null 2>&1; then
        docker inspect --format='{{.Id}} {{.Parent}}' $(docker images --quiet --filter since=${image_id}) | \
            cut -d' ' -f1 | \
            cut -d: -f2 | \
            xargs docker rmi
    fi
    echo "Removing dependent child images completed successfully."

    echo "Removing image ${image} from ${DOCKER_REGISTRY} registry..."
    docker image rmi -f ${image_id}
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

    # run command
    case ${command} in
        clean)
            not_required "--image" ${image}
            clean_local_registry
            ;;
        down)
            not_required "--image" ${image}
            down_local_registry
            ;;
        init)
            not_required "--image" ${image}
            init_local_registry
            ;;
        ls)
            not_required "--image" ${image}
            list_images_from_registry
            ;;
        mirror)
            required "--image" ${image}
            mirror_images_to_registry ${image}
            ;;
        rm)
            required "--image" ${image}
            remove_images_from_registry ${image}
            ;;
        --help | -h | *)
            registry_help
            ;;
    esac
}