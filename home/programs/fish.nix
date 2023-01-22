{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixfiles.programs.fish;
in

{
  options.nixfiles.programs.fish.enable = mkEnableOption "managing fish";

  config.programs.fish = mkIf cfg.enable {
    enable = true;
    shellInit = ''
      set -gx SHELL fish
    '';
    interactiveShellInit = ''
      set fish_greeting ""
      any-nix-shell fish --info-right | source
    '';
    functions = {
      qcomm = "qfile (which $argv)";
      fetchhash = "nix flake prefetch --json $argv | jq -r .hash";
    };
    shellAliases = {
      ani = "ani-cli";
      c = "clear";
      nf = "neofetch";
      nvl = "~/src/lightnovel.sh/lightnovel.sh";
      zz = "z -";
    };
  };
}
