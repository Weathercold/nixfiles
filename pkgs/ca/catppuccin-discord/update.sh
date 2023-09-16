#! /usr/bin/env nix-shell
#! nix-shell update-shell.nix -i bash

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

LOCK="$(nix-prefetch-github catppuccin discord)"
REV=$(jq .rev <<< "$LOCK")
HASH=$(jq .hash <<< "$LOCK")

sed -i "$ROOT/git.nix" \
  -e "s|rev = \".*\"|rev = $REV|" \
  -e "s|hash = \".*\"|hash = $HASH|" \
