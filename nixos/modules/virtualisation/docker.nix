{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault genAttrs attrNames const;
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
      (attrNames config.nixfiles.users.users)
      (const { extraGroups = [ "docker" ]; });
  };
}
