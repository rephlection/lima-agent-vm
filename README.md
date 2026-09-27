# [lima](https://github.com/lima-vm/lima) based conding agent VM config

MicroVM based methods are better.

## Usage
- Spin it up: `limactl start ~/agt/lima.yaml --name agt && limactl shell agt`
- Using the `start_agent.sh` wrapper to start the VM with ssh-agent forwarding: [TODO]
- Throw it away: `limactl stop agt && limactl delete agt`
- Take a snapshot: [TODO]

## Functional requirements
- [ ] idempotent environment initialization (base image link, tool/software installation)
- [ ] folder sharing with proper rights
- [ ] network isolation (inbound/outbound; invisible host)
- [ ] ssh key forward (SSH_AUTH_SOCK)
- [ ] safely pass in ENV credentials such as API keys

## Known issues
- `limactl shell <vm>` might take ~5 seconds, which is slow

