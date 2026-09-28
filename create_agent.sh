#!/bin/bash

set -euo pipefail

AGENT_DIR="$HOME/.ssh/coding-agent"
SOCK="$AGENT_DIR/agent.sock"
KEY="$AGENT_DIR/id_github_ed25519"
VM_NAME="agt"
CONFIG="$HOME/agt/lima.yaml"

if [[ ! -f "$KEY" ]]; then
    echo "Missing SSH private key: $KEY" >&2
    exit 1
fi

if [[ ! -S "$SOCK" ]]; then
    if [[ -e "$SOCK" ]]; then
        echo "Removing stale SSH-agent socket: $SOCK" >&2
        rm -f "$SOCK"
    fi

    eval "$(ssh-agent -a "$SOCK")"
fi

export SSH_AUTH_SOCK="$SOCK"

if ! ssh-add -l >/dev/null 2>&1; then
    ssh-add "$KEY"
fi

echo "Host SSH agent: $SSH_AUTH_SOCK"
ssh-add -l

exec limactl create "$CONFIG" --name "$VM_NAME"
