{
  description = "Weathercold's NixOS Flake";

  inputs = {
    # Repos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ## TODO: Actually use
    # nur.url = "github:nix-community/NUR";

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
    dotdropFishComp = {
      url = "https://raw.githubusercontent.com/deadc0de6/dotdrop/master/completion/dotdrop.fish";
      flake = false;
    };
    ## https://github.com/vinceliuice/Colloid-gtk-theme
    colloid-gtk-theme = {
      url = "github:vinceliuice/Colloid-gtk-theme";
      flake = false;
    };
    ## https://github.com/ranmaru22/firefox-vertical-tabs
    firefox-vertical-tabs = {
      url = "github:ranmaru22/firefox-vertical-tabs";
      flake = false;
    };
  };

  outputs =
    { self

    , nixpkgs
    , nur

    , flake-compat # not actually used
    , flake-parts
    , nixos-hardware
    , home-manager

    , dotdropFishComp
    , colloid-gtk-theme
    , firefox-vertical-tabs
    }:

    let
      lib = import ./lib { inherit (nixpkgs) lib; };
      extendedLib = nixpkgs.lib.extend (_: _: { nixfiles = lib; });
    in

    flake-parts.lib.mkFlake
      {
        inherit self;
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
