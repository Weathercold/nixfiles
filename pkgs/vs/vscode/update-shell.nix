{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  packages = [
    bash
    curl
    gawk
    gnugrep
    gnused
    jq
    nix-prefetch-scripts
  ];
}
