{ config, inputs, ... }:

let cfg = config.nixfiles.themes.catppuccin; in

{
  imports = [ ./fonts.nix ];

  xdg = {
    configFile."fcitx5/conf/classicui.conf".text = ''
      Theme=catppuccin-${cfg.variant}
      Vertical Candidate List=True
      Font="Noto Sans 13"
      MenuFont="Open Sans 13"
      TrayFont="Open Sans 13"
      TrayOutlineColor=#ffffff00
      TrayTextColor=#000000
      PreferTextIcon=True
    '';
    dataFile."fcitx5/themes/catppuccin-${cfg.variant}".source =
      "${inputs.catppuccin-fcitx5}/src/catppuccin-${cfg.variant}";
  };
}
