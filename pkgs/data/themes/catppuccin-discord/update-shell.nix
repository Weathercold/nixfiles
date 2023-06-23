{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  packages = [
    bash
    gnused
    jq
    nix
    nix-prefetch-github
  ];
}
