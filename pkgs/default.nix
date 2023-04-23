{ pkgs }:

let inherit (pkgs) callPackage; in

rec {
  anki-qt6 = callPackage ./games/anki/anki-qt6.nix { };

  plymouth-themes = callPackage ./data/themes/plymouth-themes { };

  vscode-insiders = callPackage ./applications/editors/vscode/vscode-insiders.nix { };
  vscode-insiders-with-extensions =
    pkgs.vscode-with-extensions.override { vscode = vscode-insiders; };

  vscodium-insiders = callPackage ./applications/editors/vscode/vscodium-insiders.nix { };
}
