{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixfiles.programs.java;
in

{
  options.nixfiles.programs.java.enable = mkEnableOption "Java Development kit";

  config.programs.java = mkIf cfg.enable {
    enable = true;
    package = pkgs.temurin-bin;
  };
}
