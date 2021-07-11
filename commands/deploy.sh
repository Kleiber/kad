#!/usr/bin/env bash
set -e

deploy_help() {
    cat <<EOF

Manage deployments.

Usage:  kad deploy [OPTIONS]

Commands:
  get         Get chart values
  install     Instal helm deployment by chart
  uninstall   Uninstall helm deployment

Options:
      --debug       Enable debug mode
  -r, --namespace   Deployment name

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