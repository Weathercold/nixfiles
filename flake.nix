{
  description = "Weathercold's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    hw.url = "github:weathercold/nixos-hardware";
    utils.url = "github:numtide/flake-utils";
    hm = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };

    dotdropComp = {
      url = "https://raw.githubusercontent.com/deadc0de6/dotdrop/master/completion/dotdrop.fish";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , nur

    , hw
    , utils
    , hm

    , dotdropComp
    , ...
    } @ inputs:

      with builtins;

      let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        lib = import ./lib;
      in

      {
        formatter.${system} = pkgs.nixpkgs-fmt;

        nixosConfigurations.nixos-inspiron = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit hw;
            hostName = "nixos-inspiron";
            userName = "weathercold";
            userDescription = "Weathercold";
            userPassword = "$6$ESJQyaoFNr5kAoux$Jpvf3Qk/EfRJVvDK3lMND5X9eiMGNUt8TP7BoYPf5YYK/TpTeuyh.FqwheVvfaYlHwek1YFBP6qFAcgz1a14j/";
          };
          modules = [
            ./modules/nixos/hardware/inspiron-7405.nix
            ./modules/nixos/profiles/full.nix
          ];
        };

        homeConfigurations.weathercold = hm.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit dotdropComp; };
          modules = [ ./modules/home/profiles/full.nix ];
        };
      };
}
