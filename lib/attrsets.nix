{ lib, trivial }:

let
  inherit (lib) collect filterAttrs zipAttrsWith last;
  inherit (builtins) isAttrs isList attrNames attrValues all head concatLists;
  inherit (lib.nixfiles) notf;
in

rec {
  # Recursively collects all values.
  attrValuesRecursive = collect (notf isAttrs);

  # Recursively merge attribute sets and lists.
  # This assumes that overriden options are of the same type.
  recursiveMerge = zipAttrsWith
    (_: v:
      if all isAttrs v then recursiveMerge v
      else if all isList v then concatLists v
      else last v
    );

  # Find the first attribute verified by the predicate and return the name.
  findName = pred: attrs: head (attrNames (filterAttrs pred attrs));
  # Find the first attribute verified by the predicate and return the value.
  findValue = pred: attrs: head (attrValues (filterAttrs pred attrs));
}
