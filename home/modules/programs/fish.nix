{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkAfter;
  cfg = config.abszero.programs.fish;
in

{
  options.abszero.programs.fish = {
    enable = mkEnableOption "managing fish";
    enableNushellIntegration =
      mkEnableOption "using fish as an external completer"
      // { default = true; };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ any-nix-shell ];

    programs = {
      fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting ""
          any-nix-shell fish --info-right | source
        '';
        functions = {
          qcomm = "qfile (which $argv)";
          fetchhash = "nix flake prefetch --json $argv | jq -r .hash";
        };
      };

      # After carapace sets up completions
      # https://www.nushell.sh/cookbook/external_completers.html
      nushell.extraConfig = mkIf cfg.enableNushellIntegration (mkAfter ''
        let fish_completer = {|spans|
          echo $spans
          fish -ic $'complete "--do-complete=($spans | str join " ")"'
          | $"value(char tab)description(char newline)" + $in
          | from tsv --flexible --no-infer
        }

        let fish_prev_completer = $env.config?.completions?.external?.completer? | default echo

        let fish_next_completer = {|spans|
          let expanded_alias = scope aliases
          | where name == $spans.0
          | get -i 0.expansion

          let spans = if $expanded_alias != null {
            $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
          } else {
            $spans
          }

          match $spans.0 {
            nix => $fish_completer
            _ => $fish_prev_completer
          } | do $in $spans
        }

        $env.config = ($env.config?
        | default {}
        | merge { completions: { external: { completer: $fish_next_completer } } })
      '');
    };
  };
}
