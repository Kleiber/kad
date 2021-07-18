#!/usr/bin/env bash

## author: KleiberXD

get_os_type() {
    if [[ "$OSTYPE" == "linux"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin"
    else
        echo ""
    fi
}

