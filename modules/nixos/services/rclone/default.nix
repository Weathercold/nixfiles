{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.rclone;
in

{
  options.services.rclone = {
    enable = mkEnableOption "network storage client and server daemon";
    package = mkPackageOption pkgs "rclone" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Make mount use rclone as a mount helper
    systemd.tmpfiles.rules =
      [ "L /sbin/mount.rclone - - - - /run/current-system/sw/bin/rclone" ];
  };
}
