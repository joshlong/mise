#!/usr/bin/env bash
set -euo pipefail

# --- install mise -----------------------------------------------------------
curl -fsSL https://mise.run | sh

# the installer drops the binary here and edits your rc files, but *this*
# shell knows nothing about either, so wire it up by hand.
export PATH="$HOME/.local/bin:$PATH"

# shims, not `mise activate`: activate installs a prompt hook, and there is no
# prompt in a script. shims are plain executables, so `bw` works the moment
# `mise use -g bitwarden` finishes.
export MISE_DATA_DIR="${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}"
export PATH="$MISE_DATA_DIR/shims:$PATH"

mise --version

# --- bitwarden --------------------------------------------------------------
mise use -g bitwarden
mise reshim

bw login
export BW_SESSION=$(bw unlock --raw)

# --- ssh key for age encryption --------------------------------------------
mkdir -p ~/.config/mise ~/.ssh

KEY=$HOME/.ssh/mise_private_key
PUB_KEY=${KEY}.pub

# create with tight perms *before* writing, so the key is never world-readable
install -m 600 /dev/null "$KEY"
bw get notes "mise-bootstrap-private-ssh-key" > "$KEY"
bw get notes "mise-bootstrap-public-ssh-key" > "$PUB_KEY"
chmod 644 "$PUB_KEY"

mise settings experimental=true
mise set --age-encrypt --age-ssh-recipient "$PUB_KEY" --prompt DB_PASSWORD


# mise bootstrap --adopt https://github.com/joshlong/mise.git
