#!/usr/bin/env bash

## author: KleiberXD

set -e

uninstall_help() {
    cat <<EOF

Uninstall tools.

Usage:  kad uninstall [OPTIONS]

Commands:
  golang    Uninstall golang
  helm      Uninstall helm client
  kubectl   Uninstall kubectl client
  k3s       Uninstall k3s lightweight kubernetes

Options:
  --debug   Enable debug mode

Run 'kad COMMAND --help' for more information about a given command.
EOF
}

uninstall_cmd() {
    local os_type=$(get_os_type)

    case ${1} in
        --help|-h|*)
            uninstall_help
            ;;
    esac
}