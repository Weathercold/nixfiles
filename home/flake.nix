{
  description = "Weathercold's home-manager modules";

  inputs = {
    # Repos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    bocchi-cursors = {
      url = "github:Weathercold/Bocchi-Cursors";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # Utils
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:Weathercold/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Data
    dotdropFishComp = {
      url = "https://raw.githubusercontent.com/deadc0de6/dotdrop/master/completion/dotdrop.fish";
      flake = false;
    };
    colloid-gtk-theme = {
      url = "github:vinceliuice/Colloid-gtk-theme";
      flake = false;
    };
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

        systems = [ "x86_64-linux" ];
      };
}
