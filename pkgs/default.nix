{ pkgs }:

let
  extendedLib = pkgs.lib.extend
    (_: _: { nixfiles = import ../lib { inherit (pkgs) lib; }; });
  extendedPkgs = pkgs.extend
    (_: _: { lib = extendedLib; });
  inherit (extendedPkgs) callPackage;
in

rec {
  anki-qt6 = callPackage ./games/anki/anki-qt6.nix { };
  anki-bin-qt6 = callPackage ./games/anki/anki-bin-qt6.nix { };

  catppuccin-discord = callPackage ./data/themes/catppuccin-discord/git.nix { };

  colloid-gtk-theme-git = callPackage ./data/themes/colloid-gtk-theme/git.nix { };

  plymouth-themes = callPackage ./data/themes/plymouth-themes { };

  vscode-insiders = callPackage ./applications/editors/vscode/vscode-insiders.nix { };
  vscode-insiders-with-extensions =
    pkgs.vscode-with-extensions.override { vscode = vscode-insiders; };

  vscodium-insiders = callPackage ./applications/editors/vscode/vscodium-insiders.nix { };

  win2xcur = callPackage ./tools/misc/win2xcur { };
}
