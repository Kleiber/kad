#!/usr/bin/env bash
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

docker_cmd() {
    case ${1} in
        --help|-h|*)
            docker_help
            ;;
    esac
}