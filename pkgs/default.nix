{ pkgs }:

let
  extendedLib = pkgs.lib.extend
    (_: _: { abszero = import ../lib { inherit (pkgs) lib; }; });
  extendedPkgs = pkgs.extend
    (_: _: { lib = extendedLib; });
  inherit (extendedPkgs) callPackage;
in

rec {
  anki-qt6 = callPackage ./an/anki/anki-qt6.nix { };
  anki-bin-qt6 = callPackage ./an/anki/anki-bin-qt6.nix { };

  catppuccin-discord = callPackage ./ca/catppuccin-discord/git.nix { };

  colloid-gtk-theme-git = callPackage ./co/colloid-gtk-theme/git.nix { };

  plymouth-themes = callPackage ./pl/plymouth-themes { };

  vscode-insiders = callPackage ./vs/vscode/vscode-insiders.nix { };
  vscode-insiders-with-extensions =
    pkgs.vscode-with-extensions.override { vscode = vscode-insiders; };

  vscodium-insiders = callPackage ./vs/vscode/vscodium-insiders.nix { };

  v2ray-rules-dat = callPackage ./v2/v2ray-rules-dat/bin.nix { };

  win2xcur = callPackage ./wi/win2xcur { };
}
