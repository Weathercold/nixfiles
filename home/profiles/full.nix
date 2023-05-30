{ pkgs, lib, ... }:

let inherit (lib.nixfiles) collectModules; in

{
  imports = [ ./base.nix ]
    ++ collectModules ../accounts
    ++ collectModules ../programs
    ++ collectModules ../services;

  home = {
    packages = with pkgs; [
      any-nix-shell
    ];

    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ani = "ani-cli";
      c = "clear";
      cat = "bat";
      lns = "ln -s";
      nf = "neofetch";
      nvl = "~/src/lightnovel.sh/lightnovel.sh";
      zz = "z -";
    };
  };

  nixfiles = {
    programs = {
      discord.enable = true;
      dotdrop.enable = true;
      firefox.enable = true;
      fish.enable = true;
      git.enable = true;
      starship.enable = true;
      thunderbird.enable = true;
    };
  };

  programs = {
    bat.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
    fzf.enable = true;
    zoxide.enable = true;
  };
}
