#!/usr/bin/env bash

## author: KleiberXD

set -e

docker_help() {
    cat <<EOF

Manage docker images.

Usage:  kad docker [OPTIONS]

Commands:
  build   Build image, use dockerfile flag
  clean   Remove all images and containers
  exec    Execute command inside container, use container and cmd flags in this order
  push    Push image to the local registry, use image and registry flags
  run     Run image container, use image and container flag

Options:
      --cmd          Command to execute
  -c, --container    Container name
      --debug        Enable debug mode
  -d, --dockerfile   Dockerfile directory path
  -i, --image        Image name
  -r, --registry     Docker Registry

Run 'kad COMMAND --help' for more information about a given command.
EOF
}

build_docker() {
    local dockerfile=${1}

    if [ -d ${dockerfile} ]; then
        echo "Building dockerfile at ${dockerfile}..."
        docker build ${dockerfile}
        echo "Build dockerfile completed successfully."
    else
        echo "Not found ${dockerfile} dockerfile."
    fi
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

exec_docker() {
    local container=${1}
    local cmd=${2}

    if docker top ${container} > /dev/null 2>&1; then
        echo "Exec ${cmd} command in ${container} container..."
        docker "exec" ${container} ${cmd}
        echo "Exec command completed successfully."
    else
        echo "Not found ${container} container."
    fi
}

push_docker() {
    local image=${1}
    local registry=${2}

    echo "Pushing ${image} image to ${registry} registry..."
    docker tag ${image} ${registry}/${image}
    docker push ${registry}/${image}
    echo "Push image completed successfully."
}

run_docker() {
    local image=${1}
    local container=${2}

    echo "Running ${container} container using ${image} image..."
    docker run --detach --rm --name ${container} ${image}
    echo "Run container completed successfully."
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
    local cmd=""
    local container=""
    local debug=""
    local dockerfile=""
    local image=""
    local registry=""

    # parse flags and put them in a hash table
    while [[ ${#} -gt 0 ]]; do
        local key=${1}
        case ${key} in
            --cmd)
                if [[ ${2} && ${2} != *-* ]]; then
                    shift 1
                    cmd="${@}"
                    shift $#
                else
                    echo "Please provide a value for the --cmd flag."
                    exit 1
                fi
                ;;
            --container | -c )
                if [[ ${2} && ${2} != *-* ]]; then
                    container=${2}
                    shift 2
                else
                    echo "Please provide a value for the --container flag."
                    exit 1
                fi
                ;;
            --image | -i )
                if [[ ${2} && ${2} != *-* ]]; then
                    image=${2}
                    shift 2
                else
                    echo "Please provide a value for the --image flag."
                    exit 1
                fi
                ;;
            --dockerfile | -d )
                if [[ ${2} && ${2} != *-* ]]; then
                    dockerfile=${2}
                    shift 2
                else
                    echo "Please provide a value for the --dockefile flag."
                    exit 1
                fi
                ;;
            --registry | -r )
                if [[ ${2} && ${2} != *-* ]]; then
                    registry=${2}
                    shift 2
                else
                    echo "Please provide a value for the --registry flag."
                    exit 1
                fi
                ;;
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
        build)
            not_required "--cmd" ${cmd}
            not_required "--container" ${container}
            not_required "--image" ${image}
            not_required "--registry" ${registry}
            required "--dockerfile" ${dockerfile}
            build_docker ${dockerfile}
            ;;
        clean)
            not_required "--cmd" ${cmd}
            not_required "--container" ${container}
            not_required "--dockerfile" ${dockerfile}
            not_required "--image" ${image}
            not_required "--registry" ${registry}
            clean_docker
            ;;
        exec)
            not_required "--dockerfile" ${dockerfile}
            not_required "--image" ${image}
            not_required "--registry" ${registry}
            required "--container" ${container}
            required "--cmd" ${cmd}
            exec_docker ${container} "${cmd}"
            ;;
        push)
            not_required "--cmd" ${cmd}
            not_required "--container" ${container}
            not_required "--dockerfile" ${dockefile}
            required "--image" ${image}
            required "--registry" ${registry}
            push_docker ${image} ${registry}
            ;;
        run)
            not_required "--cmd" ${cmd}
            not_required "--dockerfile" ${dockerfile}
            not_required "--registry" ${registry}
            required "--image" ${image}
            required "--container" ${container}
            run_docker ${image} ${container}
            ;;
        --help | -h | *)
            docker_help
            ;;
    esac
}
