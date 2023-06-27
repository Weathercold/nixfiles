{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixfiles.boot.loader.grub;
in

{
  options.nixfiles.boot.loader.grub.enable = mkEnableOption "grub";

  config.boot.loader.grub = mkIf cfg.enable {
    enable = true;
    theme = pkgs.nixos-grub2-theme;
  };
}
