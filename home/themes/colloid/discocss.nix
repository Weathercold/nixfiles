{ inputs, ... }:
{
  programs.discocss.css = builtins.readFile inputs.catppuccin-discord;
}
