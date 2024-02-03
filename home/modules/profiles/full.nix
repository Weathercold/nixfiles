{
  imports = [ ./base.nix ];

  abszero = {
    services.gpg-agent.enable = true;
    programs = {
      direnv.enable = true;
      dotdrop.enable = true;
      firefox.enable = true;
      git.enable = true;
      nushell.enable = true;
      starship.enable = true;
      thunderbird.enable = true;
    };
  };

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

  programs = {
    bat.enable = true;
    carapace.enable = true;
    eza = {
      enable = true;
      enableAliases = true;
      git = true;
      icons = true;
    };
    fzf.enable = true;
    nix-index-database.comma.enable = true;
    zoxide.enable = true;
  };
}
