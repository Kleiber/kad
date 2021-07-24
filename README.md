# kad
kad tool helps to install and manage Kubernetes clusters

## Overview

```bash
cd $HOME
git clone https://github.com/Kleiber/kad.git
```

## Installing

### Linux

```bash
export PATH=$PATH:$HOME/kad:
```

```bash
export NAMESPACE=<namespace>
export DOCKER_TAG=<docker-tag>
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
export DOCKER_REGISTRY=localhost:5000
```

### Mac

```bash
export PATH=$PATH:$HOME/kad:
```

```bash
export NAMESPACE=<namespace>
export DOCKER_TAG=<docker-tag>
export KUBECONFIG=~/.kube/config
export DOCKER_REGISTRY=localhost:5000
```

## Commands

```bash
kad tool helps to install and manage Kubernetes clusters.

 Find more information at: https://github.com/Kleiber/kad

Usage:  kad COMMAND [OPTIONS]

Commands:
  deploy      Deploy using helm values
  docker      Manage Docker images
  install     Install tools
  registry    Manage Docker registry
  uninstall   Uninstall tools

Options:
      --debug     Enable debug mode
  -h, --help      Show more information about command
  -v, --version   Show the kad version information

Run 'kad COMMAND --help' for more information about a given command.
```

### ***deploy***
### ***docker***
### ***install***
### ***registry***
### ***uninstall***

## Example
