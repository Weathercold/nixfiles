{ config, pkgs, lib, ... }:

let
  inherit (builtins) getAttr substring;
  inherit (lib) toUpper;
  cfg = config.nixfiles.themes.catppuccin;
in

{
  imports = [ ./. ];

  home.pointerCursor = {
    package = getAttr (cfg.variant + "Light") pkgs.catppuccin-cursors;
    name = "Catppuccin-${toUpper (substring 0 1 cfg.variant) + substring 1 100 cfg.variant}-Light";
    gtk.enable = true;
    x11.enable = true;
  };
}
