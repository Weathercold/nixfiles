{ lib }:

with lib;
with builtins;

rec {
  # Recursively collects all values.
  attrValuesRecursive = collect (v: !isAttrs v);

  # Recursively merge attribute sets and lists.
  # This assumes that overriden options are of the same type.
  recursiveMerge = zipAttrsWith
    (_: v:
      if all isAttrs v then recursiveMerge v
      else if all isList v then concatLists v
      else last v
    );

  # Find the first attribute verified by the predicate and return the name.
  findName = pred: attrs: elemAt (attrNames (filterAttrs pred attrs)) 0;
  # Find the first attribute verified by the predicate and return the value.
  findValue = pred: attrs: elemAt (attrValues (filterAttrs pred attrs)) 0;
}
