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
      url = "github:Weathercold/home-manager";
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
        # Aliases
        pkgs = nixpkgs;
        utils = flake-utils;
        hw = nixos-hardware;
        hm = home-manager;

        # Modules
        lib = import ./modules/lib pkgs.lib;
        inherit (lib.partials) partialFunc;
        ## Internal: Modules that have effet based on options.
        ## Optional: Modules that have effet on import.
        nixosModules = import ./modules/nixos pkgs.lib;
        homeModules = import ./modules/home pkgs.lib;

        # Configuration
        system = "x86_64-linux";
        username = "weathercold";
        userDescription = "Weathercold";
        userEmail = "weathercold.scr@gmail.com";
        userPassword = "$6$ESJQyaoFNr5kAoux$Jpvf3Qk/EfRJVvDK3lMND5X9eiMGNUt8TP7BoYPf5YYK/TpTeuyh.FqwheVvfaYlHwek1YFBP6qFAcgz1a14j/";
        homeDirectory = "/home/weathercold";

        # Functions
        mkSystem = partialFunc pkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              hw
              username
              userDescription
              userEmail
              userPassword;
          };
          modules =
            nixosModules.internal
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
            homeModules.internal
            ++ [{ inherit lib; }];
        };
      in

      {
        inherit lib;

        nixosModules = nixosModules.regular;
        homeModules = homeModules.regular;

        formatter.${system} = pkgs.nixpkgs-fmt;

        nixosConfigurations.nixos-inspiron = mkSystem {
          specialArgs = { hostName = "nixos-inspiron"; };
          modules = [
            nixosModules.regular.hardware.inspiron-7405
            ./modules/nixos/profiles/full.nix
          ];
        };

        homeConfigurations.weathercold =
          let tme = "colloid"; in
          mkHome {
            modules = [
              ./modules/home/profiles/full.nix
              {
                nixfiles.themes = {
                  themes = [ tme ];
                  firefox.profiles = [ "weathercold" ];
                };
                specialization.${tme}.default = true;

                specialization.aaaa.configuration = {
                  home.file."hello.txt".text = "mhm";
                };
              }
            ];
          };

        homeConfigurations.colloid =
          let tme = "colloid"; in
          mkHome {
            modules = [
              ./modules/home/profiles/build-config.nix
              {
                nixfiles.themes = {
                  themes = [ tme ];
                  # For firefox, put your firefox profile name here.
                  # firefox.profiles = [ ];
                };
                specialization.${tme}.default = true;
              }
            ];
          };
      };
}
