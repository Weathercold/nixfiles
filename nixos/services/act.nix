{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkPackageOption mkIf;
  cfg = config.nixfiles.services.act;
in

{
  imports = [ ../virtualisation/docker.nix ];

  options.nixfiles.services.act = {
    enable = mkEnableOption "local GitHub Actions runner";
    package = mkPackageOption pkgs "act" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    # nixfiles.virtualisaton.docker.enable = true; # FIXME: not working
  };
}
