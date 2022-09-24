# This file contains sensitive information and is gitignored.
{ config, lib, ... }:

with lib;

let
  cfg = config.services.rclone;
  mkFileSystem = config.lib.partials.partialSet {
    fsType = "rclone";
    options = [
      "nofail"
      "_netdev"

      "allow_other"
      "config=/etc/rclone.conf"
      "cache-dir=/var/cache/rclone"
    ];
  };
in

{
  options.services.rclone.enableFileSystems = mkEnableOption "using rclone to manage network file systems";

  config = mkIf cfg.enableFileSystems {
    environment.etc."rclone.conf" = {
      mode = "0600";
      text = generators.toINI { } { };
    };

    fileSystems = { };
  };
}
