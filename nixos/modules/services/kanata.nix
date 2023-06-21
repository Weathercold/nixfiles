{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkDefault mkIf;
  cfg = config.nixfiles.services.kanata;
in

{
  options.nixfiles.services.kanata.enable =
    mkEnableOption "advanced software keyboard remapper";

  # Keyboard config is in ../hardware
  config.services.kanata = mkIf cfg.enable {
    enable = true;
    package = mkDefault pkgs.kanata-with-cmd;
  };
}
