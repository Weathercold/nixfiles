{ pkgs ? import <nixpkgs> { } }:
import ./pkgs { inherit pkgs; }
  // {
  lib = import ./lib { inherit (pkgs) lib; };
  overlays = rec {
    default = abszero;
    abszero = final: _: import ./pkgs { pkgs = final; };
  };
}
