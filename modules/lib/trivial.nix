{ lib }:

with builtins;

{
  join = a: b: lib.throwIfNot
    (isString a && isString b)
    "Argument(s) not string: ${a} ${b}"
    a + b;
}
