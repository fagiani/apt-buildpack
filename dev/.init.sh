#!/usr/bin/env bash

set -euo pipefail
dev_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$dev_path"

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    echo "This script can only be sourced and not executed." >&2
    exit 1
fi

text::paint() {
    local -A colors=(
        ["red"]="31"
        ["green"]="32"
        ["yellow"]="33"
        ["magenta"]="35"
    )
    local color="$1"
    local message="$2"
    local reset="${3:-0}"

    if [[ -z $message || -z $color ]]; then
        echo "[text::paint] missing message or color"
        return 1
    fi

    color=${colors[$color]:-}
    if [[ -z $color ]]; then
        echo "[text::paint] unknown color ${color}"
        return 1
    fi

    reset=${colors[$reset]:-}
    if [[ -z $color ]]; then
        reset=0
    fi

    echo -ne "\x1B[${color}m${message}\x1B[${reset}m"
}

log::color() {
    text::paint "$@"
    echo
}

log::info() {
    local msg
    if (($# == 0)); then
        msg=$(</dev/stdin)
    else
        msg="$*"
    fi

    log::color yellow "$msg"
}

log::error() {
    local msg
    if (($# == 0)); then
        msg=$(</dev/stdin)
    else
        msg="$*"
    fi

    log::color red "$*"
}

# usage: some command | indent 5
# indent all output by 5 spaces
indent() {
    local indent=("cat")

    if [[ -n "${1:-}" && $1 =~ ^[0-9]+$ ]]; then
        local prefix
        prefix=$(printf "%${1}s")
        indent=(
            sed
            -E "/^::(end)?group::/!s/^/${prefix}/" # do not indent github actions commands
        )
    fi

    "${indent[@]}"
}

print_pass_fail() {
    local status=${1:-0}
    if [[ $status == 0 ]]; then
        log::color green PASS
    else
        log::error FAIL
    fi
}
