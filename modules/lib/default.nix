lib:

let callLib = p: import p { inherit lib; }; in

rec {
  attrsets = callLib ./attrsets.nix;
  filesystem = import ./filesystem.nix { inherit lib trivial; };
  partials = import ./partials.nix { inherit lib attrsets; };
  strings = callLib ./strings.nix;
  trivial = callLib ./trivial.nix;
}
