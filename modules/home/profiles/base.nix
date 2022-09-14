{ pkgs
, username
, homeDirectory
, ...
}:
{
  home = {
    inherit username homeDirectory;
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
    fish.enable = true;
    starship.enable = true;
    dotdrop.enable = true;
    firefox.enable = true;
    bat.enable = true;
    fzf.enable = true;
  };
}
