{ inputs, config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixfiles.programs.discocss;
in

{
  options.nixfiles.programs.discocss = {
    enable = mkEnableOption "Discord CSS injector, along with Discord itself";
  };

  config.programs.discocss = mkIf cfg.enable {
    enable = true;
    discordPackage = with pkgs; discord.override {
      nss = nss_latest;
      withOpenASAR = true;
    };
  };
}
