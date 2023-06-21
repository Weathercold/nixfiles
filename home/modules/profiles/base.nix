{ lib, ... }:

let
  inherit (lib) const;
  inherit (lib.nixfiles.filesystem) toModuleList;
in

{
  imports =
    toModuleList ../accounts
    ++ toModuleList ../programs
    ++ toModuleList ../services;

  # FIXME: Still broken, needs --impure to build
  nixpkgs.config.allowUnfreePredicate = const true;

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  xdg.enable = true;
}
