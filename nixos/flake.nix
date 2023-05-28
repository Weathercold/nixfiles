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
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { nixpkgs, flake-parts, ... } @ inputs:

    let
      extendedLib = nixpkgs.lib.extend
        (_: _: { nixfiles = import ../lib { inherit (nixpkgs) lib; }; });
    in

    flake-parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs.lib = extendedLib;
      }
      {
        imports = [ ./flake-module.nix ];

        systems = [
          "x86_64-linux"
          # "x86_64-darwin"
          # "aarch64-darwin"
          # "aarch64-linux"
          # "armv7l-linux"
        ];
      };
}
