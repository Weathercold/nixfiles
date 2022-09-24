{ config
, pkgs
, userEmail
, ...
} @ args:

let
  # FIXME: Module optional args are broken
  firefoxProfile = args.firefoxProfile or config.home.username;
in

{
  programs.firefox = {
    package = pkgs.firefox-wayland.override {
      extraNativeMessagingHosts =
        with pkgs; [ libsForQt5.plasma-browser-integration ];
    };
    profiles.${firefoxProfile}.settings = {
      "services.sync.username" = userEmail;
      "browser.aboutConfig.showWarning" = false;
    };
  };
}
