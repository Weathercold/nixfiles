{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.nixfiles.programs.firefox;
in

{
  options.nixfiles.programs.firefox = {
    enable = mkEnableOption "managing Firefox";
    profile = mkOption {
      type = types.nonEmptyStr;
      default = config.home.username;
    };
  };

  config.programs.firefox = mkIf cfg.enable {
    enable = true;
    package = pkgs.firefox-devedition-bin.override {
      extraNativeMessagingHosts =
        with pkgs; [ libsForQt5.plasma-browser-integration ];
    };

    profiles.${cfg.profile}.settings = {
      "services.sync.username" = config.lib.attrsets.findName
        (_: v: v.primary == true)
        config.accounts.email.accounts;
      "browser.aboutConfig.showWarning" = false;
    };
  };
}
