{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) lib fetchFromGitHub;
  fetchInput = input:
    let lock = with builtins; (fromJSON (readFile ./flake.lock)).nodes.${input}.locked; in
    fetchFromGitHub {
      inherit (lock) owner repo rev;
      hash = lock.narHash;
    };

  haumea = { lib = import (fetchInput "haumea") { inherit lib; }; };
in

import ./pkgs { inherit pkgs haumea; }
  // {
  lib = import ./lib { inherit lib haumea; };
  overlays = rec {
    default = abszero;
    abszero = final: _: import ./pkgs { pkgs = final; };
  };
}
