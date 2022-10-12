{ config
, lib
, pkgs
, ...
} @ args:

with lib;
with builtins;

let
  cfg = config.nixfiles.themes.firefox;

  # FIXME: Module optional args are broken
  # https://github.com/vinceliuice/Colloid-gtk-theme
  colloid-gtk-theme = args.colloid-gtk-theme or (pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Colloid-gtk-theme";
    rev = "824b99b86052427cedd1a63c3413153113efac39";
    sha256 = "Etie1/3sHZfZFxQ6OYHREyeDs+uZvwPplcd2jMmJQcQ=";
  });
  tme = colloid-gtk-theme + "/src/other/firefox/chrome/Colloid";
in

{
  programs.firefox.profiles = genAttrs
    cfg.profiles
    (const {
      userChrome = ''@import "${tme}/theme.css";'';
      userContent = ''
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
    });
}
