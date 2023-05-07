{ inputs, ... }:
{
  xdg = {
    configFile."fcitx5/conf/classicui.conf".text = ''
      Theme=catppuccin-latte
      Vertical Candidate List=True
      Font="Noto Sans 14"
    '';
    dataFile."fcitx5/themes/catppuccin-latte".source =
      "${inputs.catppuccin-fcitx5}/src/catppuccin-latte";
  };
}
