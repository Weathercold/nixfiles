{
  description = "Weathercold's NixOS Flake";

  inputs = {
    # Repos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ## TODO: Actually use
    # nur.url = "github:nix-community/NUR";
    nixd = {
      url = "github:nix-community/nixd";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    bocchi-cursors = {
      url = "github:Weathercold/Bocchi-Cursors";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # Utils
    flake-compat = {
      # Fork to use the "dirty" repo, i.e. with uncommitted & unstaged changes
      url = "github:inclyc/flake-compat";
      flake = false;
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      # Fork to add option to specify default specialisation
      url = "github:Weathercold/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Data
    catppuccin-fcitx5 = {
      url = "github:catppuccin/fcitx5";
      flake = false;
    };
  };

  outputs = { nixpkgs, flake-parts, haumea, ... } @ inputs:

    let
      lib = import ./lib {
        inherit (nixpkgs) lib;
        inherit haumea;
      };
      extendedLib = nixpkgs.lib.extend (_: _: { nixfiles = lib; });
    in

    flake-parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs = {
          lib = extendedLib;
        };
      }
      {
        imports = [
          ./pkgs/flake-module.nix
          ./nixos/flake-module.nix
          ./home/flake-module.nix
        ];

        systems = [
          "x86_64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
          "aarch64-linux"
          "armv7l-linux"
        ];
        perSystem = { inputs', pkgs, system, ... }:
          with pkgs; {
            formatter = nixpkgs-fmt;
            devShells.default = mkShell {
              packages = [
                inputs'.nixd.packages.nixd
                nixpkgs-fmt
              ];
            };
          };

        flake.lib = lib;
      };
}
