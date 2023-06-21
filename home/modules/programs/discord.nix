{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixfiles.programs.discord;
in

{
  options.nixfiles.programs.discord = {
    enable = mkEnableOption "Discord, a server-based instant messenger";
  };

  config = mkIf cfg.enable {
    programs.discocss = with pkgs; {
      enable = true;
      discordPackage = discord.override {
        nss = nss_latest; # Fix discord links not opening in Firefox
        withOpenASAR = true;
      };
    };
  };
}
