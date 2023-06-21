{
  description = "Weathercold's utility library";

  inputs = {
    nixpkgs-lib.url = "github:NixOS/nixpkgs/nixos-unstable?dir=lib";
    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs-lib";
    };
  };

  outputs = { self, nixpkgs-lib, haumea }: {
    lib = import ./. {
      inherit (nixpkgs-lib) lib;
      inherit haumea;
    };
  };
}
