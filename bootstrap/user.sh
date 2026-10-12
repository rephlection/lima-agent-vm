#!/bin/bash
exec > >(tee -a /tmp/bootstrap-user.log) 2>&1

echo "Starting user provisioning"

set -euxo pipefail

mkdir -p ~/.zshrc.d
mkdir -p ~/.local/bin

cat > ~/.zshrc.d/ssh-agent.zsh <<'EOF'
if [ -S /run/host-services/ssh-auth.sock ]; then
    export SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
fi
EOF

# starship
curl -sS https://starship.rs/install.sh \
	| sh -s -- -y -b ~/.local/bin

# rust
curl https://sh.rustup.rs -sSf \
	| sh -s -- -y
source ~/.cargo/env

# nvm/node
NVM_VERSION="0.40.8"
NODE_VERSION="24"
echo "BEGIN INSTALLING NVM"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" \
	| bash >/dev/null
source ~/.nvm/nvm.sh
nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
nvm use default
echo "END INSTALLING NVM"

grep -qxF 'source ~/dotfiles/.zshrc' ~/.zshrc || echo 'source ~/dotfiles/.zshrc' >> ~/.zshrc

CODEX_VERSION="0.162.1"
mkdir -p "$HOME/.codex"
curl -fsSL "https://chatgpt.com/codex/install.sh" \
    | CODEX_NON_INTERACTIVE=1 sh -s -- --release "$CODEX_VERSION"
install -m 600 "$HOME/dotfiles/.codex/config.toml" "$HOME/.codex/config.toml"

PI_VERSION="1.1.0"
mkdir -p "$HOME/.pi/agent"
curl -fsSL "https://pi.dev/install.sh" \
    | sed "s|\"\$PI_INSTALLER_API_BASE/latest\"|\"\$PI_INSTALLER_API_BASE/$PI_VERSION\"|" \
    | sh
install -m 600 "$HOME/dotfiles/.pi/agent/settings.json" "$HOME/.pi/agent/settings.json"

CLAUDE_CODE_VERSION="2.1.294"
mkdir -p "$HOME/.claude"
curl -fsSL "https://claude.ai/install.sh" \
    | bash -s -- "$CLAUDE_CODE_VERSION"
install -m 600 "$HOME/dotfiles/.claude/settings.json" "$HOME/.claude/settings.json"

# DOTFILES="$HOME/dotfiles"

# for file in .zshrc ; do
#     if [ -e "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
#         rm "$HOME/$file"
#     fi
# 
#     ln -s "$DOTFILES/$file" "$HOME/$file"
# done

echo "Finished user provisioning"
