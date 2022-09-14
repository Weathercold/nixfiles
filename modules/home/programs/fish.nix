{
  programs.fish = {
    shellInit = ''
      set -gx SHELL fish
    '';
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
      zoxide init fish | source
    '';
    functions = {
      qcomm = "qfile (which $argv)";
      fetchhash = "nix flake prefetch --json $argv | jq -r .hash";
    };
    shellAliases = {
      ani = "ani-cli";
      c = "clear";
      cat = "bat";
      ls = "exa";
      nf = "neofetch";
      nvl = "~/src/lightnovel.sh/lightnovel.sh";
      zz = "z -";
    };
  };
}
