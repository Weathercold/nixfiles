lib:

with lib;

let
  callLib = p: import p { inherit lib; };
in

rec {
  attrsets = callLib ./attrsets.nix;
  partials = import ./partials.nix { inherit lib attrsets; };
}
