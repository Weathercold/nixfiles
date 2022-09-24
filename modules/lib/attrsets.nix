{ lib }:

with builtins;
with lib;

rec {
  # Recursively collects all values.
  attrValuesRecursive = attrsets.collect (v: !isAttrs v);

  # Recursively merge attribute sets and lists.
  # This assumes that overriden options are of the same type.
  recursiveMerge = zipAttrsWith
    (n: v:
      if all isAttrs v then recursiveMerge v
      else if all isList v then concatLists v
      else lists.last v
    );
}
