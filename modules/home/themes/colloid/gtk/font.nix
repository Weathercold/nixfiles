# noauto
{ pkgs, ... }:
{
  gtk.font = {
    package = pkgs.open-sans;
    name = "Open Sans";
    size = 14;
  };
}
