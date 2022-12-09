{
  description = "Weathercold's nixpkgs overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nixpkgs, flake-parts }:
    flake-parts.lib.mkFlake { inherit self; } {
      imports = [ ./flake-module.nix ];

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
        "aarch64-linux"
        "armv7l-linux"
      ];
      flake.flakeModules.default = ./flake-module.nix;
    };
}
