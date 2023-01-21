{ inputs, config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixfiles.programs.discord;
in

{
  options.nixfiles.programs.discord = {
    enable = mkEnableOption "Discord, a server-based instant messenger";
  };

  config.programs.discocss = mkIf cfg.enable {
    enable = true;
    discordPackage = with pkgs; discord.override {
      nss = nss_latest; # Fix discord links not opening in Firefox
      withOpenASAR = true;
    };
  };
}
