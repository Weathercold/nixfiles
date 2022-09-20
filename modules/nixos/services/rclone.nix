{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.rclone;
in

{
  options.services.rclone = {
    enable = mkEnableOption "network storage client and server daemon";
    enableFileSystems = mkEnableOption "network file systems managed by rclone";
    package = mkPackageOption pkgs "rclone" { };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."rclone.conf".source = "/root/.config/rclone/rclone.conf";
    };

    systemd.tmpfiles.rules =
      [ "L /sbin/mount.rclone - - - - /run/current-system/sw/bin/rclone" ];

    fileSystems = mkIf cfg.enableFileSystems {
      "/mnt/partagez" = {
        device = "partagez:";
        fsType = "rclone";
        options = [
          "nofail"
          "_netdev"

          "allow_other"
          "vfs-cache-mode=writes"
          "config=/etc/rclone.conf"
          "cache-dir=/var/cache/rclone"
        ];
      };
    };
  };
}
