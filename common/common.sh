#!/usr/bin/env bash

## author: KleiberXD

required() {
    local flag=${1}
    local value=${2}
    if [[ ! ${value} ]]; then
        echo "Requires the use of the ${flag} flag."
        exit 1
    fi
}

not_required() {
    local flag=${1}
    local value=${2}
    if [[ ${value} ]]; then
        echo "Not require the use of the ${flag} flag."
        exit 1
    fi
}

is_valid_url() {
    local url=${1}
    if curl --head --fail --silent ${url}; then
        return 1
    else
        return 0
    fi
}

