{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  packages = [
    bash
    nix
    nix-prefetch-github
  ];
}
