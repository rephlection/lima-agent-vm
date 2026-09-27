#!/bin/bash
exec > >(tee -a /var/log/bootstrap-system.log) 2>&1

echo "Starting system provisioning"

set -euxo pipefail
USERNAME=agent

apt update
apt install -y \
    sudo \
    git \
    curl \
    wget \
    zsh \
    tmux \
    ripgrep \
    fd-find \
    jq \
    build-essential \
    pkg-config \
    python3 \
    python3-pip \
    unzip \
    openssh-client \
    ca-certificates

apt install -y nftables

if ! id "$USERNAME"; then
    useradd \
      -m \
      -s /bin/zsh \
      "$USERNAME"
fi

chsh -s /bin/zsh $USERNAME
usermod -c "" $USERNAME
# sudo
echo "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/systemctl" \
    >/etc/sudoers.d/$USERNAME
chmod 440 /etc/sudoers.d/$USERNAME

# network
HOST_GATEWAY=$(ip route | awk '/default/ {print $3}')

if [ -z "$HOST_GATEWAY" ]; then
    echo "Cannot find default gateway"
    exit 1
fi

echo "Blocking host gateway: $HOST_GATEWAY"

cat >/etc/nftables.conf <<EOF
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0;

        policy drop;

        # localhost
        iif lo accept

        # existing connections
        ct state established,related accept

        # Lima SSH access
        tcp dport 22 accept # is it safe?
    }

    chain output {
        type filter hook output priority 0;

        # allow everything except host
        policy accept;

        # block macOS host gateway
        ip daddr $HOST_GATEWAY drop
    }
}
EOF

systemctl enable nftables
systemctl restart nftables

echo "Finished system provisioning"
