{ config, lib, colloid-gtk-theme, ... }:

let
  inherit (lib) mkBefore;
  cfg = config.nixfiles.programs.firefox;

  tme = colloid-gtk-theme + "/src/other/firefox/chrome/Colloid";
in

{
  imports = [
    ../../programs/firefox.nix
    ../base/firefox.nix
  ];

  programs.firefox.profiles.${cfg.profile} = {
    userChrome = mkBefore ''@import "${tme}/theme.css";'';
    userContent = mkBefore ''
      @import "${tme}/colors/light.css";
      @import "${tme}/colors/dark.css";

      @import "${tme}/pages/newtab.css";
      @import "${tme}/pages/privatebrowsing.css";

      @import "${tme}/parts/video-player.css";
    '';
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "browser.uidensity" = 2;
      "browser.tabs.inTitlebar" = 1;
    };
  };
}
