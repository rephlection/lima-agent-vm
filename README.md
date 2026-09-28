# [lima](https://github.com/lima-vm/lima) based conding agent VM config

Creating a lima vm for coding agents.

MicroVM based methods are better.

## Usage
- Spin it up: `limactl start ~/agt/lima.yaml --name agt && limactl shell agt`
- Throw it away: `limactl stop agt && limactl delete agt`
- Take a snapshot: [TODO]

Wrapper with ssh-agent forwarding:
- `./start_agent.sh <vm_name>` to start the VM with ssh-agent forwarding
- The rest operations (create/shell/stop/delete) do not need wrapping

## Functional requirements
- idempotent environment initialization
    - [ ] fixed version of base image link
    - [ ] tool/software management (maybe mise/aqua?)
    - [ ] re-run guards
- folder sharing with proper rights
- network isolation
    - [ ] inbound/outbound control
    - [x] unreachable ipv4 host
    - [ ] unreachable ipv6 host
- ssh key forwarding
    - [x] SSH_AUTH_SOCK
- credential management
    - [ ] safely pass in ENV credentials such as API keys

## Known issues
- `limactl shell <vm>` might take ~5 seconds, which is slow
- mounted folder might be lost if files on host are changed during e.g. git checkouts

## Safety issues

Secret management:
- change `./secret` to `700` and all files under it to `600`

