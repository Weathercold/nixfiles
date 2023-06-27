{ lib, ... }:

let inherit (lib) const; in

{
  # FIXME: Still broken, needs --impure to build
  nixpkgs.config.allowUnfreePredicate = const true;

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  xdg.enable = true;
}
