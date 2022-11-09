{ config, pkgs, lib, username, ... }:

with lib;

let cfg = config.nixfiles.docker; in

{
  options.nixfiles.docker.enable = mkEnableOption "docker";

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = mkDefault false;
    };
    users.users.${username}.extraGroups = [ "docker" ];
  };
}
