#!/usr/bin/env bash
set -euo pipefail

# `--adopt` git-clones the repo *into* ~/.config/mise, and hard-errors if that
# dir already exists and is not a git checkout. So nothing below may create it
# before the adopt in phase 2.
rm -rf ~/.config/mise/

# --- install mise -----------------------------------------------------------
curl -fsSL https://mise.run | sh

# the installer edits your rc files, but *this* shell knows nothing about them.
export PATH="$HOME/.local/bin:$PATH"
# shims, not `mise activate`: activate installs a prompt hook, and a script has
# no prompt. shims are real executables, so installed tools resolve immediately.
export MISE_DATA_DIR="${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}"
export PATH="$MISE_DATA_DIR/shims:$PATH"
# bootstrap is experimental. Via env, NOT `mise settings experimental=true` --
# that writes ~/.config/mise/config.toml and breaks the adopt.
export MISE_EXPERIMENTAL=1

mise --version

# === phase 1: break the chicken-and-egg =====================================
# The repo's mise.toml carries age-encrypted [env] values, and mise decrypts
# [env] at CONFIG LOAD time -- not lazily on use. So on a key-less machine
# EVERY mise command that reads the global config dies with:
#     mise ERROR [experimental] Failed to decrypt A
#     mise ERROR [experimental] No age identities found for decryption
# including `mise bootstrap --only packages`. You cannot use the real config to
# install the tool that fetches the key that decrypts the real config.
#
# Escape hatch: MISE_GLOBAL_CONFIG_FILE pointed at an EMPTY toml. mise then runs
# with no global config, so there is nothing to decrypt, and bitwarden can be
# pulled in ad hoc via `mise x`.
TMPDIR_BOOT="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_BOOT"' EXIT
EMPTY_CONF="$TMPDIR_BOOT/empty.toml"
: > "$EMPTY_CONF"

# every bw call runs under the empty config, never the secret-bearing one
bw() { MISE_GLOBAL_CONFIG_FILE="$EMPTY_CONF" mise x bitwarden@latest -- bw "$@"; }

# `bw login` exits 1 if already logged in, so branch on status -- this script
# has to be re-runnable.
BW_STATUS="$(bw status | sed -n 's/.*"status":"\([^"]*\)".*/\1/p')"
if [ "$BW_STATUS" = "unauthenticated" ]; then
  bw login   # interactive; do NOT capture, or the prompts get swallowed
fi
# normalize: unlocking an already-unlocked vault errors, and we cannot recover
# an existing session key from inside the script. Lock, then mint a fresh one.
bw lock >/dev/null 2>&1 || true
# assign on its own line: `export FOO=$(cmd)` masks cmd's exit status from set -e
BW_SESSION="$(bw unlock --raw)"
export BW_SESSION

# --- ssh key: the age identity mise decrypts [env] with ---------------------
mkdir -p ~/.ssh
KEY=$HOME/.ssh/mise_private_key
# create with tight perms *before* writing, so the key is never world-readable
install -m 600 /dev/null "$KEY"
bw get notes "mise-bootstrap-private-ssh-key" > "$KEY"
bw get notes "mise-bootstrap-public-ssh-key"  > "$KEY.pub"
chmod 644 "$KEY.pub"

# a failed `bw get` yields an EMPTY file, not an error the eye catches -- and an
# empty key fails later at config load, far from the cause. Verify it now.
if ! ssh-keygen -lf "$KEY" >/dev/null 2>&1; then
  echo "FATAL: $KEY is not a valid private key (bw get notes returned nothing?)" >&2
  exit 1
fi
echo "ssh key ok: $(ssh-keygen -lf "$KEY")"

# === phase 2: the real bootstrap ============================================
# key is in place, so the adopted config's [env] decrypts on load.
# clones repo -> ~/.config/mise, then packages -> repos -> tools -> bootstrap task.
# NOTE: pulls from GitHub, so local mise.toml edits do nothing until pushed.
mise bootstrap --adopt https://github.com/joshlong/mise.git --yes


