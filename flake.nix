{
  description = "Weathercold's NixOS Flake";

  inputs = {
    # Repos
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ## TODO: Actually use
    # nur.url = "github:nix-community/NUR";

    # Utils
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
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

    , flake-utils
    , nixos-hardware
    , home-manager

    , dotdropFishComp
    , colloid-gtk-theme
    , firefox-vertical-tabs

    , ...
    }:

    let
      # Aliases
      pkgs = nixpkgs.legacyPackages.${system};
      utils = flake-utils;
      hw = nixos-hardware;
      hm = home-manager;

      # Modules
      extendedLib = pkgs.lib.extend (_: _: { nixfiles = self.lib; });
      callLib = m: import m extendedLib;
      nixosModules = callLib ./modules/nixos;
      homeModules = callLib ./modules/home;
      inherit (self.lib.partials) partialFunc;

      # Configuration
      system = "x86_64-linux";
      username = "weathercold";
      userDescription = "Weathercold";
      userEmail = "weathercold.scr@gmail.com";
      userPassword = "$6$ESJQyaoFNr5kAoux$Jpvf3Qk/EfRJVvDK3lMND5X9eiMGNUt8TP7BoYPf5YYK/TpTeuyh.FqwheVvfaYlHwek1YFBP6qFAcgz1a14j/";
      homeDirectory = "/home/weathercold";

      defaultModule = {
        inherit (self) lib;
        nixpkgs.overlays = [ self.overlays.default ];
      };

      # Functions
      mkSystem = partialFunc
        nixpkgs.lib.nixosSystem
        {
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
            ++ [ defaultModule ];
        };
      mkHome = partialFunc
        hm.lib.homeManagerConfiguration
        {
          inherit pkgs;
          extraSpecialArgs = {
            inherit
              username
              userEmail
              homeDirectory
              dotdropFishComp
              colloid-gtk-theme
              firefox-vertical-tabs;
          };
          modules =
            homeModules.internal
            ++ [ defaultModule ];
        };
    in

    utils.lib.eachDefaultSystem
      (system:
        with import nixpkgs
          {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        {
          formatter = nixpkgs-fmt;
          packages = {
            inherit
              vscode-insiders
              vscode-insiders-with-extensions
              vscodium-insiders;
          };
        }
      )
    // {
      overlays.default = import ./pkgs/top-level/all-packages.nix;

      lib = import ./modules/lib pkgs.lib;

      nixosModules = nixosModules.regular;
      homeModules = homeModules.regular;

      nixosConfigurations.nixos-inspiron = mkSystem {
        specialArgs = { hostName = "nixos-inspiron"; };
        modules = [
          self.nixosModules.hardware.inspiron-7405
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
