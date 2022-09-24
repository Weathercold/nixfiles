{
  description = "Weathercold's NixOS Flake";

  inputs = {
    # Repos
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ## TODO: Actually use
    nur.url = "github:nix-community/NUR";

    # Utils
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    ## TODO: Actually use
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
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
  };

  outputs =
    { self

    , nixpkgs
    , nur

    , flake-utils
    , nixos-hardware
    , home-manager

    , dotdropFishComp
    , colloid-gtk-theme

    , ...
    } @ inputs:

      with builtins;

      let
        pkgs = nixpkgs;
        utils = flake-utils;
        hw = nixos-hardware;
        hm = home-manager;

        lib = import ./modules/lib pkgs.lib;
        inherit (lib.attrsets) attrValuesRecursive;
        inherit (lib.partials) partialFunc;
        # Default: Modules that have effet based on options.
        # All: Default ++ modules that have effet on import.
        nixosModules = import ./modules/nixos pkgs.lib;
        homeModules = import ./modules/home pkgs.lib;

        system = "x86_64-linux";
        hostName = "nixos-inspiron";
        username = "weathercold";
        userDescription = "Weathercold";
        userEmail = "weathercold.scr@gmail.com";
        userPassword = "$6$ESJQyaoFNr5kAoux$Jpvf3Qk/EfRJVvDK3lMND5X9eiMGNUt8TP7BoYPf5YYK/TpTeuyh.FqwheVvfaYlHwek1YFBP6qFAcgz1a14j/";
        homeDirectory = "/home/weathercold";

        mkSystem = partialFunc pkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              hw
              hostName
              username
              userDescription
              userEmail
              userPassword;
          };
          modules =
            attrValuesRecursive nixosModules.default
            ++ [{ inherit lib; }];
        };
        mkHome = partialFunc hm.lib.homeManagerConfiguration {
          pkgs = pkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit
              dotdropFishComp
              colloid-gtk-theme
              username
              userEmail
              homeDirectory;
          };
          modules =
            attrValuesRecursive homeModules.default
            ++ [{ inherit lib; }];
        };
      in

      {
        formatter.${system} = pkgs.nixpkgs-fmt;

        inherit lib;

        # Modules without options.
        nixosModules = nixosModules.all;
        homeModules = homeModules.all;

        nixosConfigurations.nixos-inspiron = mkSystem {
          modules = [
            nixosModules.all.hardware.inspiron-7405
            ./modules/nixos/profiles/base.nix
          ];
        };

        homeConfigurations.weathercold = mkHome {
          modules =
            pkgs.lib.attrsets.attrValues homeModules.all.theme-colloid
            ++ [ ./modules/home/profiles/base.nix ];
        };
      };
}
