{ lib, ... }:

with lib;

{
  partialSet = f: args1: args2: f (recursiveUpdate args1 args2);
}
