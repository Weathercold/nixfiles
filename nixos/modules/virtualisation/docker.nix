{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault genAttrs const;
  cfg = config.nixfiles.virtualisation.docker;
in

{
  options.nixfiles.virtualisation.docker.enable = mkEnableOption "docker";

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = mkDefault false;
    };
    users.users = genAttrs
      config.nixfiles.users.admins
      (const { extraGroups = [ "docker" ]; });
  };
}
