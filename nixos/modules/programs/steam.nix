{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.abszero.programs.steam;
in

{
  options.abszero.programs.steam.enable = mkEnableOption "Steam client";

  config.programs.steam = mkIf cfg.enable {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };
}
