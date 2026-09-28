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
echo "BEGIN INSTALLING NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh \
	| bash
source ~/.nvm/nvm.sh
nvm install 22
nvm alias default 22
echo "END INSTALLING NVM"

grep -qxF 'source ~/dotfiles/.zshrc' ~/.zshrc || echo 'source ~/dotfiles/.zshrc' >> ~/.zshrc

CODEX_VERSION="0.158"
mkdir -p "$HOME/.codex"

npm install -g \
	"@openai/codex@${CODEX_VERSION}"

install -m 600 "$HOME/dotfiles/.codex/config.toml" "$HOME/.codex/config.toml"

PI_VERSION="0.87"
mkdir -p "$HOME/.pi/agent"

npm install -g --ignore-scripts \
	"@earendil-works/pi-coding-agent@${PI_VERSION}"

install -m 600 "$HOME/dotfiles/.pi/agent/settings.json" "$HOME/.pi/agent/settings.json"

CLAUDE_CODE_VERSION="2.1"
mkdir -p "$HOME/.claude"

npm install -g \
	"@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}"

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
