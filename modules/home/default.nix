lib:
rec {
  default = {
    programs = {
      dotdrop = ./programs/dotdrop.nix;
      exa = ./programs/exa.nix;
      firefox = ./programs/firefox;
      fish = ./programs/fish.nix;
      starship = ./programs/starship.nix;
    };
  };

  all = lib.recursiveUpdate default {
    theme-colloid = {
      firefox = ./programs/firefox/theme-colloid.nix;
    };
  };
}
