{ lib }:

let
  callLib = m: import m { inherit lib; };
  callLibWith = m: args: import m ({ inherit lib; } // args);
in

rec {
  attrsets = callLibWith ./attrsets.nix { inherit trivial; };
  filesystem = callLibWith ./filesystem.nix { inherit strings; };
  partials = callLibWith ./partials.nix { inherit attrsets; };
  strings = callLib ./strings.nix;
  trivial = callLib ./trivial.nix;

  inherit (attrsets) findName findValue;
  inherit (filesystem) listDirs listFiles genModules collectModules;
  inherit (partials) partialSet;
  inherit (strings) isEncrypted;
  inherit (trivial) const2 notf join;
}
