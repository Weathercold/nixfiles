{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.abszero.programs.nushell;
in

{
  options.abszero.programs.nushell.enable = mkEnableOption "a new type of shell";

  config.programs.nushell = mkIf cfg.enable {
    enable = true;
    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ani = "ani-cli";
      c = "clear";
      lns = "ln -s";
      nf = "neofetch";
      zz = "z -";
    };
    extraConfig = ''
      $env.config = {
        show_banner: false
      }

      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu
    '';
  };
}
