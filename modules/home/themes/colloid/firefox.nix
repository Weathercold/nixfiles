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
    rev = "ae82a48673f74e11c9a074ced17d7724b394d98a";
    sha256 = "wM2Uh1e+GVrm52YE5HESSXWkudDdAsagMTrH8tw1lFk=";
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
