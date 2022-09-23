{ lib }:

with lib.attrsets;

{
  # Recursively collects all values.
  attrValuesRecursive = collect (v: !builtins.isAttrs v);
}
