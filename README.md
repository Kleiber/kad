# kad

## Overview

`kad` tool helps to install Kubernetes clusters and manage Docker containers.

## Requirements

Docker installed is a requirement:

- [Docker Engine](https://docs.docker.com/engine/install/ubuntu/) for Linux OS
- [Docker Desktop](https://docs.docker.com/docker-for-mac/install/) for Mac OS

## Installing

Using `kad` command line is simple. First, clone the repository in your workspace

```bash
$ cd $HOME
$ git clone https://github.com/Kleiber/kad.git
```

### Linux

Include the following line in your `.bashrc` file (use the command `vim ~/.bashrc` to edit)

```bash
export PATH=$PATH:$HOME/kad:

export NAMESPACE=<your-namespace>
export DOCKER_TAG=<your-docker-tag>
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

Finally, restart your terminal or run the command `source ~/.bashrc`

### Mac

Include the following lines in your `.zshrc` file (use the command `vim ~/.zshrc` to edit)

```bash
export PATH=$PATH:$HOME/kad:

export NAMESPACE=<your-namespace>
export DOCKER_TAG=<your-docker-tag>
export KUBECONFIG=~/.kube/config
```

Finally, restart your terminal

## Commands

Later, we can run the `kad --help` command to see how to use the different commands:

```bash
$ kad --help

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

## Example

To see how the different commands can be used, see the example. In [this example](./example), we show how to deploy in a kubernetes cluster an application developed in golang.
