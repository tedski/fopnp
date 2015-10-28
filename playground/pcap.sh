#!/bin/bash

# ssh config
SSHCONFIG=$(mktemp)

# make the named pipe
# this is unsafe and i don't care
PIPE=$(mktemp -u)
mkfifo $PIPE

ssh -F $SSHCONFIG 'sudo tcpdump -i any -s0 -w - "not port ssh" 2>/dev/null' > $PIPE
