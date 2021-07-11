#!/usr/bin/env bash
set -e

export COMMANDS_DIR="$(cd "$(dirname "${BASH_SOURCE-$0}")" && pwd)"

source ${COMMANDS_DIR}/../common/common.sh
source ${COMMANDS_DIR}/../common/util.sh

install_help() {
    cat <<EOF

Install tools.

Usage:  kad install [OPTIONS]

Commands:
  golang    Install golang
  helm      Install helm client
  kubectl   Install kubectl client
  k3s       Install k3s lightweight kubernetes

Options:
      --debug     Enable debug mode
  -v, --version   Show the kad version information

Run 'kad COMMAND --help' for more information about a given command.
EOF
}

golang_install() {
    local os_type=${1}
    local version=${GOLANG_VERSION}
    local url=https://dl.google.com/go/go${version}.${os_type}-amd64.tar.gz

    echo "Installing golang version ${version} for ${os_type} OS..."

    if [[ "${os_type}" == "linux"* || "${os_type}" == "darwin"* ]]; then
        if [[ $(is_valid_url ${url}) ]]; then
            curl -LO --silent ${url}
            sudo rm -rf /usr/local/go
            tar xf go${version}.${os_type}-amd64.tar.gz
            sudo mv ./go /usr/local
            rm go${version}.${os_type}-amd64.tar.gz
            echo "Golang version ${version} was installed successfully."
        else
            echo "Not found the requested golang version ${version}"
        fi
    else
        echo "Host OS is not Linux or MacOS."
    fi
}

helm_install() {
    local os_type=${1}
    local version=${HELM_VERSION}
    local url=https://get.helm.sh/helm-${version}-${os_type}-amd64.tar.gz

    echo "Installing helm version ${version} for ${os_type} OS..."

    if [[ "${os_type}" == "linux"* || "${os_type}" == "darwin"* ]]; then
        if [[ $(is_valid_url ${url}) ]]; then
            curl -LO --silent ${url}
            tar xf helm-${version}-${os_type}-amd64.tar.gz
            chmod +x ${os_type}-amd64/helm
            sudo mv ${os_type}-amd64/helm /usr/local/bin/helm
            rm -rf ${os_type}-amd64
            rm helm-${version}-${os_type}-amd64.tar.gz
            echo "Helm version ${version} was installed successfully."
        else
            echo "Not found the requested helm version ${version}"
        fi
    else
        echo "Host OS is not Linux or MacOS."
    fi
}

kubectl_install() {
    local os_type=${1}
    local version=${KUBECTL_VERSION}
    local url=https://storage.googleapis.com/kubernetes-release/release/${version}/bin/${os_type}/amd64/kubectl

    echo "Installing kubectl version ${version} for ${os_type} OS..."

    if [[ "${os_type}" == "linux"* || "${os_type}" == "darwin"* ]]; then
        if [[ $(is_valid_url ${url}) ]]; then
            curl -LO --silent ${url}
            chmod +x ./kubectl
            sudo mv ./kubectl /usr/local/bin/kubectl
            echo "Kubectl version ${version} was installed successfully."
        else
            echo "Not found the requested kubectl version ${version}"
        fi
    else
        echo "Host OS is not Linux or MacOS."
    fi
}

k3s_install() {
    local os_type=${1}
    local version=${K3S_VERSION}
    local namespace=${NAMESPACE}
    local url=https://get.k3s.io

    echo "Installing k3s version ${version} for ${os_type} OS..."

    if [[ "${os_type}" == "linux"* ]]; then
        if [[ $(is_valid_url ${url}) ]]; then
            # install k3s
            curl -sfL ${url} | INSTALL_K3S_VERSION=${version} sh -s - --docker
            sudo chown -R ${USER} /etc/rancher/k3s

            # check installation
            while ! kubectl get pods >/dev/null 2>&1; do
                sleep 1
            done

            # create a namespace with the specified name.
            if ! kubectl get namespace ${namespace} >/dev/null 2>&1; then
                kubectl create namespace ${namespace}
            fi

            # sets a context entry in kubeconfig
            kubectl config set-context $(kubectl config current-context) --namespace=${namespace}

            echo "K3s version ${version} was installed successfully."
        else
            echo "Not found the requested k3s version ${version}"
        fi
    else
        echo "Host OS is not Linux"
    fi
}

install_cmd() {
    local os_type=$(get_os_type)

    case ${1} in
        golang)
            golang_install ${os_type}
            ;;
        helm)
            helm_install ${os_type}
            ;;
        kubectl)
            kubectl_install ${os_type}
            ;;
        k3s)
            k3s_install ${os_type}
            ;;
        --help|-h|*)
            install_help
            ;;
    esac
}
