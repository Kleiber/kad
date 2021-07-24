#!/usr/bin/env bash

## author: KleiberXD

set -e

deploy_help() {
    cat <<EOF

Manage deployments.

Usage:  kad deploy [OPTIONS]

Commands:
  get         Get chart values, use name flag
  install     Install helm deployment, use name and chart flag
  ls          List all deploys
  uninstall   Uninstall helm deployment, use name flag
  upgrade     Upgrade helm deployment, use name and chart flag

Options:
      --debug   Enable debug mode
  -n, --name    Deploy name
  -c, --chart   Chart directory with values.yaml file

Run 'kad COMMAND --help' for more information about a given command.
EOF
}

deploy_get() {
    local chart_name=${1}
    if ! helm get values ${chart_name} > /dev/null 2>&1; then
        echo "Deploy ${chart_name} not found"
    else
        helm get values ${chart_name}
    fi
}

deploy_install() {
    local name=${1}
    local chart_path=${2}
    echo "Deploying ${name} from ${chart_path} chart..."
    helm install ${name} ${chart_path} \
        --values ${chart_path}/values.yaml \
        --create-namespace \
        --namespace ${NAMESPACE}
    echo "Deploy ${name} completed successfully."
}

deploy_list() {
    if ! helm ls -A > /dev/null 2>&1; then
        echo "Nothing to list."
    else
        helm ls -A
    fi
}

deploy_uninstall() {
    local name=${1}
    echo "Undeploying ${name} deploy..."
    helm uninstall --no-hooks ${name}
    kubectl delete pvc --all -n ${NAMESPACE}
    kubectl delete pv --all -n ${NAMESPACE}
    kubectl delete secret --all -n ${NAMESPACE}
    kubectl delete configmap --all -n ${NAMESPACE}
    if [[ ${NAMESPACE} != "default" ]]; then
        kubectl delete ns ${NAMESPACE}
    fi
    echo "Undeploy ${name} completed successfully."
}

deploy_upgrade() {
    local name=${1}
    local chart_path=${2}
    echo "Upgrading deploy ${name} with ${chart_path} chart..."
    helm upgrade ${name} ${chart} \
        --values ${chart_path}/values.yaml \
        --create-namespace \
        --namespace ${NAMESPACE} \
        --install
    echo "Upgrade ${name} completed successfully."
}

deploy_cmd() {
    local command=${1}

    # shift only if the command was not empty
    if [[ ${command} ]]; then
        shift
    fi

    # flag variables
    # we should use a hash table like "declare -A" flags and "${flags[key]}"
    # but MacOS does not support associative array introduces in bash version 4
    local chart=""
    local debug=""
    local name=""

    # parse flags and put them in a hash table
    while [[ ${#} -gt 0 ]]; do
        local key=${1}
        case ${key} in
            --chart | -c)
                if [[ ${2} && ${2} != -* ]]; then
                    chart=${2}
                    shift 2
                else
                    echo "Please provide a value for the --chart flag."
                    exit 1
                fi
                ;;
            --name | -n )
                if [[ ${2} && ${2} != -* ]]; then
                    name=${2}
                    shift 2
                else
                    echo "Please provide a value for the --name flag."
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
        get)
            not_required "--chart" ${chart}
            required "--name" ${name}
            deploy_get ${name}
            ;;
        install)
            required "--name" ${name}
            required "--chart" ${chart}
            deploy_install ${name} ${chart}
            ;;
        ls)
            not_required "--chart" ${chart}
            not_required "--name" ${name}
            deploy_list
            ;;
        uninstall)
            required "--name" ${name}
            not_required "--chart" ${chart}
            deploy_uninstall ${name}
            ;;
        upgrade)
            required "--name" ${name}
            required "--chart" ${chart}
            deploy_upgrade ${name} ${chart}
            ;;
        --help | -h | *)
            deploy_help
            ;;
    esac
}

