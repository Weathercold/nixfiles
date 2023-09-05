{
  imports = [ ./base.nix ];

  home.shellAliases = {
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

  abszero = {
    services.gpg-agent.enable = true;
    programs = {
      discord.enable = true;
      dotdrop.enable = true;
      firefox.enable = true;
      git.enable = true;
      nushell.enable = true;
      starship.enable = true;
      thunderbird.enable = true;
    };
  };

  programs = {
    bat.enable = true;
    carapace.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.warn_timeout = "1m";
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
    fzf.enable = true;
    zoxide.enable = true;
  };
}
