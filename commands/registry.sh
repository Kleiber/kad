#!/usr/bin/env bash
set -e

registry_help() {
    cat <<EOF

Manage registries.

Usage:  kad registry [OPTIONS]

Commands:
  init     Init local registry
  list     List registry images
  mirror   Mirror image to the registry

Options:
      --debug      Enable debug mode
  -r, --registry   Docker registry

Run 'kad COMMAND --help' for more information about a given command.
EOF
}

registry_cmd() {
    case ${1} in
        --help|-h|*)
            registry_help
            ;;
    esac
}