{
  description = "Weathercold's home-manager modules";

  inputs = {
    # Repos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # bocchi-cursors = {
    #   url = "github:Weathercold/Bocchi-Cursors";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-parts.follows = "flake-parts";
    #   };
    # };

    # Utils
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:Weathercold/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # catppuccin.url = "github:catppuccin/nix";
    catppuccin.url = "github:Weathercold/nix/patch";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      haumea,
      ...
    }@inputs:
    let
      extendedLib = nixpkgs.lib.extend (
        _: _: {
          abszero = import ../lib {
            inherit (nixpkgs) lib;
            inherit haumea;
          };
        }
      );
    in
    flake-parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs.lib = extendedLib;
      }
      {
        imports = [ ./flake-module.nix ];

        systems = [ "x86_64-linux" ];
      };
}
