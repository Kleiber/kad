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

uninstall_golang() {
    if [ -f /usr/local/bin/helm ]; then
        echo "Uninstalling golang..."
        sudo rm -rf /usr/local/go
        echo "Successfully uninstalled golang."
    else
        echo "Nothing to uninstall."
    fi
}

uninstall_helm() {
    if [ -f /usr/local/bin/helm ]; then
        echo "Uninstalling helm..."
        sudo rm /usr/local/bin/helm
        echo "Successfully uninstalled helm."
    else
        echo "Nothing to uninstall."
    fi
}

uninstall_kubectl() {
    if [ -f /usr/local/bin/kubectl ]; then
        echo "Uninstalling kubectl..."
        sudo rm /usr/local/bin/kubectl
        echo "Successfully uninstalled kubectl."
    else
        echo "Nothing to uninstall."
    fi
}

uninstall_k3s() {
    if [ -f /usr/local/bin/k3s-uninstall.sh ]; then
        echo "Uninstalling k3s..."
        /usr/local/bin/k3s-uninstall.sh || true
        echo "Successfully uninstalled k3s."
    else
        echo "Nothing to uninstall."
    fi
}

uninstall_cmd() {
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
        golang)
            uninstall_golang
            ;;
        helm)
            uninstall_helm
            ;;
        kubectl)
            uninstall_kubectl
            ;;
        k3s)
            uninstall_k3s
            ;;
        --help | -h | *)
            uninstall_help
            ;;
    esac
}

