{
  description = "Weathercold's NixOS modules";

  inputs = {
    # Repos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Utils
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixfiles-lib.url = "github:Weathercold/nixfiles?dir=lib";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    { self

    , nixpkgs

    , flake-parts
    , nixfiles-lib
    , nixos-hardware
    }:

    let extendedLib = nixpkgs.lib.extend (_: _: { nixfiles = nixfiles-lib.lib; }); in

    flake-parts.lib.mkFlake
      {
        inherit self;
        specialArgs.lib = extendedLib;
      }
      {
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
