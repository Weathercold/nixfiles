{ config, ... }:
{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -gx SHELL fish
    '';
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      zoxide init fish | source
      if hostname | grep -q nixos
        starship init fish | source
      end
    '';
    functions = {
      qcomm = "qfile (which $argv)";
    };
    shellAliases = {
      ani = "ani-cli";
      nf = "neofetch";
      nvl = "~/src/lightnovel.sh/lightnovel.sh";
      zz = "z -";
    };
  };
}
