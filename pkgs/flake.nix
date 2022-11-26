{
  description = "Weathercold's nixpkgs overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nixpkgs, flake-parts }:
    flake-parts.lib.mkFlake { inherit self; } {
      imports = [ ./flake-module.nix ];
      flake.flakeModules.default = ./flake-module.nix;
    };
}
