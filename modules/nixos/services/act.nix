{ config, pkgs, lib, ... }:

with lib;

let cfg = config.nixfiles.act; in

{
  imports = [ ./docker.nix ];

  options.nixfiles.act = {
    enable = mkEnableOption "local GitHub Actions runner";
    package = mkPackageOption pkgs "act" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    nixfiles.docker.enable = true;
  };
}
