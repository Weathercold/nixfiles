# https://starship.rs/config
{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.abszero.programs.starship;
in

{
  options.abszero.programs.starship.enable = mkEnableOption "managing Starship";

  config.programs.starship = mkIf cfg.enable {
    enable = true;
    settings = {
      format = ''
        ($directory )($git_branch )($jobs )($cmd_duration )$fill( $git_state)( $nodejs)( $rust)( $nix_shell)
        ($username$hostname )$character
      '';
      add_newline = false;

      # region Head Left

      directory = {
        format = "([$read_only]($read_only_style) )[$path]($style)";
        # Different format for git repos
        repo_root_format = "([$read_only]($read_only_style) )[]($repo_root_style) [$repo_root]($repo_root_style)[$path]($style)";
        read_only = "󰍁";
        truncation_symbol = "…/";
        # Set these two options so repo_root_format takes effect
        before_repo_root_style = "bold cyan";
        repo_root_style = "bold yellow";
      };
      git_branch = {
        format = "[$symbol $branch]($style)";
        symbol = "󰘬";
        style = "bold yellow";
        ignore_branches = [
          "HEAD"
          "master"
          "main"
        ];
      };
      jobs = {
        format = "$symbol[$number]($style)";
        symbol = "󱓺";
        style = "bold bright-yellow";
      };
      cmd_duration = {
        format = "[$duration]($style)";
        style = "bold blue";
        show_milliseconds = true;
        min_time = 1000;
        show_notifications = true;
        min_time_to_notify = 60000;
      };

      # endregion

      fill.symbol = " ";

      # region Head Right

      git_state = {
        format = "[$state( $progress_current/$progress_total)]($style)";
        style = "bold yellow";
      };
      nodejs = {
        format = "[$symbol $version]($style)";
        symbol = "󰎙";
      };
      rust = {
        format = "[$symbol $version]($style)";
        symbol = "󱘗";
      };
      nix_shell = {
        format = "[$symbol $state]($style)";
        symbol = "";
      };
      # direnv = {
      #   # FIXME: invalid allow status - possibly due to nix-direnv?
      #   # disabled = false;
      #   format = "$allowed$loaded";
      #   allowed_msg = "";
      #   denied_msg = "[󱏵](bold red)";
      #   loaded_msg = "[󰂖](bold purple)";
      #   unloaded_msg = "[󰂕](bold yellow)";
      # };

      # endregion
      # region Prompt Left

      username.format = "[$user]($style)";
      hostname.format = "@[$hostname]($style)";
      character = {
        success_symbol = "[󰘧](bold green)";
        error_symbol = "[󰘧](bold red)";
      };

      # endregion
    };
  };
}
