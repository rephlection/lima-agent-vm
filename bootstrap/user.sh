#!/bin/bash
exec > >(tee -a /tmp/bootstrap-user.log) 2>&1

echo "Starting user provisioning"

set -euxo pipefail

mkdir -p ~/.zshrc.d

cat > ~/.zshrc.d/ssh-agent.zsh <<'EOF'
export SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
EOF

# starship
curl -sS https://starship.rs/install.sh \
	| sh -s -- -y

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

# touch ~/.zshrc
echo "source ~/dotfiles/.zshrc" >> ~/.zshrc

# npm install -g \
#  @openai/codex \
#  @anthropic-ai/claude-code

# DOTFILES="$HOME/dotfiles"

# for file in .zshrc ; do
#     if [ -e "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
#         rm "$HOME/$file"
#     fi
# 
#     ln -s "$DOTFILES/$file" "$HOME/$file"
# done

echo "Finished user provisioning"
