# noauto
{ config, pkgs, lib, ... } @ args:

with lib;
with builtins;

let
  cfg = config.nixfiles.themes.firefox;

  # https://github.com/ranmaru22/firefox-vertical-tabs
  vtabs = args.firefox-vertical-tabs or (pkgs.fetchFromGitHub {
    owner = "ranmaru22";
    repo = "firefox-vertical-tabs";
    rev = "cfd92652bd2ab658406eecad58fdc75dfdf97103";
    sha256 = "l5kiDYgqxUFi3UJsq43nAVuj6nVSU5M/5h4YYqeeFCI=";
  });

  forUserChrome = s: {
    programs.firefox.profiles =
      genAttrs cfg.profiles (const { userChrome = s; });
  };
in

mkMerge [
  (forUserChrome (mkBefore ''@import "${vtabs}/userChrome.css";''))

  (forUserChrome ''

    /* Fix placement of window decorations */
    * {
      --uc-win-ctrl-vertical-offset: 0;
    }
  '')
]
