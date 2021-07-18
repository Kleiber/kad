#!/usr/bin/env bash

## author: KleiberXD

set -e

deploy_help() {
    cat <<EOF

Manage deployments.

Usage:  kad deploy [OPTIONS]

Commands:
  get         Get chart values, use name flag
  install     Instal helm deployment, use chart flag
  uninstall   Uninstall helm deployment, use name flag
  upgrade     Upgrade helm deployment, use chart flag

Options:
      --debug   Enable debug mode
  -n, --name    Deploy name
  -c, --chart   Chart filepath

Run 'kad COMMAND --help' for more information about a given command.
EOF
}

deploy_cmd() {
    case ${1} in
        --help|-h|*)
            deploy_help
            ;;
    esac
}

