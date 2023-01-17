{ inputs, config, lib, ... }:

let cfg = config.nixfiles.programs.firefox; in

{
  imports = [ ../../programs/firefox.nix ];

  programs.firefox.profiles.${cfg.profile}.userChrome =
    lib.mkBefore ''@import "${inputs.firefox-vertical-tabs}/userChrome.css";'';
}
