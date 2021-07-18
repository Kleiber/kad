#!/usr/bin/env bash

## author: KleiberXD

is_valid_url() {
    local url=${1}
    if curl --head --fail --silent ${url}; then
        return 1
    else
        return 0
    fi
}

