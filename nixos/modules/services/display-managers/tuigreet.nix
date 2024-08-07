{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.abszero.services.displayManager.tuigreet;
in

{
  options.abszero.services.displayManager.tuigreet.enable = mkEnableOption "tui greetd frontend";

  config.services.greetd = mkIf cfg.enable {
    enable = true;
    vt = 2;
    settings.default_session.command = ''
      ${getExe pkgs.greetd.tuigreet} \
        -rt --asterisks \
        --window-padding 1 \
        --power-shutdown 'systemctl poweroff' \
        --power-reboot 'systemctl reboot'
    '';
  };
}
