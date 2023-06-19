{ lib, ... }:

let
  inherit (lib) const;
  inherit (lib.nixfiles) collectModules;
in

{
  imports = collectModules ../accounts
    ++ collectModules ../programs
    ++ collectModules ../services;

  # FIXME: Still broken, needs --impure to build
  nixpkgs.config.allowUnfreePredicate = const true;

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  xdg.enable = true;
}
