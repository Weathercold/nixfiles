{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.abszero.services.comfyui;
  comfyuiCfg = config.services.comfyui;
in

{
  options.abszero.services.comfyui.enable = mkEnableOption "comfyui generative AI frontend";

  config.services = mkIf cfg.enable {
    comfyui = {
      enable = true;
      extraArgs = [
        "--highvram"
        "--use-pytorch-cross-attention"
        "--enable-triton-backend"
        "--enable-manager"
      ];
      extraPackages =
        comfyPkgs:
        with pkgs;
        with comfyPkgs;
        [
          comfyui-anima-booster
          comfyui-manager
          # comfyui-res4lyf
        ]
        # Install dependencies for plugins managed by ComfyUI-Manager
        ++ (comfyui-lora-manager.override { python3 = python; }).propagatedBuildInputs;
    };
    tailscale.serve.services.comfyui.endpoints."tcp:80" =
      "http://127.0.0.1:${toString comfyuiCfg.port}";
  };
}
