{ inputs, config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixfiles.programs.discord;
in

{
  options.nixfiles.programs.discord = {
    enable = mkEnableOption "Discord, a server-based instant messenger";
  };

  config.programs.discocss = with pkgs; mkIf cfg.enable rec {
    enable = true;
    discordAlias = false;
    package = discocss.overrideAttrs (prev: {
      installPhase = prev.installPhase + ''
        wrapProgram $out/bin/discocss --set DISCOCSS_DISCORD_BIN ${discordPackage}/bin/DiscordCanary
        ln -s $out/bin/discocss $out/bin/DiscordCanary
        mkdir -p $out/share
        ln -s ${discordPackage}/share/* $out/share
      '';
    });
    discordPackage = discord-canary.override {
      nss = nss_latest; # Fix discord links not opening in Firefox
      withOpenASAR = true;
    };
  };
}
