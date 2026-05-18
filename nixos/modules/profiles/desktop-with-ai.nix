# Desktop running local AI
{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.abszero.modules) mkExternalEnableOption;
  cfg = config.abszero.profiles.desktopWithAI;
in

{
  imports = [ ./desktop.nix ];

  options.abszero.profiles.desktopWithAI.enable =
    mkExternalEnableOption config "AI-enabled desktop profile";

  config = mkIf cfg.enable {
    abszero = {
      profiles.desktop.enable = true;
      services.ollama.enable = true;
      programs.crush.enable = true;
    };

    services = {
      comfyui = {
        enable = true;
        acceleration = "rocm";
        extraFlags = [
          "--highvram"
          "--preview-method=auto"
        ];
        customNodes = [
          pkgs.comfyui-autocomplete-plus
          pkgs.comfyuiPackages.comfyui-res4lyf
          pkgs.comfyuiPackages.comfyui-rgthree
          # pkgs.comfyui-teacache
        ];
      };
      sillytavern.enable = true;
    };

    environment.systemPackages = with pkgs; [
      context7-mcp
      skills
    ];
  };
}
