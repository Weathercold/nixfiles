{ pkgs, ... }:
{
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.latteLight;
    name = "Catppuccin-Latte-Light";
    gtk.enable = true;
    # x11.enable = true;
  };
}
