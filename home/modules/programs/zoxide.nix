{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkAfter;
  cfg = config.abszero.programs.zoxide;
in

{
  options.abszero.programs.zoxide = {
    enable = mkEnableOption "zoxide";
    enableNushellIntegration =
      mkEnableOption "directory history completion"
      // { default = true; };
  };

  config = mkIf cfg.enable {
    programs = {
      zoxide.enable = true;

      # After carapace sets up completions
      # https://www.nushell.sh/cookbook/external_completers.html
      nushell.extraConfig = mkIf cfg.enableNushellIntegration (mkAfter ''
        let zoxide_completer = {|spans|
          $spans | skip 1 | zoxide query -l ...$in | lines | where $it != $env.PWD
        }

        let zoxide_prev_completer = $env.config?.completions?.external?.completer? | default echo

        let zoxide_next_completer = {|spans|
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
            __zoxide_z | __zoxide_zi => $zoxide_completer
            _ => $zoxide_prev_completer
          } | do $in $spans
        }

        $env.config = ($env.config?
        | default {}
        | merge { completions: { external: { completer: $zoxide_next_completer } } })
      '');
    };
  };
}
