#!/usr/bin/env bash

## author: KleiberXD

export CLI_NAME=kad

export K3S_VERSION=v1.21.2+k3s1
export KUBERNETES_VERSION=v1.21.2
export HELM_VERSION=v3.6.2
export GO_VERSION=1.16.5

export NAMESPACE=${NAMESPACE:-"default"}
export KUBECONFIG=${KUBECONFIG:-"/etc/rancher/k3s/k3s.yaml"}
export DOCKER_REGISTRY=${DOCKER_REGISTRY:-"localhost:5000"}
export DOCKER_TAG=${DOCKER_TAG:-"latest"}
