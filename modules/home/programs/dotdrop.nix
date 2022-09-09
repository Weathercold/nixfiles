{ dotdropComp, ... }:
{
  programs.fish.shellAliases = {
    dotdrop = "~/src/dotfiles/scripts/dotdrop.sh";
    dotsync = "~/src/dotfiles/scripts/dotsync.sh";
    sysdrop = "~/src/sysfiles/scripts/dotdrop.sh";
    syssync = "~/src/sysfiles/scripts/dotsync.sh";
  };
  xdg.configFile."fish/completions/dotdrop.fish".source = dotdropComp;
}
