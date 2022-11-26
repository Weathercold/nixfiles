{ pkgs }:

let inherit (pkgs) callPackage; in

rec {
  vscode-insiders = callPackage ./applications/editors/vscode/vscode-insiders.nix { };
  vscode-insiders-with-extensions =
    pkgs.vscode-with-extensions.override { vscode = vscode-insiders; };

  vscodium-insiders = callPackage ./applications/editors/vscode/vscodium-insiders.nix { };
}
