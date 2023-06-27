{ config, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixfiles.boot.loader.systemd-boot;
in

{
  options.nixfiles.boot.loader.systemd-boot.enable = mkEnableOption "systemd-boot";

  config.boot.loader.systemd-boot = mkIf cfg.enable {
    enable = true;
    configurationLimit = 5;
  };
}
