{ inputs, config, pkgs, ... }:
{
  xdg = {
    configFile."fcitx5/conf/classicui.conf".text = ''
      Theme=catppuccin-latte
      Vertical Candidate List=False
      Font="Open Sans 13"
    '';
    dataFile."fcitx5/themes/catppuccin-latte".source =
      "${inputs.catppuccin-fcitx5}/src/catppuccin-latte";
  };
}
