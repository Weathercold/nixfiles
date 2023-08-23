{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nixfiles.programs.nushell;
in

{
  options.nixfiles.programs.nushell.enable = mkEnableOption "a new type of shell";

  config.programs.nushell = mkIf cfg.enable {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false
      }

      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu
    '';
  };
}
