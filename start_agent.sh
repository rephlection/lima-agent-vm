#!/bin/bash

set -euo pipefail

AGENT_DIR="$HOME/.ssh/coding-agent"
SOCK="$AGENT_DIR/agent.sock"

if [ ! -S "$SOCK" ]; then
    ssh-agent -a "$SOCK"
fi

export SSH_AUTH_SOCK="$SOCK"
ssh-add -l >/dev/null 2>&1 || \
ssh-add "$AGENT_DIR/github_ed25519"

limactl start ~/agt/lima.yaml
