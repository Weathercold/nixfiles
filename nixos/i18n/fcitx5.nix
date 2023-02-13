{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nixfiles.i18n.inputMethod.fcitx5;
in

{
  options.nixfiles.i18n.inputMethod.fcitx5.enable =
    mkEnableOption "Next-generation input method framework";

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-chinese-addons
          libsForQt5.fcitx5-qt
          fcitx5-gtk
        ];
      };
    };
    environment.sessionVariables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
    };
  };
}
