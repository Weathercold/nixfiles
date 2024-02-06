{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.abszero.programs.carapace;
in

{
  options.abszero.programs.carapace = {
    enable = mkEnableOption "carapace";
    enableNushellIntegration =
      mkEnableOption "custom Nushell integration with some fixes"
      // { default = true; };
  };

  config.programs = mkIf cfg.enable {
    carapace = {
      enable = true;
      enableNushellIntegration = false; # Use custom integration
    };

    # https://www.nushell.sh/cookbook/external_completers.html
    nushell.extraConfig = mkIf cfg.enableNushellIntegration ''
      let carapace_completer = {|spans: list<string>|
        carapace $spans.0 nushell ...$spans
        | from json
        | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
      }

      $env.config = ($env.config?
      | default {}
      | merge { completions: { external: { completer: $carapace_completer } } })
    '';
  };
}
