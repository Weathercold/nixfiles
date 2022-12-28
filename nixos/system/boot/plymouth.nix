{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixfiles.boot.plymouth;
in

{
  options.nixfiles.boot.plymouth.enable = mkEnableOption "boot animation";

  config.boot.plymouth = mkIf cfg.enable {
    enable = true;
    themePackages = with pkgs; [
      (plymouth-themes.override { themes0 = [ "rings_2" ]; })
    ];
    theme = "rings_2";
  };
}
