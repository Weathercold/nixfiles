{ lib, ... }:
{
  flake.lib = import ./. { inherit lib; };
}
