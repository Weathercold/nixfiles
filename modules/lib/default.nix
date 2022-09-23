lib:

with lib;

let
  callLib = p: import p { inherit lib; };
in

{
  attrsets = callLib ./attrsets.nix;
  partials = callLib ./partials.nix;
}
