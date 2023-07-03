#! /usr/bin/env nix-shell
#! nix-shell update-shell.nix -i bash

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

VER=$(curl -fs https://api.github.com/repos/techprober/v2ray-rules-dat/releases/latest \
      | jq -r .tag_name)
GEOIP_HASH=$(nix-prefetch-url \
  https://github.com/techprober/v2ray-rules-dat/releases/download/$VER/geoip.dat)
GEOSITE_HASH=$(nix-prefetch-url \
  https://github.com/techprober/v2ray-rules-dat/releases/download/$VER/geosite.dat)

sed -i "$ROOT/bin.nix" \
  -e "s|version = \".*\"|version = \"$VER\"|" \
  -e "s|geoipHash = \".*\"|geoipHash = \"$GEOIP_HASH\"|" \
  -e "s|geositeHash = \".*\"|geositeHash = \"$GEOSITE_HASH\"|"
