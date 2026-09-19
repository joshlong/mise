#!/usr/bin/env bash
# curl https://mise.run | sh
mise use -g bitwarden
bw login 
export BW_SESSION=$(bw unlock --raw)
mkdir -p ~/.config/mise

KEY=$HOME/.ssh/mise_private_key
PUB_KEY=${KEY}.pub

bw get notes "mise-bootstrap-private-ssh-key" > $KEY
bw get notes "mise-bootstrap-public-ssh-key" > $PUB_KEY
chmod 600 $KEY

mise settings experimental=true
mise set --age-encrypt --age-ssh-recipient $PUB_KEY --prompt DB_PASSWORD


# mise bootstrap --adopt https://github.com/joshlong/mise.git
