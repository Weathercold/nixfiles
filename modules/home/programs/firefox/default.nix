{ config
, pkgs
, ...
} @ args:

let
  # FIXME: Module optional args are broken
  firefoxProfile = args.firefoxProfile or config.home.username;
in

{
  programs.firefox = {
    package = pkgs.firefox-wayland;
    profiles.${firefoxProfile}.settings = {
      "services.sync.username" = "weathercold.scr@gmail.com";
      "browser.aboutConfig.showWarning" = false;
    };
  };
}
