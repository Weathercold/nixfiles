{ pkgs
, haumea ? null
}:

let
  extLib = pkgs.lib.extend (_: prev: {
    abszero = import ../lib
      ({ lib = prev; }
        // prev.optionalAttrs (haumea != null) { inherit haumea; });
  });
  extPkgs = pkgs.extend (_: _: { lib = extLib; });
  pkgsByName = extLib.abszero.filesystem.toPackages extPkgs ./.;
in

pkgsByName // {
  vscode-insiders-with-extensions =
    extPkgs.vscode-with-extensions.override {
      vscode = pkgsByName.vscode-insiders;
    };
}
