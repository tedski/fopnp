#!/bin/bash

# ssh config
SSHCONFIG=$(mktemp /tmp/sshconfig.XXXX)
vagrant ssh-config > $SSHCONFIG

# make the named pipe
# this is unsafe and i don't care
PIPE=$(mktemp -u /tmp/pcap.XXXX)
trap 'echo "Cleaning up.."; rm -rf "PIPE"' EXIT INT TERM HUP
mkfifo -m 600 "$PIPE"

echo "Starting Wireshark..."
wireshark -k -o capture.pcap_ng:FALSE -i $PIPE >/dev/null 2>&1 &

echo "Starting remote capture..."
echo "Use ^C to exit."
ssh -F $SSHCONFIG default 'sudo tcpdump -l -i h1-eth1 -s0 -w - "not port ssh" 2>/dev/null' > $PIPE
