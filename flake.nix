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
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:Weathercold/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Data
    catppuccin-fcitx5 = {
      url = "github:catppuccin/fcitx5";
      flake = false;
    };
    catppuccin-discord = {
      url = "https://catppuccin.github.io/discord/dist/catppuccin-latte-blue.theme.css";
      flake = false;
    };
    firefox-vertical-tabs = {
      url = "github:ranmaru22/firefox-vertical-tabs";
      flake = false;
    };
  };

  outputs = { nixpkgs, flake-parts, ... } @ inputs:

    let
      lib = import ./lib { inherit (nixpkgs) lib; };
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
        perSystem = { pkgs, system, ... }: {
          formatter = pkgs.nixpkgs-fmt;
        };

        flake.lib = lib;
      };
}
