{ pkgs, ... }:
{
  imports = [
    ../programs/fish.nix
    ../programs/starship.nix
    ../programs/dotdrop.nix
    ../programs/firefox.nix
  ];

  home = {
    username = "weathercold";
    homeDirectory = "/home/weathercold";
    stateVersion = "22.11";
    packages = with pkgs; [
      any-nix-shell
      colloid-kde
      colloid-gtk-theme
      colloid-icon-theme
    ];
  };

  programs = {
    home-manager.enable = true;

    fzf.enable = true;
  };
}
