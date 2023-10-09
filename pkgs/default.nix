{ pkgs }:

let
  lib = pkgs.lib.extend
    (_: _: { abszero = import ../lib { inherit (pkgs) lib; }; });
  extPkgs = pkgs.extend (_: _: { inherit lib; });
  pkgsByName = lib.abszero.filesystem.toPackages extPkgs ./.;
in

pkgsByName // {
  vscode-insiders-with-extensions =
    extPkgs.vscode-with-extensions.override {
      vscode = pkgsByName.vscode-insiders;
    };
}
