#!/usr/bin/env bash
curl https://mise.run | sh
mise use -g bitwarden
bw login
export BW_SESSION=$(bw unlock --raw)
mkdir -p ~/.config/mise

KEY=$HOME/.ssh/mise_private_key
bw get notes "mise-bootstrap-private-ssh-key" > $KEY
chmod 600 $KEY

mise settings set age.key_path $KEY
mise set --age-encrypt A=B


mise bootstrap --adopt https://github.com/joshlong/mise.git
